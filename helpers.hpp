#pragma once

#include <iostream>

#include "lexer.hpp"

// === Types and Type helper functions ===
enum class Type {
  NONE, DOUBLE, INT, STRING, UNKNOWN
};

Type NameToType(std::string name) {
  if (name == "none") return Type::NONE;
  if (name == "double") return Type::DOUBLE;
  if (name == "int") return Type::INT;
  if (name == "string") return Type::STRING;
  return Type::UNKNOWN;
}

std::string TypeToName(Type type) {
  switch (type) {
  case Type::NONE: return "none";
  case Type::DOUBLE: return "double";
  case Type::INT: return "int";
  case Type::STRING: return "string";
  default:
    return "UNKNOWN";
  }
}

std::string ToWATType(Type type) {
  switch (type) {
  case Type::DOUBLE: return "f64";
  case Type::INT: return "i32";
  case Type::STRING: return "i32";
  default:
    return "UNKNOWN";
  }
}

inline bool IsNumeric(Type type) { return (type == Type::INT || type == Type::DOUBLE); }

// Handle int to double
inline bool PromoteInt(Type src_type, Type res_type) {
  if (src_type == Type::INT && res_type == Type::DOUBLE) { 
    return true;
  }
}

// Handle type promotion
inline bool CanPromote(Type src_type, Type res_type) {
  if (src_type == res_type || PromoteInt(src_type, res_type)) {
    return true;
  }
  return false;
}

// Check if two types are comatible
inline bool IsCompatible(Type type0, Type type1) {
  return CanPromote(type0, type1) || CanPromote(type1, type0);
}

// Helper for numeric conversion
inline Type CombineNumerics(Type type0, Type type1) {
  if (type0 == Type::DOUBLE || type1 == Type::DOUBLE) {
    return Type::DOUBLE;
  }
  return Type::INT;
}


// === Operator helper functions ===
inline bool IsComparisonOp(const std::string & op) {
  return op == "==" || op == "!=" || op == "<" || op == "<=" || op == ">" || op == ">=";
}

inline bool IsArithmeticOp(const std::string & op) {
  return op == "+" || op == "-" || op == "*" || op == "/" || op == ":<" || op == ":>";
}

// === Error Handling helpers ===
template <typename... Ts>
void Error(size_t line_id, Ts... message) {
  std::cerr << "ERROR (line " << line_id << "): ";
  (std::cerr << ... << std::forward<Ts>(message)) << std::endl;
  exit(1);
}

template <typename... Ts>
void Error(emplex::Token token, Ts... message) {
  Error(token.line_id, std::forward<Ts>(message)...);
}

bool IsBuiltInFunction(const std::string& name) {
  return name == "SetTitle" || name == "AddButton" || name == "LineColor" 
      || name == "FillColor" || name == "LineWidth" || name == "Line" 
      || name == "Rect" || name == "Circle" || name == "Text"
      || name == "AddKeypress" || name == "AddClickFun" 
      || name == "AddMoveFun" || name == "AddAnimFun";
}
