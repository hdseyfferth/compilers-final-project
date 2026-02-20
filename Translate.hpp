#pragma once

// Visitor pattern for moving though an AST and translating all nodes to WAT

#include <string>

#include "AST.hpp"
#include "lexer.hpp"
#include "SymbolTable.hpp"

class Translate {
private:
  SymbolTable & symbols;              // Reference to symbol table
  int indent = 0;                     // How much should WAT output be indented?
  size_t fun_id = SymbolTable::NO_ID; // Which function are we currently translating?
  size_t next_while_id = 1;           // Unique ID for next while loop.
  std::vector<size_t> while_ids;      // Which while loops are we currently in?
  // String Related
  std::vector<std::string> strings; // Store string literals
  size_t free_mem = 0; // The position of the next free memory
  std::map<std::string, size_t> str_memory; // Map strings to their memory addresses

  // == HELPER FUNCTIONS ==

  // This function will indent properly, print all of its arguments, and then insert a newline
  template <typename... Ts>
  void AddCode(Ts &&... message) const {
    std::cout << std::string(indent, ' ');
    (std::cout << ... << std::forward<Ts>(message)) << std::endl;
  }

  // Select code to add based on the type specified.
  void SelectCode(Type type, std::string double_code, std::string int_code, std::string str_code) {
    switch (type) {
    case Type::DOUBLE: AddCode(double_code); break;
    case Type::INT:    AddCode(int_code);    break;
    case Type::STRING: AddCode(str_code); break;
    default:
      std::cerr << "Internal ERROR: No type provided for code selection." << std::endl;
      exit(1);
    }
  }

  // Add code to convert between the specified types.
  // !!!!!! Note, this will be a lot more helpful in Project 4!
  void AddConvert(Type from_type, Type to_type) const {
    assert(from_type != Type::NONE && to_type != Type::NONE);
    assert(from_type != Type::UNKNOWN && to_type != Type::UNKNOWN);
    if (from_type == to_type) return; // No change needed!

    if (from_type == Type::DOUBLE && to_type == Type::INT) {
      AddCode("(i32.trunc_f64_s)  ;; Convert from f64 to i32.");
    }
    else if (from_type == Type::INT && to_type == Type::DOUBLE) {
      AddCode("(f64.convert_i32_s)  ;; Convert from f32 to i64.");
    }

    else {
      std::cerr << "Unexpected conversion from '" << TypeToName(from_type)
                << "' to '" << TypeToName(to_type) << "'." << std::endl;
      exit(2);
    }
  }

  // Determine what operation type to use
  Type OpType(const std::string & op, Type type0, Type type1, Type res_type) const {
    // If promotion to double is needed
    if (IsComparisonOp(op) || IsArithmeticOp(op) || op == "**") {
      CombineNumerics(type0, type1);
    }
    // If result type is needed
    return res_type;
  }

  void StoreStrings(const std::string & lexeme) {
    // Strip quotes
    std::string str = lexeme.substr(1, lexeme.length() - 2);
    // Check if string is already stored
    if (str_memory.find(str) != str_memory.end()) {
      return;
    }
    // Store a new string in memory
    str_memory[str] = free_mem;   // start index of string in memory
    strings.push_back(str);       // add string to (ordered) vectore
    free_mem += str.length() + 1; // update free memory position
  }

  void GetStrings(ASTNode & node) {
    if (node.GetNodeType() == ASTType::LIT_STRING) {
      StoreStrings(node.GetLexeme());
    }
    for (size_t i = 0; i < node.NumChildren(); ++i) {
      GetStrings(node.Child(i));
    }
  }

  void GenerateStrData() {
    for (const auto & str : strings) {
      size_t mem_address = str_memory[str];
      std::cout << "  (data (i32.const " << mem_address << ") \"";
      for (char c : str) {
        std::cout << c;
      }
      // Add null terminator
      std::cout << "\\00\")  ;; String literal\n";
    }
    std::cout << "\n";
  }

