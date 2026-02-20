(module
  (import "Math" "pow" (func $pow (param f64 f64) (result f64)))
  (import "host" "addButton" (func $addButton (param i32 i32)))
  (import "host" "addKeyTrigger" (func $addKeyTrigger (param i32 i32)))
  (import "host" "addClickFun" (func $addClickFun (param i32)))
  (import "host" "addMoveFun" (func $addMoveFun (param i32)))
  (import "host" "addAnimFun" (func $addAnimFun (param i32)))
  (import "host" "setTitle" (func $setTitle (param i32)))
  (import "host" "setStrokeColor" (func $setStrokeColor (param i32)))
  (import "host" "setFillColor" (func $setFillColor (param i32)))
  (import "host" "setLineWidth" (func $setLineWidth (param i32)))
  (import "host" "drawLine" (func $drawLine (param i32 i32 i32 i32)))
  (import "host" "drawRect" (func $drawRect (param i32 i32 i32 i32)))
  (import "host" "drawCircle" (func $drawCircle (param i32 i32 i32)))
  (import "host" "drawText" (func $drawText (param i32 i32 i32 i32)))
  (memory (export "memory") 10)  ;; 10 pages = 640KB
  (global $free_mem (mut i32) (i32.const 141))

  (global $var26 (mut i32) (i32.const 0))  ;; Global variable 'x_pos'
  (global $var27 (mut i32) (i32.const 0))  ;; Global variable 'y_pos'
  (global $var28 (mut i32) (i32.const 0))  ;; Global variable 'size'

  (data (i32.const 0) "black\00")  ;; String literal
  (data (i32.const 6) "while\00")  ;; String literal
  (data (i32.const 12) "orange\00")  ;; String literal
  (data (i32.const 19) "purple\00")  ;; String literal
  (data (i32.const 26) "yellow\00")  ;; String literal
  (data (i32.const 33) "pink\00")  ;; String literal
  (data (i32.const 38) "brown\00")  ;; String literal
  (data (i32.const 44) "gray\00")  ;; String literal
  (data (i32.const 49) "#000080\00")  ;; String literal
  (data (i32.const 57) "#800000\00")  ;; String literal
  (data (i32.const 65) "#008000\00")  ;; String literal
  (data (i32.const 73) "Test: Buttons to modify the image.\00")  ;; String literal
  (data (i32.const 108) "Bigger!\00")  ;; String literal
  (data (i32.const 116) "IncSize\00")  ;; String literal
  (data (i32.const 124) "Smaller!\00")  ;; String literal
  (data (i32.const 133) "DecSize\00")  ;; String literal

  ;; Function to swap the top two i32s on the stack.
  (func $_swap32 (param $val1 i32) (param $val2 i32) (result i32) (result i32)
    (local.get $val2)
    (local.get $val1)
  )

  ;; Allocate space for a string, placing a null terminator at the end
  ;; Return: memory index of allocated space.
  (func $_alloc_str (param $size i32) (result i32)
    (local $null_idx i32)     ;; Local var for null terminator index
    (global.get $free_mem)    ;; Push starting free_mem index on stack to return at end
    (i32.add (global.get $free_mem) (local.get $size)) ;; free_mem + size is null terminator index
    (local.set $null_idx)                              ;; Save null terminator index
    (i32.store8 (local.get $null_idx) (i32.const 0))   ;; Place byte 0 as null terminator
    (i32.add (i32.const 1) (local.get $null_idx))      ;; Increment past null for new free_mem index
    (global.set $free_mem)                             ;; Save new free_mem index
   )

  ;; Function to copy memory. Args: [source] [destination] [size]
  ;; No return value.
  (func $_mem_copy (param $src i32) (param $dest i32) (param $size i32)
    (loop $_mem_copy_loop
      (if (i32.eqz (local.get $size)) (then (return)))
      (local.get $dest)
      (i32.load8_u (local.get $src))
      (i32.store8)
      (local.set $src (i32.add (local.get $src) (i32.const 1)))
      (local.set $dest (i32.add (local.get $dest) (i32.const 1)))
      (local.set $size (i32.sub (local.get $size) (i32.const 1)))
      (br $_mem_copy_loop)
    )
  )

  ;; Copies a new string to memory
  (func $_str_copy (param $str i32) (result i32)
    (local $len i32)
    (local $res_str i32)
    (local.set $len (call $_get_len (local.get $str)))
    (local.set $res_str (call $_alloc_str (local.get $len)))
    (call $_mem_copy (local.get $str) (local.get $res_str) (local.get $len))
    (local.get $res_str)
  )

  ;; Get the length of a string
  (func $_get_len (param $str i32) (result i32)
    (local $len i32)
    (local.set $len (i32.const 0))
    (block $_len_block
      (loop $_len_loop
        (i32.load8_u (i32.add (local.get $str) (local.get $len)))
        (i32.eqz)
        (br_if $_len_block)
        (local.set $len (i32.add (local.get $len) (i32.const 1)))
        (br $_len_loop)
      )
    )
    (local.get $len)
  )

  ;; Concatenate strings
  (func $_str_concat (param $str0 i32) (param $str1 i32) (result i32)
    (local $len0 i32)
    (local $len1 i32)
    (local $res_str i32)
    ;; Get length of each string
    (local.set $len0 (call $_get_len (local.get $str0)))
    (local.set $len1 (call $_get_len (local.get $str1)))
    ;; Allocate memory for the result string
    (local.set $res_str
    (call $_alloc_str (i32.add (local.get $len0) (local.get $len1))))
    ;; Copy str0
    (call $_mem_copy (local.get $str0) (local.get $res_str) (local.get $len0))
    ;; Copy str1
    (call $_mem_copy
    (local.get $str1)
    (i32.add (local.get $res_str) (local.get $len0))
    (local.get $len1))
    (local.get $res_str)
  )
  ;; Add a char to a string 
  (func $_add_char (param $str i32) (param $char i32) (result i32)
    (local $len i32)
    (local $res_str i32)
    (local.set $len (call $_get_len (local.get $str)))
    ;; Allocate memory for the result string
    (local.set $res_str (call $_alloc_str (i32.add (local.get $len) (i32.const 1))))
    ;; Copy initial string
    (call $_mem_copy (local.get $str) (local.get $res_str) (local.get $len))
    ;; Add char to end of string
    (i32.store8 (i32.add (local.get $res_str) (local.get $len)) (local.get $char))
    (local.get $res_str)
  )

  (func $Fun13 (param $var29 i32) (result i32)
    ;; Call function 'LineColor'
    (local.get $var29)  ;; Variable 'color'
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'LineWidth'
    (i32.const 4)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; Call function 'Line'
    (global.get $var26)  ;; Global variable 'x_pos'
    (global.get $var27)  ;; Global variable 'y_pos'
    (global.get $var26)  ;; Global variable 'x_pos'
    (global.get $var28)  ;; Global variable 'size'
    (i32.add)
    (global.get $var27)  ;; Global variable 'y_pos'
    (global.get $var28)  ;; Global variable 'size'
    (i32.add)
    (call $drawLine) ;; Call function Line
    ;; Call function 'Line'
    (global.get $var26)  ;; Global variable 'x_pos'
    (global.get $var28)  ;; Global variable 'size'
    (i32.add)
    (global.get $var27)  ;; Global variable 'y_pos'
    (global.get $var26)  ;; Global variable 'x_pos'
    (global.get $var27)  ;; Global variable 'y_pos'
    (global.get $var28)  ;; Global variable 'size'
    (i32.add)
    (call $drawLine) ;; Call function Line
    ;; Calculate RHS for assignment.
    (global.get $var26)  ;; Global variable 'x_pos'
    (global.get $var28)  ;; Global variable 'size'
    (i32.add)
    (i32.const 20)  ;; Literal value
    (i32.add)
    (global.set $var26)  ;; Set global var 'x_pos'
    ;; == If Condition ==
    (global.get $var26)  ;; Global variable 'x_pos'
    (global.get $var28)  ;; Global variable 'size'
    (i32.add)
    (i32.const 600)  ;; Literal value
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 10)  ;; Literal value
        (global.set $var26)  ;; Set global var 'x_pos'
        ;; Calculate RHS for assignment.
        (global.get $var27)  ;; Global variable 'y_pos'
        (global.get $var28)  ;; Global variable 'size'
        (i32.add)
        (i32.const 20)  ;; Literal value
        (i32.add)
        (global.set $var27)  ;; Set global var 'y_pos'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun14 (result i32)
    ;; Call function 'LineColor'
    (i32.const 0)  ;; String literal at memory position 0
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'FillColor'
    (i32.const 6)  ;; String literal at memory position 6
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'LineWidth'
    (i32.const 4)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; Call function 'Rect'
    (i32.const 0)  ;; Literal value
    (i32.const 0)  ;; Literal value
    (i32.const 600)  ;; Literal value
    (i32.const 600)  ;; Literal value
    (call $drawRect) ;; Call function Rect
    ;; Call function 'DrawX'
    (i32.const 12)  ;; String literal at memory position 12
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 19)  ;; String literal at memory position 19
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 26)  ;; String literal at memory position 26
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 33)  ;; String literal at memory position 33
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 38)  ;; String literal at memory position 38
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 44)  ;; String literal at memory position 44
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 49)  ;; String literal at memory position 49
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 57)  ;; String literal at memory position 57
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 65)  ;; String literal at memory position 65
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun15 (result i32)
    ;; Calculate RHS for assignment.
    (i32.const 10)  ;; Literal value
    (global.set $var26)  ;; Set global var 'x_pos'
    ;; Calculate RHS for assignment.
    (i32.const 10)  ;; Literal value
    (global.set $var27)  ;; Set global var 'y_pos'
    ;; Calculate RHS for assignment.
    (global.get $var28)  ;; Global variable 'size'
    (i32.const 20)  ;; Literal value
    (i32.add)
    (global.set $var28)  ;; Set global var 'size'
    ;; == If Condition ==
    (global.get $var28)  ;; Global variable 'size'
    (i32.const 300)  ;; Literal value
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 300)  ;; Literal value
        (global.set $var28)  ;; Set global var 'size'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Call function 'DrawScreen'
    (call $Fun14)  ;; Call 'DrawScreen'
    (drop) ;; Result not used.
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun16 (result i32)
    ;; Calculate RHS for assignment.
    (i32.const 10)  ;; Literal value
    (global.set $var26)  ;; Set global var 'x_pos'
    ;; Calculate RHS for assignment.
    (i32.const 10)  ;; Literal value
    (global.set $var27)  ;; Set global var 'y_pos'
    ;; Calculate RHS for assignment.
    (global.get $var28)  ;; Global variable 'size'
    (i32.const 20)  ;; Literal value
    (i32.sub)
    (global.set $var28)  ;; Set global var 'size'
    ;; == If Condition ==
    (global.get $var28)  ;; Global variable 'size'
    (i32.const 20)  ;; Literal value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 20)  ;; Literal value
        (global.set $var28)  ;; Set global var 'size'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Call function 'DrawScreen'
    (call $Fun14)  ;; Call 'DrawScreen'
    (drop) ;; Result not used.
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun17 (result i32)
    ;; Call function 'SetTitle'
    (i32.const 73)  ;; String literal at memory position 73
    (call $setTitle) ;; Call function SetTitle
    ;; Call function 'DrawScreen'
    (call $Fun14)  ;; Call 'DrawScreen'
    (drop) ;; Result not used.
    ;; Call function 'AddButton'
    (i32.const 108)  ;; String literal at memory position 108
    (i32.const 116)  ;; String literal at memory position 116
    (call $addButton) ;; Call function AddButton
    ;; Call function 'AddButton'
    (i32.const 124)  ;; String literal at memory position 124
    (i32.const 133)  ;; String literal at memory position 133
    (call $addButton) ;; Call function AddButton
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )

  (func $Init
    ;; Initialize global 'x_pos'
    (i32.const 10)  ;; Literal value
    (global.set $var26)
    ;; Initialize global 'y_pos'
    (i32.const 10)  ;; Literal value
    (global.set $var27)
    ;; Initialize global 'size'
    (i32.const 80)  ;; Literal value
    (global.set $var28)
  )
  (start $Init)

  (export "DrawX" (func $Fun13))
  (export "DrawScreen" (func $Fun14))
  (export "IncSize" (func $Fun15))
  (export "DecSize" (func $Fun16))
  (export "Main" (func $Fun17))
) ;; End module
