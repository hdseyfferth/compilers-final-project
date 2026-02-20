# Custom Compiler (C++ → WebAssembly)

A multi-phase compiler written in C++ that translates a custom high-level language into WebAssembly (WAT/WASM).  
Implements lexical analysis, parsing + AST construction, scoped symbol resolution, semantic validation, and deterministic code generation.

# Features
- **Lexer**: tokenizes source code into a stream of tokens
- **Parser**: builds an **AST** using a grammar-driven (recursive-descent) approach
- **Symbol table + scoping**: resolves identifiers across nested scopes
- **Semantic analysis**: type checking + compile-time error reporting for invalid programs
- **Code generation**: emits deterministic **WebAssembly (WAT)** targeting the stack machine model
- **Runtime helpers** (if applicable): memory/string helpers used by generated code

# Architecture
Source → Lexer → Parser/AST → Semantic Analysis → WAT/WASM Codegen

Attribution
This repository includes starter/framework code provided by CSE-450-Fall2025 under the MIT License.
Compiler logic (parsing/AST, semantic analysis, and WebAssembly backend) was implemented and extended as part of the project.
