#pragma once

#include <cmath>
#include <memory>
#include <string>
#include <vector>

#include "helpers.hpp"
#include "lexer.hpp"

using emplex::Token;

// For labeling kinds of nodes in AST
enum class ASTType {
  NONE=0,
  BLOCK, IF, WHILE, BREAK, CONTINUE, RETURN, // Internal controller node
  // Internal nodes with return values
  OP1,   // Unary
  OP2,   // Binary
  CALL,  // Function call
  INDEX, // string[index] = value
  // Leaf nodes
  LIT_INT, LIT_DOUBLE, LIT_STRING, VAR,                        
  UNKNOWN
  // add more for project 
};

std::string TypeToName(const ASTType type) {
  switch (type) {
  case ASTType::NONE: return "None";
  case ASTType::BLOCK: return "BLOCK";
  case ASTType::IF: return "IF";
  case ASTType::WHILE: return "WHILE";
  case ASTType::BREAK: return "BREAK";
  case ASTType::CONTINUE: return "CONTINUE";
  case ASTType::RETURN: return "RETURN";
  case ASTType::OP1: return "OP1";
  case ASTType::OP2: return "OP2";
  case ASTType::LIT_DOUBLE: return "LIT_DOUBLE";
  case ASTType::LIT_INT: return "LIT_INT";
  case ASTType::LIT_STRING: return "LIT_STRING";
  case ASTType::VAR: return "VAR";
  case ASTType::CALL: return "CALL";
  case ASTType::INDEX: return "INDEX";
  default: return "UNKNOWN";
  }
}

class ASTNode {
protected:
  ASTType node_type = ASTType::UNKNOWN;       // Type of this AST node.
  Token token;                                // Original token responsible for this node
  std::vector<ASTNode> children{};            // Any sub-trees under this node.

  // can track function id
  size_t symbol_id = static_cast<size_t>(-1); // ID for relevant symbols.
  // knows type of node after node is created
  Type out_type = Type::UNKNOWN;              // Type this node resolves to.
  std::string extra_info;                     // Extra information for informative debugging.

public:
  ASTNode() { }

  // Children can be provided at construction
  template <typename... NODE_Ts>
  ASTNode(ASTType node_type, Token token, NODE_Ts &&... nodes) : node_type(node_type), token(token)
  { (AddChild(std::forward<NODE_Ts>(nodes)), ...); }

  [[nodiscard]] ASTType GetNodeType() const { return node_type; };

  [[nodiscard]] size_t GetLineID() const { return token.line_id; }
  [[nodiscard]] const std::string & GetLexeme() const { return token.lexeme; }

  [[nodiscard]] Type GetType() const { return out_type; }
  void SetType(Type in) { out_type = in; }

  [[nodiscard]] size_t GetSymbolID() const { return symbol_id; }
  void SetSymbolID(size_t id) { symbol_id = id; }

  [[nodiscard]] std::string GetExtra() const { return extra_info; }
  void SetExtra(std::string in) { extra_info = in; }

  // Tools to work with child nodes...
  [[nodiscard]] size_t NumChildren() const { return children.size(); }
  [[nodiscard]] ASTNode & Child(size_t id) {
    assert(children.size() > id);
    return children[id];
  }
  [[nodiscard]] const ASTNode & Child(size_t id) const {
    assert(children.size() > id);
    return children[id];
  }
  void AddChild(ASTNode && child) { children.push_back(std::move(child)); }

  // === HELPER FUNCTIONS ===

  template <typename... Ts>
  void Error(Ts &&... message) const {
    ::Error(token.line_id, std::forward<Ts>(message)...);
  }

  void Print(std::string prefix="") const {
    std::cout << prefix << TypeToName(node_type) << ": " << extra_info << std::endl;
    for (auto & child : children) child.Print(prefix + "  ");
  }

  [[nodiscard]] bool CanAssign() const { return node_type == ASTType::VAR || node_type == ASTType::INDEX;  }
};


// === Functions that BUILD the appropriate type of ASTNode ===

[[nodiscard]] ASTNode ASTNode_Block(Token token) { return ASTNode{ASTType::BLOCK, token}; }
[[nodiscard]] ASTNode ASTNode_If(Token token, ASTNode && test, ASTNode && action) {
  return ASTNode{ASTType::IF, token, std::move(test), std::move(action)};
}
[[nodiscard]] ASTNode ASTNode_If(Token token, ASTNode && test, ASTNode && action, ASTNode && alt_action) {
  return ASTNode{ASTType::IF, token, std::move(test), std::move(action), std::move(alt_action)};
}
[[nodiscard]] ASTNode ASTNode_While(Token token, ASTNode && test, ASTNode && action) {
  return ASTNode{ASTType::WHILE, token, std::move(test), std::move(action)};
}
[[nodiscard]] ASTNode ASTNode_Break(Token token) { return ASTNode{ASTType::BREAK, token}; }
[[nodiscard]] ASTNode ASTNode_Continue(Token token) { return ASTNode{ASTType::CONTINUE, token}; }
[[nodiscard]] ASTNode ASTNode_Return(Token token, ASTNode && value) {
  return ASTNode{ASTType::RETURN, token, std::move(value)};
}

[[nodiscard]] ASTNode ASTNode_Operator(Token token, ASTNode child) {
  ASTNode out{ASTType::OP1, token, std::move(child)};
  out.SetExtra("Operator:" + token.lexeme);
  return out;
}

[[nodiscard]] ASTNode ASTNode_Operator(Token token, ASTNode child1, ASTNode child2) {
  ASTNode out{ASTType::OP2, token, std::move(child1), std::move(child2)};
  out.SetExtra("Operator:" + token.lexeme);
  return out;
}

[[nodiscard]] ASTNode ASTNode_LitDouble(Token token) {
  // Construct ASTNode object w/ its type and its token
  ASTNode out{ASTType::LIT_DOUBLE, token};
  // Assign semantic type to the node object (after creation)
  out.SetType(Type::DOUBLE);
  // Return node to parser
  return out;
}

[[nodiscard]] ASTNode ASTNode_LitInt(Token token) {
  ASTNode out{ASTType::LIT_INT, token};
  out.SetType(Type::INT);
  return out;
}

[[nodiscard]] ASTNode ASTNode_LitString(Token token) {
  ASTNode out{ASTType::LIT_STRING, token};
  out.SetType(Type::STRING);
  return out;
}

[[nodiscard]] ASTNode ASTNode_Var(Token token, size_t var_id, Type type) {
  ASTNode out{ASTType::VAR, token};
  out.SetExtra(token.lexeme);
  out.SetSymbolID(var_id);
  out.SetType(type);
  return out;
}

[[nodiscard]] ASTNode ASTNode_FunCall(Token token, size_t fun_id) {
  ASTNode out{ASTType::CALL, token};
  out.SetSymbolID(fun_id);
  return out;
}

[[nodiscard]] ASTNode ASTNode_Index(Token token, ASTNode && base, ASTNode && index) {
  ASTNode out{ASTType::INDEX, token, std::move(base), std::move(index)};
  out.SetExtra("Index:[]");
  return out;
}