  // Helper for string concatenation 
  void ToWAT_Concat(ASTNode & node, Type type0, Type type1, bool need_result) {
    ToWAT(node.Child(0), true);
    ToWAT(node.Child(1), true);
    if (type0 == Type::STRING && type1 == Type::STRING) {
      AddCode("(call $_str_concat)  ;; Concatenate strings");
      if (!need_result) AddCode("(drop)");
      return;
    }
    if (type0 == Type::STRING && type1 == Type::INT) {
      AddCode("(call $_add_char)  ;; String + Int");
      if (!need_result) AddCode("(drop)");
      return;
    }
    node.Error("Failed to concatenate");
  }

  // Helper for formatting the function names
  std::string GetBuiltInName(const std::string& name) {
    if (name == "SetTitle") return "$setTitle";
    if (name == "AddButton") return "$addButton";
    if (name == "AddKeypress") return "$addKeyTrigger";
    if (name == "AddClickFun") return "$addClickFun";
    if (name == "AddMoveFun") return "$addMoveFun";
    if (name == "AddAnimFun") return "$addAnimFun";
    if (name == "LineColor") return "$setStrokeColor";
    if (name == "FillColor") return "$setFillColor";
    if (name == "LineWidth") return "$setLineWidth";
    if (name == "Line") return "$drawLine";
    if (name == "Rect") return "$drawRect";
    if (name == "Circle") return "$drawCircle";
    if (name == "Text") return "$drawText";
    return "$unknown";  
  }

  // == Info about WHILE loops being generated ==

  // Are we currently generating any while loops?
  [[nodiscard]] bool InWhile() const { return while_ids.size() > 0; }

  // What is the ID of the inner-most while loop we are generating?
  [[nodiscard]] size_t GetWhileID() const {
    assert(InWhile());
    return while_ids.back();
  }

  // Start generating a new while loop (return unique ID for this loop)
  size_t AddWhile() {
    while_ids.push_back(next_while_id++);
    return GetWhileID();
  }

  // Finish the inner-most while loop being generated.
  size_t ExitWhile() {
    assert(InWhile());
    const size_t out_id = while_ids.back();
    while_ids.pop_back();
    return out_id;
  }

