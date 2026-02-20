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
  (global $free_mem (mut i32) (i32.const 144))


  (data (i32.const 0) "#000080\00")  ;; String literal
  (data (i32.const 8) "#800000\00")  ;; String literal
  (data (i32.const 16) "#008000\00")  ;; String literal
  (data (i32.const 24) "orange\00")  ;; String literal
  (data (i32.const 31) "purple\00")  ;; String literal
  (data (i32.const 38) "yellow\00")  ;; String literal
  (data (i32.const 45) "pink\00")  ;; String literal
  (data (i32.const 50) "brown\00")  ;; String literal
  (data (i32.const 56) "gray\00")  ;; String literal
  (data (i32.const 61) "Test: Call function to make lots of X's in different sizes, colors and thicknesses\00")  ;; String literal

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

  (func $Fun13 (param $var26 i32) (param $var27 i32) (param $var28 i32) (param $var29 i32) (param $var30 i32) (result i32)
    ;; Call function 'LineColor'
    (local.get $var30)  ;; Variable 'color'
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'LineWidth'
    (local.get $var29)  ;; Variable 'line_width'
    (call $setLineWidth) ;; Call function LineWidth
    ;; Call function 'Line'
    (local.get $var26)  ;; Variable 'x'
    (local.get $var27)  ;; Variable 'y'
    (local.get $var26)  ;; Variable 'x'
    (local.get $var28)  ;; Variable 'size'
    (i32.add)
    (local.get $var27)  ;; Variable 'y'
    (local.get $var28)  ;; Variable 'size'
    (i32.add)
    (call $drawLine) ;; Call function Line
    ;; Call function 'Line'
    (local.get $var26)  ;; Variable 'x'
    (local.get $var28)  ;; Variable 'size'
    (i32.add)
    (local.get $var27)  ;; Variable 'y'
    (local.get $var26)  ;; Variable 'x'
    (local.get $var27)  ;; Variable 'y'
    (local.get $var28)  ;; Variable 'size'
    (i32.add)
    (call $drawLine) ;; Call function Line
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun14 (result i32)
    ;; Call function 'DrawX'
    (i32.const 10)  ;; Literal value
    (i32.const 10)  ;; Literal value
    (i32.const 180)  ;; Literal value
    (i32.const 8)  ;; Literal value
    (i32.const 0)  ;; String literal at memory position 0
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 210)  ;; Literal value
    (i32.const 10)  ;; Literal value
    (i32.const 180)  ;; Literal value
    (i32.const 4)  ;; Literal value
    (i32.const 8)  ;; String literal at memory position 8
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 410)  ;; Literal value
    (i32.const 10)  ;; Literal value
    (i32.const 180)  ;; Literal value
    (i32.const 12)  ;; Literal value
    (i32.const 16)  ;; String literal at memory position 16
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 10)  ;; Literal value
    (i32.const 300)  ;; Literal value
    (i32.const 80)  ;; Literal value
    (i32.const 6)  ;; Literal value
    (i32.const 24)  ;; String literal at memory position 24
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 110)  ;; Literal value
    (i32.const 300)  ;; Literal value
    (i32.const 80)  ;; Literal value
    (i32.const 5)  ;; Literal value
    (i32.const 31)  ;; String literal at memory position 31
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 210)  ;; Literal value
    (i32.const 300)  ;; Literal value
    (i32.const 80)  ;; Literal value
    (i32.const 4)  ;; Literal value
    (i32.const 38)  ;; String literal at memory position 38
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 310)  ;; Literal value
    (i32.const 300)  ;; Literal value
    (i32.const 80)  ;; Literal value
    (i32.const 3)  ;; Literal value
    (i32.const 45)  ;; String literal at memory position 45
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 410)  ;; Literal value
    (i32.const 300)  ;; Literal value
    (i32.const 80)  ;; Literal value
    (i32.const 2)  ;; Literal value
    (i32.const 50)  ;; String literal at memory position 50
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'DrawX'
    (i32.const 510)  ;; Literal value
    (i32.const 300)  ;; Literal value
    (i32.const 80)  ;; Literal value
    (i32.const 1)  ;; Literal value
    (i32.const 56)  ;; String literal at memory position 56
    (call $Fun13)  ;; Call 'DrawX'
    (drop) ;; Result not used.
    ;; Call function 'SetTitle'
    (i32.const 61)  ;; String literal at memory position 61
    (call $setTitle) ;; Call function SetTitle
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )

  (func $Init
  )
  (start $Init)

  (export "DrawX" (func $Fun13))
  (export "Main" (func $Fun14))
) ;; End module
