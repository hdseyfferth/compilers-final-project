#pragma once

#include <assert.h>
#include <map>
#include <string>
#include <vector>

#include "AST.hpp"
#include "helpers.hpp"
#include "lexer.hpp"

using emplex::Lexer;
using emplex::Token;
class ASTNode;

struct VarInfo {
  std::string name;
  size_t def_line;
  Type type;
};

struct FunInfo {
  std::string name;
  size_t fun_id;
  std::vector<size_t> param_ids = {}; // IDs of variables used as parameters.
  std::vector<size_t> local_ids = {}; // IDs of variables local to this function.
  ASTNode body{};                     // ASTNode for function body.
  Type return_type = Type::UNKNOWN;   // Must set a return type before calling function.
  bool builtin = false;               // Check if a function is built-in vs. user defined
};

class SymbolTable {
public:
  // Helper ID (at max value) to indicate that no ID was found or is available.
  static constexpr size_t NO_ID = static_cast<size_t>(-1);

private:
  std::vector<VarInfo> vars; // Set of ALL variables organized by ID.
  std::vector<FunInfo> funs; // Set of all functions, organized by ID.

  std::vector<size_t> global_vars; // Set of global variables organized by ID
  std::map<std::string, ASTNode> global_inits; // Map global variable names to their initializations

  using scope_t = std::map<std::string, size_t>; // Map of vars in a scope to their IDs.
  std::vector<scope_t> scopes;

  std::map<std::string, size_t> fun_map;  // Map of function names to their IDs.

  size_t next_while_id = 1;
  std::vector<size_t> while_ids; // Which while loops are we currently in?

  // Checks to ensure we don't try to use invalid var ids.
  VarInfo & Var(size_t id) { assert(id < vars.size()); return vars[id]; }
  const VarInfo & Var(size_t id) const { assert(id < vars.size()); return vars[id]; }

  // Look up the unique ID of a variable.
  [[nodiscard]] size_t FindVarID(std::string name) const {
    size_t scope_id = FindScopeID(name);
    if (scope_id == NO_ID) return NO_ID;
    return scopes[scope_id].find(name)->second;
  }

  // Determine which scope a symbol is in; use one past the end if variable is not included.
  [[nodiscard]] size_t FindScopeID(std::string name) const {
    for (size_t scope_id = scopes.size()-1; scope_id < scopes.size(); --scope_id) {
      if (scopes[scope_id].contains(name)) return scope_id;
    }
    return NO_ID;
  }

public:
  SymbolTable() {
    IncScope(); // Create global scope.
  }

  // === GLOBAL VARIABLES ===

  size_t AddGlobalVar(Token id_token, Token type_token) {
    return AddGlobalVar(id_token, NameToType(type_token.lexeme));
  }

  size_t AddGlobalVar(Token id_token, Type type) {
    std::string name = id_token.lexeme;
  
    // Check if this name already exists as a global
    if (HasVarSymbol(name)) {
      Error(id_token.line_id, "Redeclaration of variable '", name, "'");
    }
    
    // Create variable and add to global scope
    size_t var_id = vars.size();
    vars.push_back(VarInfo{name, id_token.line_id, type});
    scopes[0][name] = var_id;
    
    // Record variable
    global_vars.push_back(var_id);
    
    return var_id;
  }

  // Store initialization AST for globals here
  void AddGlobalInit(std::string name, ASTNode expr) {
    global_inits[name] = std::move(expr);
  }

  [[nodiscard]] const std::vector<size_t>& GetGlobalVars() const {
  return global_vars;
  }

  // Check if the global var has an initialization
  [[nodiscard]] bool HasInitExpr(std::string name) const {
    return global_inits.contains(name);
  }

  [[nodiscard]] ASTNode& GetInitExpr(std::string name) {
    return global_inits[name];
  }

  [[nodiscard]] bool IsGlobal(size_t var_id) const {
    // Check if this var exists in list
    return std::find(global_vars.begin(), global_vars.end(), var_id) != global_vars.end();
  }


  // === SCOPES ===

  void IncScope() { scopes.emplace_back(); }
  void DecScope() { scopes.pop_back(); }

  // === VARIABLES ===

