#pragma once

// Visitor pattern for moving though an AST and ensuring all semantics are valid.

#include <string>

#include "AST.hpp"
#include "lexer.hpp"
#include "SymbolTable.hpp"

class Semantics {
private:
  SymbolTable & symbols;               // Full symbol table
  // Use to make sure return type is correct
  size_t fun_id = SymbolTable::NO_ID;  // Current function being analyzed.
  // Check if in a while loop or nexted while loop
  size_t while_depth = 0;              // Track how deep into a while loop we are.

  // === HELPER FUNCTIONS ===
  // !!!!!! The functions in this section are not currently needed, but
  //        will be useful for Project 4.

  bool IsNumeric(Type type) const { return (type == Type::INT || type == Type::DOUBLE); }

  bool IsString(Type type) const { return (type == Type::STRING); }

  bool HasString(Type type0, Type type1) const { return (type0 == Type::STRING || type1 == Type::STRING); }


  void RequireInt(ASTNode & node, Type test_type, std::string error) {
    if (test_type != Type::INT) {
      node.Error(error, "; type ", TypeToName(test_type), " found.");
    }
  }

  void RequireString(ASTNode & node, Type test_type, std::string error) {
    if (test_type != Type::STRING) {
      node.Error(error, "; type ", TypeToName(test_type), " found.");
    }
  }

  void RequireNumeric(ASTNode & node, Type test_type, std::string error) {
    if (test_type != Type::INT && test_type != Type::DOUBLE) {
      node.Error(error, "; type ", TypeToName(test_type), " found.");
    }
  }

  void ValidateOperands(ASTNode & node, Type type0, Type type1) {
    RequireNumeric(node, type0, "Type mismatch: Left operand must be numeric");
    RequireNumeric(node, type1, "Type mismatch: Right operand must be numeric");
  }

  bool IsValidStringOp(Type type0, Type type1) const {
    if (type0 == Type::STRING && type1 == Type::STRING) {
      return true;
    }
    else if (type0 == Type::STRING && type1 == Type::INT) {
      return true;
    }
    else if (type0 == Type::INT && type1 == Type::STRING) {
      return true;
    }
    else {
      return false;
    }
  }

public:
  Semantics(SymbolTable & symbols) : symbols(symbols) { }

  // Analyze all functions in the symbol table.
  void Analyze() {
    // Check for main function before other functions
    bool main = false;

    // Analyze global variable initializations first
    const std::vector<size_t>& global_vars = symbols.GetGlobalVars();
    for (size_t var_id : global_vars) {
      std::string var_name = symbols.GetName(var_id);

      if (symbols.HasInitExpr(var_name)) {
      // Analyze init expression
      Type init_type = Analyze(symbols.GetInitExpr(var_name));
      Type var_type = symbols.GetType(var_id);
      }
    }
    // Do full semantic analysis on all functions.
    // Semantics object always knows what function it is in
    for (fun_id = 0; fun_id < symbols.GetNumFuns(); ++fun_id) {
      // Skip built-in functions
      if (symbols.IsBuiltIn(fun_id)) continue;
      // Check for Main function
      const FunInfo & fun_info = symbols.GetFunInfo(fun_id);
      if (fun_info.name == "Main") {
        main = true;
      }
      Analyze(symbols.GetFunBody(fun_id));
    }
    if (!main) {
      std::cerr << "Error: Program must have a Main() function" << std::endl;
      exit(1);
    }
  }

