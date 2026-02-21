#include <assert.h>
#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

#include "AST.hpp"
#include "lexer.hpp"
#include "Parser.hpp"
#include "Semantics.hpp"
#include "SymbolTable.hpp"
#include "Translate.hpp"

using emplex::Lexer;
using emplex::Token;

class Strix {
private:
  Lexer lexer;
  SymbolTable symbols;

public:
  Strix(std::string filename) {
    // Add Built-In functions before tokens
    InitializeFunctions();
    // Generate the token stream to work with.
    std::ifstream fs(filename);
    if (!fs) {
      std::cerr << "Failed to open file '" << filename << "'.  Exiting." << std::endl;
      exit (1);
    }
    lexer.Tokenize(fs);
  }

  // Create all of the built-in functions
  void InitializeFunctions() {
    symbols.AddBuiltInFunction("SetTitle", Type::INT, {Type::STRING});
    symbols.AddBuiltInFunction("AddButton", Type::INT, {Type::STRING, Type::STRING});
    symbols.AddBuiltInFunction("AddKeypress", Type::INT, {Type::STRING, Type::STRING});
    symbols.AddBuiltInFunction("AddClickFun", Type::INT, {Type::STRING});
    symbols.AddBuiltInFunction("AddMoveFun", Type::INT, {Type::STRING});
    symbols.AddBuiltInFunction("AddAnimFun", Type::INT, {Type::STRING});
    symbols.AddBuiltInFunction("LineColor", Type::INT, {Type::STRING});
    symbols.AddBuiltInFunction("FillColor", Type::INT, {Type::STRING});
    symbols.AddBuiltInFunction("LineWidth", Type::INT, {Type::INT});
    symbols.AddBuiltInFunction("Line", Type::INT, {Type::INT, Type::INT, Type::INT, Type::INT});
    symbols.AddBuiltInFunction("Rect", Type::INT, {Type::INT, Type::INT, Type::INT, Type::INT});
    symbols.AddBuiltInFunction("Circle", Type::INT, {Type::INT, Type::INT, Type::INT});
    symbols.AddBuiltInFunction("Text", Type::INT, {Type::INT, Type::INT, Type::INT, Type::STRING});
  }

  // Create a Parse object and used to the convert the input token (in lexer) into one or more
  // functions (stored in the symbol table.)
  void Parse() {
    Parser parser{lexer, symbols};
    parser.Parse();
  }

  // Do a full semantic analysis of the inputs, as found in the symbol table.
  void AnalyzeSemantics() {
    Semantics analyzer{symbols};
    analyzer.Analyze();
  }

  // Convert the functions in the symbol table into WAT format.
  void ToWAT() {
    Translate translator{symbols};
    translator.ToWAT();
  }
};

int main(int argc, char * argv[])
{
  if (argc != 2) {
    std::cout << "Format: " << argv[0] << " [filename]" << std::endl;
    return 1;
  }

  Strix prog(argv[1]);      // Load in the input file and use the lexer to tokenize it.
  prog.Parse();             // Parse the tokens, turning them into ASTs.
  prog.AnalyzeSemantics();  // Make sure that all context in the ASTs is correct.
  prog.ToWAT();             // Convert the ASTs into proper WebAssembly Text (WAT) Output.
}
