# Levelization Map

When designing a C++ project with more than 4 or 5 custom header files, it's a good idea to map out what order those files should be included in.
This strategy will help you avoid circular includes, perform cleaner testing and debugging, and plan better when adding new features.

| File            | Level | Direct Dependencies                 |
| --------------- | ----- | ----------------------------------- |
| lexer.hpp       | 0     | (_none_)                            |
| helpers.hpp     | 1     | lexer.hpp                           |
| AST.hpp         | 2     | helpers.hpp, lexer.hpp              |
| SymbolTable.hpp | 3     | AST.hpp, helpers.hpp, lexer.hpp     |
| Parser.hpp      | 4     | AST.hpp, lexer.hpp, SymbolTable.hpp |
| Semantics.hpp   | 4     | AST.hpp, lexer.hpp, SymbolTable.hpp |
| Translate.hpp   | 4     | AST.hpp, lexer.hpp, SymbolTable.hpp |