    // Analyze a given sub-tree.
  Type Analyze(ASTNode & node) {
    Type type = Type::UNKNOWN;
    switch (node.GetNodeType()) {
    case ASTType::BLOCK: type = Analyze_BLOCK(node); break;
    case ASTType::BREAK: type = Analyze_BREAK(node); break;
    case ASTType::CONTINUE: type = Analyze_CONTINUE(node); break;
    case ASTType::IF: type = Analyze_IF(node); break;
    case ASTType::LIT_DOUBLE: type = Analyze_LIT_DOUBLE(node); break;
    case ASTType::LIT_INT: type = Analyze_LIT_INT(node); break;
    case ASTType::LIT_STRING: type = Analyze_LIT_STRING(node); break;
    case ASTType::OP1: type = Analyze_OP1(node); break;
    case ASTType::OP2: type = Analyze_OP2(node); break;
    case ASTType::INDEX: type = Analyze_INDEX(node); break;
    case ASTType::RETURN: type = Analyze_RETURN(node); break;
    case ASTType::VAR: type = Analyze_VAR(node); break;
    case ASTType::CALL: type = Analyze_FUNC(node); break;
    case ASTType::WHILE: type = Analyze_WHILE(node); break;
    default:
      std::cerr << "Internal Compiler Error: Unknown AST Node '"
                << TypeToName(node.GetNodeType()) << "'." << std::endl;
      exit(2);
    }

    node.SetType(type);
    return type;
  }

  // BLOCKs dont have required semantics, but their children all need to be tested.
  Type Analyze_BLOCK(ASTNode & node) {
    for (size_t i = 0; i < node.NumChildren(); ++i) { Analyze(node.Child(i)); }
    return Type::NONE;
  }

  Type Analyze_BREAK(ASTNode & node) {
    assert(node.NumChildren() == 0);
    if (while_depth == 0) {
      node.Error("All 'break' statements must be used inside of 'while' loops.");
    }
    return Type::NONE;
  }

  Type Analyze_CONTINUE(ASTNode & node) {
    assert(node.NumChildren() == 0);
    if (while_depth == 0) {
      node.Error("All 'continue' statements must be used inside of 'while' loops.");
    }
    return Type::NONE;
  }

  Type Analyze_IF(ASTNode & node) {
    assert(node.NumChildren() >= 2 && node.NumChildren() <= 3);

    // !!!!!! This is an example of type checking; not needed in Project 3, just Project 4+
    // when checking cond of if, condition has to be numeric, or report error
    Type cond_type = Analyze(node.Child(0));
    RequireNumeric(node, cond_type, "Type mismatch: If 'condition' must be numeric");

    // Analyze THEN and ELSE sub-trees.
    Analyze(node.Child(1));
    if (node.NumChildren() > 2) Analyze(node.Child(2));

    return Type::NONE;
  }

  Type Analyze_LIT_DOUBLE([[maybe_unused]] ASTNode & node) {
    assert(node.NumChildren() == 0);
    return Type::DOUBLE;
  }

  Type Analyze_LIT_INT([[maybe_unused]] ASTNode & node) {
    assert(node.NumChildren() == 0);
    return Type::INT;
  }

  Type Analyze_LIT_STRING([[maybe_unused]] ASTNode & node) {
    assert(node.NumChildren() == 0);
    return Type::STRING;
  }

  Type Analyze_OP1(ASTNode & node) {
    assert(node.NumChildren() == 1);

    // Perform semantic analysis on the sub-tree and determine the type it returns.
    // !!!!!! You will need:
    [[maybe_unused]] Type type = Analyze(node.Child(0));
    std::string op = node.GetLexeme();
    // !!!!!! Depending on the type of 'op', make sure child sub-tree is valid for operation
    // !!!!!! May need to return different type based on operation performed.
    if (op == "!") {
      RequireNumeric(node, type, "Operand of '!' must be numeric");
      return Type::INT;
    }
    else if (op == "-") {
      RequireNumeric(node, type, "Operand of '-' must be numeric");
      return type;
    }
    else if (op == "#") {
      RequireString(node, type, "Operand of '#' must be a string");
      return Type::INT;
    }
    node.Error("Unknown operator ", op);
    return Type::UNKNOWN;
  }

