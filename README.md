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

## Project Structure
AST.hpp — Abstract Syntax Tree definitions
Parser.hpp — Parser implementation
Semantics.hpp — Semantic analysis
SymbolTable.hpp — Scoped symbol table
Translate.hpp — WebAssembly code generation
lexer.emplex — Lexer specification
Compiler — Build target (generated executable)


## Instructions to Run the Demo
The demo runner:
- Compiles `.strix` programs into WebAssembly text (WAT)
- Validates generated WAT by assembling it with `wat2wasm`
- Reports results of example tests

To run: 
```bash
make examples
```
Start a local server (required for WebAssembly in browsers):

```bash
python3 -m http.server 8000
```

Open the following URL in your browser:

http://localhost:8000/demo/Strix.html

From the page, load a generated `.wasm` file (produced by the compiler).

This enables:
- Interactive canvas rendering
- Button-triggered callbacks
- Keyboard and mouse event handling
- Animation-driven programs


## What I Implemented

- Recursive-descent parsing with AST construction
- Scoped symbol table and identifier resolution
- Static semantic validation and compile-time error detection
- Deterministic WebAssembly (WAT) code generation
- Integration with browser-based host functions for graphics and event handling


## Attribution

This project builds upon starter framework code provided under the MIT License by CSE-450-Fall2025.  
The compiler implementation logic (parsing, semantic analysis, and WebAssembly backend implementation) was developed and extended as part of the project.