  // WAT HELPER FUNCTIONS
  void PrintWATHelpers() const {
    // swap
    std::cout
      << "  ;; Function to swap the top two i32s on the stack.\n"
      << "  (func $_swap32 (param $val1 i32) (param $val2 i32) (result i32) (result i32)\n"
      << "    (local.get $val2)\n"
      << "    (local.get $val1)\n"
      << "  )\n"
      << "\n"
    
    // Allocate memory for a string
    << "  ;; Allocate space for a string, placing a null terminator at the end\n"
    << "  ;; Return: memory index of allocated space.\n"
    << "  (func $_alloc_str (param $size i32) (result i32)\n"
    << "    (local $null_idx i32)     ;; Local var for null terminator index\n"
    << "    (global.get $free_mem)    ;; Push starting free_mem index on stack to return at end\n"
    << "    (i32.add (global.get $free_mem) (local.get $size)) ;; free_mem + size is null terminator index\n"
    << "    (local.set $null_idx)                              ;; Save null terminator index\n"
    << "    (i32.store8 (local.get $null_idx) (i32.const 0))   ;; Place byte 0 as null terminator\n"
    << "    (i32.add (i32.const 1) (local.get $null_idx))      ;; Increment past null for new free_mem index\n"
    << "    (global.set $free_mem)                             ;; Save new free_mem index\n"
    << "   )\n"
    << "\n"
    << "  ;; Function to copy memory. Args: [source] [destination] [size]\n"
    << "  ;; No return value.\n"
    << "  (func $_mem_copy (param $src i32) (param $dest i32) (param $size i32)\n"
    << "    (loop $_mem_copy_loop\n"
    << "      (if (i32.eqz (local.get $size)) (then (return)))\n"
    << "      (local.get $dest)\n"
    << "      (i32.load8_u (local.get $src))\n"
    << "      (i32.store8)\n"
    << "      (local.set $src (i32.add (local.get $src) (i32.const 1)))\n"
    << "      (local.set $dest (i32.add (local.get $dest) (i32.const 1)))\n"
    << "      (local.set $size (i32.sub (local.get $size) (i32.const 1)))\n"
    << "      (br $_mem_copy_loop)\n"
    << "    )\n"
    << "  )\n"
    << "\n"
    << "  ;; Copies a new string to memory\n"
    << "  (func $_str_copy (param $str i32) (result i32)\n"
    << "    (local $len i32)\n"
    << "    (local $res_str i32)\n"
    << "    (local.set $len (call $_get_len (local.get $str)))\n"
    << "    (local.set $res_str (call $_alloc_str (local.get $len)))\n"
    << "    (call $_mem_copy (local.get $str) (local.get $res_str) (local.get $len))\n"
    << "    (local.get $res_str)\n"
    << "  )\n"
    << "\n"
    << "  ;; Get the length of a string\n"
    << "  (func $_get_len (param $str i32) (result i32)\n"
    << "    (local $len i32)\n"
    << "    (local.set $len (i32.const 0))\n"
    << "    (block $_len_block\n"
    << "      (loop $_len_loop\n"
    << "        (i32.load8_u (i32.add (local.get $str) (local.get $len)))\n"
    << "        (i32.eqz)\n"
    << "        (br_if $_len_block)\n"
    << "        (local.set $len (i32.add (local.get $len) (i32.const 1)))\n"
    << "        (br $_len_loop)\n"
    << "      )\n"
    << "    )\n"
    << "    (local.get $len)\n"
    << "  )\n"
    << "\n"
    << "  ;; Concatenate strings\n"
    << "  (func $_str_concat (param $str0 i32) (param $str1 i32) (result i32)\n"
    << "    (local $len0 i32)\n"
    << "    (local $len1 i32)\n"
    << "    (local $res_str i32)\n"
    << "    ;; Get length of each string\n"
    << "    (local.set $len0 (call $_get_len (local.get $str0)))\n"
    << "    (local.set $len1 (call $_get_len (local.get $str1)))\n"
    << "    ;; Allocate memory for the result string\n"    
    << "    (local.set $res_str\n"
    << "    (call $_alloc_str (i32.add (local.get $len0) (local.get $len1))))\n"
    << "    ;; Copy str0\n"
    << "    (call $_mem_copy (local.get $str0) (local.get $res_str) (local.get $len0))\n"
    << "    ;; Copy str1\n"
    << "    (call $_mem_copy\n"
    << "    (local.get $str1)\n"
    << "    (i32.add (local.get $res_str) (local.get $len0))\n"
    << "    (local.get $len1))\n"
    << "    (local.get $res_str)\n"
    << "  )\n"
    << "  ;; Add a char to a string \n"
    << "  (func $_add_char (param $str i32) (param $char i32) (result i32)\n"
    << "    (local $len i32)\n"
    << "    (local $res_str i32)\n"
    << "    (local.set $len (call $_get_len (local.get $str)))\n"
    << "    ;; Allocate memory for the result string\n"    
    << "    (local.set $res_str (call $_alloc_str (i32.add (local.get $len) (i32.const 1))))\n"
    << "    ;; Copy initial string\n"
    << "    (call $_mem_copy (local.get $str) (local.get $res_str) (local.get $len))\n"
    << "    ;; Add char to end of string\n"
    << "    (i32.store8 (i32.add (local.get $res_str) (local.get $len)) (local.get $char))\n"
    << "    (local.get $res_str)\n"
    << "  )\n"
    << "\n";
  }

public:
  Translate(SymbolTable & symbols) : symbols(symbols) { }