  [[nodiscard]] bool HasID(size_t id) const { return id < vars.size(); }
  [[nodiscard]] bool HasVarSymbol(std::string name) const {
    return FindScopeID(name) < scopes.size();
  }
  [[nodiscard]] std::string GetName(size_t id) const {
    return Var(id).name;
  }
  [[nodiscard]] Type GetType(size_t id) const {
    return Var(id).type;
  }
  [[nodiscard]] std::string GetWATType(size_t id) const {
    return ToWATType(Var(id).type);
  }

  size_t AddSymbol(Token id_token, Token type_token, bool is_param=false) {
    return AddSymbol(id_token, NameToType(type_token.lexeme), is_param);
  }

  size_t AddSymbol(Token id_token, Type type, bool is_param=false) {
    assert(scopes.size() > 0);
    std::string name = id_token.lexeme;

    // Symbols focus on only CURRENT scope.
    scope_t & symbols = scopes.back();
    if (symbols.contains(name)) {
      Error(id_token.line_id, "Redeclaration of variable '", name,
            "' (originally defined on line ", vars[symbols[name]].def_line, ")");
    }

    // // Check if name conflicts
    // if (HasFunSymbol(name)) {
    //   Error(id_token.line_id, "Variable '", name, "' conflicts with function name");
    // }

    size_t var_id = vars.size();
    vars.push_back(VarInfo{name, id_token.line_id, type});
    symbols[name] = var_id;

    // List this variable as part of the function it is in.
    assert(funs.size() > 0);
    if (is_param) funs.back().param_ids.push_back(var_id);
    else funs.back().local_ids.push_back(var_id);

    return var_id;
  }

  // Get the ID of a symbol that is expected to be in the symbol table; throw error if not there.
  [[nodiscard]] size_t GetSymbolID(Token token) const {
    std::string name = token.lexeme;
    size_t var_id = FindVarID(name);
    if (var_id == NO_ID) { Error(token, "Unknown variable '", name, "'"); }
    return var_id;
  }

  // === FUNCTIONS ===
  [[nodiscard]] bool HasFunSymbol(std::string name) const {
    return fun_map.contains(name);
  }

  [[nodiscard]] size_t GetFunID(std::string name) const {
    auto it = fun_map.find(name);
    if (it == fun_map.end()) return NO_ID;
    return it->second;
  }

  size_t AddFunction(std::string name) {
    size_t fun_id = funs.size();
    funs.push_back(FunInfo{name, fun_id});
    fun_map[name] = fun_id;
    return fun_id;
  }

  void AddFunctionBody(ASTNode && body) {
    funs.back().body = std::move(body);
  }

  void AddFunctionReturn(Type return_type) { funs.back().return_type = return_type; }
  void AddFunctionReturn(Token token) { AddFunctionReturn(NameToType(token.lexeme)); }

  [[nodiscard]] size_t GetNumFuns() const { return funs.size(); }

  [[nodiscard]] const FunInfo & GetFunInfo(size_t id) const { return funs[id]; }

  [[nodiscard]] std::string GetFunName(size_t id) const {
    return funs[id].name;
  }
  [[nodiscard]] ASTNode & GetFunBody(size_t id) {
    return funs[id].body;
  }
  [[nodiscard]] const std::vector<size_t> & GetFunParams(size_t fun_id) const {
    assert(fun_id < funs.size());
    return funs[fun_id].param_ids;
  }
  [[nodiscard]] size_t GetNumParams(size_t fun_id) const {
        return funs[fun_id].param_ids.size();
  }
  [[nodiscard]] const std::vector<size_t> & GetFunLocals(size_t id) {
    return funs[id].local_ids;
  }

  [[nodiscard]] Type GetReturnType(size_t fun_id) const {
    assert(fun_id < funs.size());
    return funs[fun_id].return_type;
  }

  // Add this method to register built-in functions with parameters
  void AddBuiltInFunction(std::string name, Type return_type, std::vector<Type> param_types) {
    size_t fun_id = AddFunction(name);
    funs[fun_id].return_type = return_type;
    funs[fun_id].builtin = true;
    
    // Add parameters - we need dummy variables for each parameter
    for (size_t i = 0; i < param_types.size(); ++i) {
      size_t var_id = vars.size();
      std::string param_name = name + "_param" + std::to_string(i);
      vars.push_back(VarInfo{param_name, 0, param_types[i]});
      funs[fun_id].param_ids.push_back(var_id);
    }
  }

  [[nodiscard]] bool IsBuiltIn(size_t fun_id) const {
    assert(fun_id < funs.size());
    return funs[fun_id].builtin;
  }

};