  Type Analyze_OP2(ASTNode & node) {
    assert(node.NumChildren() == 2);

    // Perform semantic analysis on the sub-trees and determine the types they return.
    // !!!!!! You will need:
    Type type0 = Analyze(node.Child(0));
    Type type1 = Analyze(node.Child(1));
    std::string op = node.GetLexeme();
    // !!!!!! Depending on 'op', ensure child sub-tree result types are valid for operation.
    if (op == "=") {
      if (!node.Child(0).CanAssign()) {
        node.Error("Left-hand-side of assignment must be a variable.");
      }
      // Check types match
      if (CanPromote(type1, type0)) {
        return type0;
      }
      else {
        node.Error("Invalid types for assignment", TypeToName(type1), " to ", TypeToName(type0));
      }
    }

    if (IsComparisonOp(op)) {
      ValidateOperands(node, type0, type1);
      return Type::INT;
    }

    if (op == "**") {
      ValidateOperands(node, type0, type1);
      return Type::DOUBLE;
    }

    if (op == "%") {
      RequireInt(node, type0, "Left operand must be an int");
      RequireInt(node, type1, "Right operand must be an int");
      return Type:: INT;
    }

    if (op == ":<" || op == ":>") {
      ValidateOperands(node, type0, type1);
      return CombineNumerics(type0, type1);
    }

    if (IsArithmeticOp(op)) {
      if (HasString(type0, type1)) {
        if (op == "+" || op == "*") {
          if (IsValidStringOp(type0, type1)) {
            return Type::STRING;
          }
        }
        node.Error("Failed to concatenate string");
      }
      ValidateOperands(node, type0, type1);
      return CombineNumerics(type0, type1);
    }

    node.Error("Unknown operator ", op);
    return Type::UNKNOWN;
  }

  Type Analyze_INDEX(ASTNode & node) {
    assert(node.NumChildren() == 2);

    Type type0 = Analyze(node.Child(0));
    RequireString(node, type0, "Must be a string to use index operator");
    
    Type type1 = Analyze(node.Child(1));
    RequireInt(node, type1, "Int needed for indexing");

    return Type::INT;
  }

  Type Analyze_RETURN(ASTNode & node) {
    assert(node.NumChildren() == 1);

    if (fun_id == SymbolTable::NO_ID) {
      node.Error("Return command found outside of function.");
    }

    [[maybe_unused]] Type return_type = Analyze(node.Child(0));
    
    // Check that return type matches function's return type
    Type type = symbols.GetReturnType(fun_id);
    if (!CanPromote(return_type, type)) {
      node.Error("Return type error: Expected type ", TypeToName(type),
                " recieved ", TypeToName(return_type));
    }

    return Type::NONE; // A return statement doesn't actually have a type.
  }

  Type Analyze_VAR(ASTNode & node) {
    assert(node.NumChildren() == 0);
    return node.GetType();
  }

  Type Analyze_FUNC(ASTNode & node) {
    size_t fun_id = node.GetSymbolID();
    const FunInfo & fun_info = symbols.GetFunInfo(fun_id);
    size_t param_count = symbols.GetNumParams(fun_id);
    size_t arg_count = node.NumChildren();
    const std::vector<size_t> & params = symbols.GetFunParams(fun_id);

    if (node.NumChildren() != param_count) {
        node.Error("Function ", fun_info.name, " should have ", param_count, " arguments but has", node.NumChildren(), "instead");
    }

    for (size_t i = 0; i < arg_count; ++i) {
      Type arg_type = Analyze(node.Child(i));
      Type param_type = symbols.GetType(params[i]);
      if (arg_type == param_type) {
        continue;  // Perfect match
      }
      // Promotion to double allowed
      else if (param_type == Type::DOUBLE && arg_type == Type::INT) {
        continue; 
      }
      node.Error(fun_info.name, " expects argument of type", TypeToName(param_type), " but has type ", TypeToName(arg_type));
    }
    return symbols.GetReturnType(fun_id);
  }

  Type Analyze_WHILE(ASTNode & node) {
    assert(node.NumChildren() == 2);
    [[maybe_unused]] Type condition_type = Analyze(node.Child(0));
    // !!!!!! You must check the condition type for the while loop!

    // Track that the code in the body will be inside a while loop (so break and continue are legal.)
    ++while_depth;
    Analyze(node.Child(1));
    --while_depth;

    return Type::NONE;
  }

};