  // Translate all functions into WebAssembly Text (WAT) output
  void ToWAT() {
    std::cout
      << "(module\n"
      << "  (import \"Math\" \"pow\" (func $pow (param f64 f64) (result f64)))\n";


    // ADD: Import all the host functions for built-ins
    std::cout 
      << "  (import \"host\" \"addButton\" (func $addButton (param i32 i32)))\n"
      << "  (import \"host\" \"addKeyTrigger\" (func $addKeyTrigger (param i32 i32)))\n"
      << "  (import \"host\" \"addClickFun\" (func $addClickFun (param i32)))\n"
      << "  (import \"host\" \"addMoveFun\" (func $addMoveFun (param i32)))\n"
      << "  (import \"host\" \"addAnimFun\" (func $addAnimFun (param i32)))\n"
      << "  (import \"host\" \"setTitle\" (func $setTitle (param i32)))\n"
      << "  (import \"host\" \"setStrokeColor\" (func $setStrokeColor (param i32)))\n"
      << "  (import \"host\" \"setFillColor\" (func $setFillColor (param i32)))\n"
      << "  (import \"host\" \"setLineWidth\" (func $setLineWidth (param i32)))\n"
      << "  (import \"host\" \"drawLine\" (func $drawLine (param i32 i32 i32 i32)))\n"
      << "  (import \"host\" \"drawRect\" (func $drawRect (param i32 i32 i32 i32)))\n"
      << "  (import \"host\" \"drawCircle\" (func $drawCircle (param i32 i32 i32)))\n"
      << "  (import \"host\" \"drawText\" (func $drawText (param i32 i32 i32 i32)))\n";

    // Collect strings for both user-defined functions
    for (fun_id = 0; fun_id < symbols.GetNumFuns(); ++fun_id) {
      if (symbols.IsBuiltIn(fun_id)) continue;
      GetStrings(symbols.GetFunBody(fun_id));
    }

    // Collect strings for global initializations
    const std::vector<size_t>& global_ids = symbols.GetGlobalVars();
    for (size_t global_id : global_ids) {
      std::string var_name = symbols.GetName(global_id);
      if (symbols.HasInitExpr(var_name)) {
        GetStrings(symbols.GetInitExpr(var_name));
      }
    }

    // Allocate Memory 
    std::cout << "  (memory (export \"memory\") 10)  ;; 10 pages = 640KB\n";
    std::cout << "  (global $free_mem (mut i32) (i32.const " << free_mem << "))\n\n";
    
    // Declare global variables
    for (size_t global_var : global_ids) {
      std::string var_name = symbols.GetName(global_var);
      std::string wat_type = symbols.GetWATType(global_var);
      std::cout << "  (global $var" << global_var << " (mut " << wat_type << ") ";
      
      // Initialize with default values for each type
      if (symbols.GetType(global_var) == Type::INT) {
        std::cout << "(i32.const 0)";
      } else if (symbols.GetType(global_var) == Type::DOUBLE) {
        std::cout << "(f64.const 0.0)";
      } else if (symbols.GetType(global_var) == Type::STRING) {
        std::cout << "(i32.const 0)"; // String is a pointer (i32)
      }
      std::cout << ")  ;; Global variable '" << var_name << "'\n";
    }
    std::cout << "\n";

    GenerateStrData();
    PrintWATHelpers(); // Print all of the helper functions for dealing with strings.

    for (fun_id = 0; fun_id < symbols.GetNumFuns(); ++fun_id) {
      if (symbols.IsBuiltIn(fun_id)) continue;
      std::cout << "  (func $Fun" << fun_id;

      // Declare parameters
      auto params = symbols.GetFunParams(fun_id);
      for (auto var_id : params) {
        std::string wat_type = symbols.GetWATType(var_id);
        std::cout << " (param $var" << var_id << " " << wat_type << ")";
      }
      std::cout << " (result " << ToWATType(symbols.GetReturnType(fun_id)) << ")\n";

      indent = 4;

      // Declare local variables
      auto locals = symbols.GetFunLocals(fun_id);
      for (auto var_id : locals) {
        std::string wat_type = symbols.GetWATType(var_id);
        AddCode("(local $var", var_id, " ", wat_type, ") ;; Declare var '",
                symbols.GetName(var_id), "'");
      }

      // Generate body
      ToWAT(symbols.GetFunBody(fun_id), false);
      indent = 0;

      // close function
      std::cout << "  )\n";
    }

    // Generate empty $Init function 
    std::cout << "\n";
    std::cout << "  (func $Init\n";
    indent = 4;

    // Generate initialization code
    const std::vector<size_t>& globals = symbols.GetGlobalVars();
    for (size_t global_id : globals) {
      std::string var_name = symbols.GetName(global_id);
      
      if (symbols.HasInitExpr(var_name)) {     
        AddCode(";; Initialize global '", var_name, "'");   
        // Generate code for the initialization expression
        ToWAT(symbols.GetInitExpr(var_name), true);
        
        // Convert types as neededd
        Type init_type = symbols.GetInitExpr(var_name).GetType();
        Type var_type = symbols.GetType(global_id);
        AddConvert(init_type, var_type);
        
        // Store in the global variable
        AddCode("(global.set $var", global_id, ")");
      }
    }
    std::cout << "  )\n";
    indent = 0;
    std::cout << "  (start $Init)\n";

      // Export user-defined functions
    std::cout << "\n";
    for (size_t fun_id = 0; fun_id < symbols.GetNumFuns(); ++fun_id) {
      if (symbols.IsBuiltIn(fun_id)) continue;
      std::cout << "  (export \"" << symbols.GetFunName(fun_id) << "\" (func $Fun" << fun_id << "))\n";
    }
    std::cout << ") ;; End module\n";
  }

