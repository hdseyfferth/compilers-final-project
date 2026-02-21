# Levelization Map

| File            | Level | Direct Dependencies                 |
| --------------- | ----- | ----------------------------------- |
| lexer.hpp       | 0     | (_none_)                            |
| helpers.hpp     | 1     | lexer.hpp                           |
| AST.hpp         | 2     | helpers.hpp, lexer.hpp              |
| SymbolTable.hpp | 3     | AST.hpp, helpers.hpp, lexer.hpp     |
| Parser.hpp      | 4     | AST.hpp, lexer.hpp, SymbolTable.hpp |
| Semantics.hpp   | 4     | AST.hpp, lexer.hpp, SymbolTable.hpp |
| Translate.hpp   | 4     | AST.hpp, lexer.hpp, SymbolTable.hpp |