  // Translate a particular sub-tree to WAT format.
  // need_result indicates if we are expecting a result on the WAT stack after translation.
  // indent_shift helps make the output format look nicer.
  void ToWAT(ASTNode & node, bool need_result, int indent_shift=0) {
    indent += indent_shift;

    switch (node.GetNodeType()) {
    case ASTType::BLOCK:      ToWAT_Block(node, need_result);     break;
    case ASTType::BREAK:      ToWAT_Break(node, need_result);     break;
    case ASTType::CONTINUE:   ToWAT_Continue(node, need_result);  break;
    case ASTType::IF:         ToWAT_If(node, need_result);        break;
    case ASTType::LIT_DOUBLE: ToWAT_LitDouble(node, need_result); break;
    case ASTType::LIT_INT:    ToWAT_LitInt(node, need_result);    break;
    case ASTType::LIT_STRING: ToWAT_LitString(node, need_result); break;
    case ASTType::OP1:        ToWAT_Operator1(node, need_result); break;
    case ASTType::OP2:        ToWAT_Operator2(node, need_result); break;
    case ASTType::INDEX:      ToWAT_Index(node, need_result);     break;
    case ASTType::RETURN:     ToWAT_Return(node, need_result);    break;
    case ASTType::VAR:        ToWAT_Var(node, need_result);       break;
    case ASTType::CALL:       ToWAT_FunCall(node, need_result);   break;
    case ASTType::WHILE:      ToWAT_While(node, need_result);     break;
    default:
      std::cerr << "Internal Compiler Error: Unknown AST Node '"
                << TypeToName(node.GetNodeType()) << "'." << std::endl;
      exit(2);
    }

    indent -= indent_shift;
  }

  void ToWAT_Block(ASTNode & node, [[maybe_unused]] bool need_result) {
    assert(need_result == false);

    // Translate all children to WAT.
    for (size_t i = 0; i < node.NumChildren(); ++i) {
      ToWAT(node.Child(i), need_result);
    }
  }

  void ToWAT_Break([[maybe_unused]] ASTNode & node, [[maybe_unused]] bool need_result) {
    assert(need_result == false);
    const size_t while_id = GetWhileID();
    const std::string block_name = "$exit" + std::to_string(while_id);
    
    AddCode("(br ", block_name, ") ;; / BREAK out of while ", while_id);
  }

  void ToWAT_Continue([[maybe_unused]] ASTNode & node, [[maybe_unused]] bool need_result) {
    assert(need_result == false);
    const size_t while_id = GetWhileID();
    const std::string loop_name = "$loop" + std::to_string(while_id);
    
    AddCode("(br ", loop_name, ") ;; CONTINUE while ", while_id);
  }

  void ToWAT_If(ASTNode & node, [[maybe_unused]] bool need_result) {
    assert(need_result == false);
    AddCode(";; == If Condition ==");
    ToWAT(node.Child(0), true);  // Generate condition code

    // If the condition is a double, convert it to an int.
    AddConvert(node.Child(0).GetType(), Type::INT); // Make sure we have an int for the 'if'
    AddCode("(if ;; Execute code based on result of condition.");
    AddCode("  (then ;; 'then' block");
    ToWAT(node.Child(1), false, 4);
    AddCode("  ) ;; End 'then'");

    if (node.NumChildren() == 3) {
      AddCode("  (else ;; 'else' block");
      ToWAT(node.Child(2), false, 4);
      AddCode("  ) ;; End 'else'");
    }

    AddCode(") ;; End 'if'");
  }

  void ToWAT_LitDouble(ASTNode & node, bool need_result) {
    const double value = std::stod(node.GetLexeme());
    if (need_result) AddCode("(f64.const ", value, ")  ;; Literal value");
  }

  void ToWAT_LitInt(ASTNode & node, bool need_result) {
    const int value = std::stod(node.GetLexeme());
    if (need_result) AddCode("(i32.const ", value, ")  ;; Literal value");
  }

  void ToWAT_LitString(ASTNode & node, bool need_result) {
  if (!need_result) return;
  
  std::string str = node.GetLexeme();
  str = str.substr(1, str.length() - 2);
  size_t mem_address = str_memory[str];
  AddCode("(i32.const ", mem_address, ")  ;; String literal at memory position ", mem_address);
}

  void ToWAT_Operator1(ASTNode & node, bool need_result) {
    const std::string op = node.GetLexeme();
    Type op_type = node.Child(0).GetType();
    if (op == "!") {
      ToWAT(node.Child(0), true);
      if (op_type == Type::INT) {
        AddCode("(i32.eqz)  ;; Do operator '!'");
      } else if (op_type == Type::DOUBLE) {
        AddCode("(f64.const 0.0)");
        AddCode("(f64.eq)  ;; Do operator '!'");
      }
    } else if (op == "-") {
      if (op_type == Type::INT) {
        AddCode("(i32.const 0)       ;; Setup negation");
        ToWAT(node.Child(0), true);
        AddCode("(i32.sub)           ;; Negate value");
      } else if (op_type == Type::DOUBLE) {
        ToWAT(node.Child(0), true);
        AddCode("(f64.neg)           ;; Negate value");
      }
    }
    else if (op == "#") {
      ToWAT(node.Child(0), true);  // Get string pointer
      AddCode("(call $_get_len)");
    }
    if (!need_result) AddCode("(drop) ;; Result not used.");
  }

  void ToWAT_Operator2(ASTNode & node, bool need_result) {
    const std::string op = node.GetLexeme();
    Type type0 = node.Child(0).GetType();
    Type type1 = node.Child(1).GetType();
    Type res_type = node.GetType();
    // If we are doing an assignment, we need to handle it specially.
    if (op == "=") {
      AddCode(";; Calculate RHS for assignment.");
      ToWAT(node.Child(1), true);   // Generate code for rhs value.
      

      // Index assignment
      if (node.Child(0).GetNodeType() == ASTType::INDEX) {
        
        ToWAT(node.Child(0).Child(0), true); // string expression address
        ToWAT(node.Child(0).Child(1), true); // string index

        AddCode("(i32.add)");     // calculate address at index
        AddCode("(call $_swap32)");
        AddCode("(i32.store8)");

        if (need_result) {
          ToWAT(node.Child(1), true);
          AddConvert(type1, type0);
        }
        return;
      }

      // If assigning string to string variable
      if (type0 == Type::STRING && type1 == Type::STRING) {
        AddCode("(call $_str_copy)  ;; Copy string to new memory location");
      }
      AddConvert(type1, type0);

      // Typical variable assignment
      const size_t var_id = node.Child(0).GetSymbolID();    // Get ID of the variable being set.
      const std::string var_name = symbols.GetName(var_id);

      // Use corrent variable type
      if (symbols.IsGlobal(var_id)) {
        AddCode("(global.set $var", var_id, ")  ;; Set global var '", var_name, "'");
      } else {
        AddCode("(local.set $var", var_id, ")  ;; Set var '", var_name, "'");
      }
      
      if (need_result) {
        ToWAT(node.Child(0), true);
      }
      return;
    } 

    // Check for string operations
    if (op == "+" && (type0 == Type::STRING || type1 == Type::STRING)) {
      ToWAT_Concat(node, type0, type1, need_result);
      return;
    }
    
    // Get type of the operand 
    Type op_type = OpType(op, type0, type1, res_type);
    if (IsComparisonOp(op) || IsArithmeticOp(op) || op == "**") {
      op_type = CombineNumerics(type0, type1);
    } else {
      op_type = res_type;
    }

    // Generate children
    // Left Operand
    ToWAT(node.Child(0), true);
    if (op_type == Type::DOUBLE && node.Child(0).GetType() == Type::INT) {
      AddConvert(Type::INT, Type::DOUBLE);
    }
    // Right Operand
    ToWAT(node.Child(1), true);
    if (op_type == Type::DOUBLE && node.Child(1).GetType() == Type::INT) {
      AddConvert(Type::INT, Type::DOUBLE);
    }
    // Generate Operations
    if (op == "**") {
      AddCode("(call $pow)");
    }
    else if (op == ":<") {
      SelectCode(op_type, "(f64.min)", "(i32.min_s)", "");
    }
    else if (op == ":>") {
      SelectCode(op_type, "(f64.max)", "(i32.max_s)", "");
    }
    else if (op == "*") {
      SelectCode(op_type, "(f64.mul)", "(i32.mul)", "");
    }
    else if (op == "/") {
      SelectCode(op_type, "(f64.div)", "(i32.div_s)", "");
    }
    else if (op == "%") {
      AddCode("(i32.rem_s)  ;; Remainder (int only)");
    }
    else if (op == "+") {
      SelectCode(op_type, "(f64.add)", "(i32.add)", "");
    }
    else if (op == "-") {
      SelectCode(op_type, "(f64.sub)", "(i32.sub)", "");
    }
    else if (op == "==") {
      SelectCode(op_type, "(f64.eq)", "(i32.eq)", "");
    }
    else if (op == "!=") {
      SelectCode(op_type, "(f64.ne)", "(i32.ne)", "");
    }
    else if (op == "<") {
      SelectCode(op_type, "(f64.lt)", "(i32.lt_s)", "");
    }
    else if (op == "<=") {
      SelectCode(op_type, "(f64.le)", "(i32.le_s)", "");
    }
    else if (op == ">") {
      SelectCode(op_type, "(f64.gt)", "(i32.gt_s)", "");
    }
    else if (op == ">=") {
      SelectCode(op_type, "(f64.ge)", "(i32.ge_s)", "");
    } else {
      node.Error("Internal compiler error; unknown op '", op, "'");
    }
    if (!need_result) AddCode("(drop) ;; Result not used.");
  }

  void ToWAT_Index(ASTNode & node, bool need_result) {
    if (!need_result) return;  // If not used, don't generate code
    
    ToWAT(node.Child(0), true);
    ToWAT(node.Child(1), true);
  
    // Add them together to get the address: string + index
    AddCode("(i32.add)");
  
    // Load the byte at that address
    AddCode("(i32.load8_u)");
  }

  void ToWAT_Return(ASTNode & node, [[maybe_unused]] bool need_result) {
    assert(need_result == false);
    AddCode(";; == Generate return code ==");
    ToWAT(node.Child(0), true); // Generate code for return value

    // !!!!!! Here's an example of using AddConvert!

    // If we need to convert to the correct return type, do so.
    AddConvert(node.Child(0).GetType(), symbols.GetReturnType(fun_id));

    AddCode("(return)");
  }

  void ToWAT_Var(ASTNode & node, bool need_result) {
    if (need_result) {
      const size_t var_id = node.GetSymbolID();
      if (symbols.IsGlobal(var_id)) {
        AddCode("(global.get $var", var_id, ")  ;; Global variable '", symbols.GetName(var_id), "'");
      } else {
        AddCode("(local.get $var", var_id, ")  ;; Variable '", symbols.GetName(var_id), "'");
      }
    }
  }

  void ToWAT_FunCall(ASTNode & node, bool need_result) {
    size_t fun_id = node.GetSymbolID();
    const FunInfo & fun_info = symbols.GetFunInfo(fun_id);
    const std::vector<size_t> & params = symbols.GetFunParams(fun_id);

    AddCode(";; Call function '", fun_info.name, "'");

    // Generate arguments in function
    for (size_t i = 0; i < node.NumChildren(); ++i) {
      ToWAT(node.Child(i), true);
      // Convert type (if needed)
      Type arg_type = node.Child(i).GetType();
      Type param_type = symbols.GetType(params[i]);
      AddConvert(arg_type, param_type);
    }

    if (symbols.IsBuiltIn(fun_id)) {
      // Call built-in function
      std::string label = GetBuiltInName(fun_info.name);
      AddCode("(call ", label, ") ;; Call function ", fun_info.name);
    } else {
      // Call user-defined function
      AddCode("(call $Fun", fun_id, ")  ;; Call '", fun_info.name, "'");
      if (!need_result) {
        AddCode("(drop) ;; Result not used.");
      }
    }
  }

  void ToWAT_While(ASTNode & node, [[maybe_unused]] bool need_result) {
    assert(need_result == false);
    const std::string while_id = std::to_string(AddWhile());
    const std::string block_name = "$exit" + while_id;
    const std::string loop_name = "$loop" + while_id;
    
    AddCode("(block ", block_name, " ;; Outer block for breaking while loop.");
    AddCode("  (loop ", loop_name, " ;; Inner loop for continuing while.");

    indent += 4;
    AddCode(";; == WHILE ", while_id, " CONDITION ==");
    ToWAT(node.Child(0), true);                     // Generate condition code
    AddConvert(node.Child(0).GetType(), Type::INT); // Convert result to int for if.
    AddCode(";; == END WHILE ", while_id, " CONDITION ==");
    AddCode("(i32.eqz)       ;; Invert the result of the test condition.");
    AddCode("(br_if ", block_name, ") ;; If condition was false (0), exit the loop");

    AddCode(";; == WHILE ", while_id, " BODY ==");
    ToWAT(node.Child(1), false);  // Generate while body
    AddCode(";; == END WHILE ", while_id, " BODY ==");

    AddCode("(br ", loop_name, ") ;; Branch back to the start of the loop");

    indent -= 4;
    AddCode("  ) ;; End loop");
    AddCode(") ;; End block\n");
    
    ExitWhile();
  }
};