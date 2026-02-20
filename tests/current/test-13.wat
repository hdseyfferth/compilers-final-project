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
  (global $free_mem (mut i32) (i32.const 205))

  (global $var26 (mut i32) (i32.const 0))  ;; Global variable 'player_x'
  (global $var27 (mut i32) (i32.const 0))  ;; Global variable 'player_y'
  (global $var28 (mut i32) (i32.const 0))  ;; Global variable 'player_size'
  (global $var29 (mut i32) (i32.const 0))  ;; Global variable 'player_accel'
  (global $var30 (mut i32) (i32.const 0))  ;; Global variable 'item1_x'
  (global $var31 (mut i32) (i32.const 0))  ;; Global variable 'item1_y'
  (global $var32 (mut i32) (i32.const 0))  ;; Global variable 'item1_size'
  (global $var33 (mut i32) (i32.const 0))  ;; Global variable 'item1_accel'
  (global $var34 (mut i32) (i32.const 0))  ;; Global variable 'item2_x'
  (global $var35 (mut i32) (i32.const 0))  ;; Global variable 'item2_y'
  (global $var36 (mut i32) (i32.const 0))  ;; Global variable 'item2_size'
  (global $var37 (mut i32) (i32.const 0))  ;; Global variable 'item2_accel'
  (global $var38 (mut i32) (i32.const 0))  ;; Global variable 'item3_x'
  (global $var39 (mut i32) (i32.const 0))  ;; Global variable 'item3_y'
  (global $var40 (mut i32) (i32.const 0))  ;; Global variable 'item3_size'
  (global $var41 (mut i32) (i32.const 0))  ;; Global variable 'item3_accel'
  (global $var42 (mut i32) (i32.const 0))  ;; Global variable 'item4_x'
  (global $var43 (mut i32) (i32.const 0))  ;; Global variable 'item4_y'
  (global $var44 (mut i32) (i32.const 0))  ;; Global variable 'item4_size'
  (global $var45 (mut i32) (i32.const 0))  ;; Global variable 'item4_accel'
  (global $var46 (mut i32) (i32.const 0))  ;; Global variable 'shield_x'
  (global $var47 (mut i32) (i32.const 0))  ;; Global variable 'shield_y'
  (global $var48 (mut i32) (i32.const 0))  ;; Global variable 'shield_size'
  (global $var49 (mut i32) (i32.const 0))  ;; Global variable 'vel_x'
  (global $var50 (mut i32) (i32.const 0))  ;; Global variable 'vel_y'
  (global $var51 (mut i32) (i32.const 0))  ;; Global variable 'flag1'
  (global $var52 (mut i32) (i32.const 0))  ;; Global variable 'flag2'
  (global $var53 (mut i32) (i32.const 0))  ;; Global variable 'flag3'
  (global $var54 (mut i32) (i32.const 0))  ;; Global variable 'flag4'
  (global $var55 (mut i32) (i32.const 0))  ;; Global variable 'flag5'
  (global $var56 (mut i32) (i32.const 0))  ;; Global variable 'flag6'
  (global $var57 (mut i32) (i32.const 0))  ;; Global variable 'flag7'
  (global $var58 (mut i32) (i32.const 0))  ;; Global variable 'flag8'
  (global $var59 (mut i32) (i32.const 0))  ;; Global variable 'flag9'
  (global $var60 (mut i32) (i32.const 0))  ;; Global variable 'flag10'
  (global $var61 (mut i32) (i32.const 0))  ;; Global variable 'flag11'
  (global $var62 (mut i32) (i32.const 0))  ;; Global variable 'flag12'
  (global $var63 (mut i32) (i32.const 0))  ;; Global variable 'flag13'
  (global $var64 (mut i32) (i32.const 0))  ;; Global variable 'flag14'
  (global $var65 (mut i32) (i32.const 0))  ;; Global variable 'flag15'
  (global $var66 (mut i32) (i32.const 0))  ;; Global variable 'flag16'
  (global $var67 (mut i32) (i32.const 0))  ;; Global variable 'flag1_x'
  (global $var68 (mut i32) (i32.const 0))  ;; Global variable 'flag1_y'
  (global $var69 (mut i32) (i32.const 0))  ;; Global variable 'flag2_x'
  (global $var70 (mut i32) (i32.const 0))  ;; Global variable 'flag2_y'
  (global $var71 (mut i32) (i32.const 0))  ;; Global variable 'flag3_x'
  (global $var72 (mut i32) (i32.const 0))  ;; Global variable 'flag3_y'
  (global $var73 (mut i32) (i32.const 0))  ;; Global variable 'flag4_x'
  (global $var74 (mut i32) (i32.const 0))  ;; Global variable 'flag4_y'
  (global $var75 (mut i32) (i32.const 0))  ;; Global variable 'flag5_x'
  (global $var76 (mut i32) (i32.const 0))  ;; Global variable 'flag5_y'
  (global $var77 (mut i32) (i32.const 0))  ;; Global variable 'flag6_x'
  (global $var78 (mut i32) (i32.const 0))  ;; Global variable 'flag6_y'
  (global $var79 (mut i32) (i32.const 0))  ;; Global variable 'flag7_x'
  (global $var80 (mut i32) (i32.const 0))  ;; Global variable 'flag7_y'
  (global $var81 (mut i32) (i32.const 0))  ;; Global variable 'flag8_x'
  (global $var82 (mut i32) (i32.const 0))  ;; Global variable 'flag8_y'
  (global $var83 (mut i32) (i32.const 0))  ;; Global variable 'flag9_x'
  (global $var84 (mut i32) (i32.const 0))  ;; Global variable 'flag9_y'
  (global $var85 (mut i32) (i32.const 0))  ;; Global variable 'flag10_x'
  (global $var86 (mut i32) (i32.const 0))  ;; Global variable 'flag10_y'
  (global $var87 (mut i32) (i32.const 0))  ;; Global variable 'flag11_x'
  (global $var88 (mut i32) (i32.const 0))  ;; Global variable 'flag11_y'
  (global $var89 (mut i32) (i32.const 0))  ;; Global variable 'flag12_x'
  (global $var90 (mut i32) (i32.const 0))  ;; Global variable 'flag12_y'
  (global $var91 (mut i32) (i32.const 0))  ;; Global variable 'flag13_x'
  (global $var92 (mut i32) (i32.const 0))  ;; Global variable 'flag13_y'
  (global $var93 (mut i32) (i32.const 0))  ;; Global variable 'flag14_x'
  (global $var94 (mut i32) (i32.const 0))  ;; Global variable 'flag14_y'
  (global $var95 (mut i32) (i32.const 0))  ;; Global variable 'flag15_x'
  (global $var96 (mut i32) (i32.const 0))  ;; Global variable 'flag15_y'
  (global $var97 (mut i32) (i32.const 0))  ;; Global variable 'flag16_x'
  (global $var98 (mut i32) (i32.const 0))  ;; Global variable 'flag16_y'
  (global $var99 (mut i32) (i32.const 0))  ;; Global variable 'flag_size'
  (global $var100 (mut i32) (i32.const 0))  ;; Global variable 'done'

  (data (i32.const 0) "black\00")  ;; String literal
  (data (i32.const 6) "#6e6a00ff\00")  ;; String literal
  (data (i32.const 16) "#6e6a00d6\00")  ;; String literal
  (data (i32.const 26) "#303030\00")  ;; String literal
  (data (i32.const 34) "#808080\00")  ;; String literal
  (data (i32.const 42) "green\00")  ;; String literal
  (data (i32.const 48) "white\00")  ;; String literal
  (data (i32.const 54) "blue\00")  ;; String literal
  (data (i32.const 59) "red\00")  ;; String literal
  (data (i32.const 63) "yellow\00")  ;; String literal
  (data (i32.const 70) "You Win!\00")  ;; String literal
  (data (i32.const 79) "Test: Continuous Animation\00")  ;; String literal
  (data (i32.const 106) "s\00")  ;; String literal
  (data (i32.const 108) "ActivateShield\00")  ;; String literal
  (data (i32.const 123) "ArrowUp\00")  ;; String literal
  (data (i32.const 131) "KeyUp\00")  ;; String literal
  (data (i32.const 137) "ArrowLeft\00")  ;; String literal
  (data (i32.const 147) "KeyLeft\00")  ;; String literal
  (data (i32.const 155) "ArrowDown\00")  ;; String literal
  (data (i32.const 165) "KeyDown\00")  ;; String literal
  (data (i32.const 173) "ArrowRight\00")  ;; String literal
  (data (i32.const 184) "KeyRight\00")  ;; String literal
  (data (i32.const 193) "UpdateBoard\00")  ;; String literal

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

  (func $Fun13 (result i32)
    ;; == If Condition ==
    (global.get $var48)  ;; Global variable 'shield_size'
    (i32.const 0)  ;; Literal value
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (global.get $var26)  ;; Global variable 'player_x'
    (global.set $var46)  ;; Set global var 'shield_x'
    ;; Calculate RHS for assignment.
    (global.get $var27)  ;; Global variable 'player_y'
    (global.set $var47)  ;; Set global var 'shield_y'
    ;; Calculate RHS for assignment.
    (i32.const 800)  ;; Literal value
    (global.set $var48)  ;; Set global var 'shield_size'
    ;; == Generate return code ==
    (i32.const 1)  ;; Literal value
    (return)
  )
  (func $Fun14 (result i32)
    ;; Calculate RHS for assignment.
    (i32.const 3000)  ;; Literal value
    (global.set $var26)  ;; Set global var 'player_x'
    ;; Calculate RHS for assignment.
    (i32.const 3000)  ;; Literal value
    (global.set $var27)  ;; Set global var 'player_y'
    ;; Calculate RHS for assignment.
    (i32.const 1000)  ;; Literal value
    (global.set $var30)  ;; Set global var 'item1_x'
    ;; Calculate RHS for assignment.
    (i32.const 1000)  ;; Literal value
    (global.set $var31)  ;; Set global var 'item1_y'
    ;; Calculate RHS for assignment.
    (i32.const 5000)  ;; Literal value
    (global.set $var34)  ;; Set global var 'item2_x'
    ;; Calculate RHS for assignment.
    (i32.const 1000)  ;; Literal value
    (global.set $var35)  ;; Set global var 'item2_y'
    ;; Calculate RHS for assignment.
    (i32.const 1000)  ;; Literal value
    (global.set $var38)  ;; Set global var 'item3_x'
    ;; Calculate RHS for assignment.
    (i32.const 5000)  ;; Literal value
    (global.set $var39)  ;; Set global var 'item3_y'
    ;; Calculate RHS for assignment.
    (i32.const 5000)  ;; Literal value
    (global.set $var42)  ;; Set global var 'item4_x'
    ;; Calculate RHS for assignment.
    (i32.const 5000)  ;; Literal value
    (global.set $var43)  ;; Set global var 'item4_y'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var49)  ;; Set global var 'vel_x'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var50)  ;; Set global var 'vel_y'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var48)  ;; Set global var 'shield_size'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var51)  ;; Set global var 'flag1'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var52)  ;; Set global var 'flag2'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var53)  ;; Set global var 'flag3'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var54)  ;; Set global var 'flag4'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var55)  ;; Set global var 'flag5'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var56)  ;; Set global var 'flag6'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var57)  ;; Set global var 'flag7'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var58)  ;; Set global var 'flag8'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var59)  ;; Set global var 'flag9'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var60)  ;; Set global var 'flag10'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var61)  ;; Set global var 'flag11'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var62)  ;; Set global var 'flag12'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var63)  ;; Set global var 'flag13'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var64)  ;; Set global var 'flag14'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var65)  ;; Set global var 'flag15'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (global.set $var66)  ;; Set global var 'flag16'
    ;; Call function 'ActivateShield'
    (call $Fun13)  ;; Call 'ActivateShield'
    (drop) ;; Result not used.
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun15 (param $var101 i32) (param $var102 i32) (param $var103 i32) (param $var104 i32) (param $var105 i32) (result i32)
    (local $var106 i32) ;; Declare var 'max_sqr'
    (local $var107 i32) ;; Declare var 'x_dist'
    (local $var108 i32) ;; Declare var 'x_sqr'
    (local $var109 i32) ;; Declare var 'y_dist'
    (local $var110 i32) ;; Declare var 'y_sqr'
    ;; Calculate RHS for assignment.
    (local.get $var105)  ;; Variable 'max_dist'
    (local.get $var105)  ;; Variable 'max_dist'
    (i32.mul)
    (local.set $var106)  ;; Set var 'max_sqr'
    ;; Calculate RHS for assignment.
    (local.get $var101)  ;; Variable 'x1'
    (local.get $var103)  ;; Variable 'x2'
    (i32.sub)
    (local.set $var107)  ;; Set var 'x_dist'
    ;; Calculate RHS for assignment.
    (local.get $var107)  ;; Variable 'x_dist'
    (local.get $var107)  ;; Variable 'x_dist'
    (i32.mul)
    (local.set $var108)  ;; Set var 'x_sqr'
    ;; Calculate RHS for assignment.
    (local.get $var102)  ;; Variable 'y1'
    (local.get $var104)  ;; Variable 'y2'
    (i32.sub)
    (local.set $var109)  ;; Set var 'y_dist'
    ;; Calculate RHS for assignment.
    (local.get $var109)  ;; Variable 'y_dist'
    (local.get $var109)  ;; Variable 'y_dist'
    (i32.mul)
    (local.set $var110)  ;; Set var 'y_sqr'
    ;; == Generate return code ==
    (local.get $var106)  ;; Variable 'max_sqr'
    (local.get $var108)  ;; Variable 'x_sqr'
    (local.get $var110)  ;; Variable 'y_sqr'
    (i32.add)
    (i32.ge_s)
    (return)
  )
  (func $Fun16 (param $var111 i32) (param $var112 i32) (param $var113 i32) (param $var114 i32) (param $var115 i32) (param $var116 i32) (result i32)
    ;; == If Condition ==
    (local.get $var113)  ;; Variable 'r1'
    (i32.const 0)  ;; Literal value
    (i32.le_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (local.get $var116)  ;; Variable 'r2'
    (i32.const 0)  ;; Literal value
    (i32.le_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    ;; Call function 'TestInRange'
    (local.get $var111)  ;; Variable 'x1'
    (local.get $var112)  ;; Variable 'y1'
    (local.get $var114)  ;; Variable 'x2'
    (local.get $var115)  ;; Variable 'y2'
    (local.get $var113)  ;; Variable 'r1'
    (local.get $var116)  ;; Variable 'r2'
    (i32.add)
    (call $Fun15)  ;; Call 'TestInRange'
    (return)
  )
  (func $Fun17 (result i32)
    ;; Call function 'FillColor'
    (i32.const 0)  ;; String literal at memory position 0
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'FillColor'
    (i32.const 0)  ;; String literal at memory position 0
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'LineWidth'
    (i32.const 6)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; Call function 'Rect'
    (i32.const 0)  ;; Literal value
    (i32.const 0)  ;; Literal value
    (i32.const 600)  ;; Literal value
    (i32.const 600)  ;; Literal value
    (call $drawRect) ;; Call function Rect
    ;; == If Condition ==
    (global.get $var48)  ;; Global variable 'shield_size'
    (i32.const 0)  ;; Literal value
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'LineColor'
        (i32.const 6)  ;; String literal at memory position 6
        (call $setStrokeColor) ;; Call function LineColor
        ;; Call function 'FillColor'
        (i32.const 16)  ;; String literal at memory position 16
        (call $setFillColor) ;; Call function FillColor
        ;; Call function 'LineWidth'
        (i32.const 1)  ;; Literal value
        (call $setLineWidth) ;; Call function LineWidth
        ;; Call function 'Circle'
        (global.get $var46)  ;; Global variable 'shield_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var47)  ;; Global variable 'shield_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var48)  ;; Global variable 'shield_size'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Call function 'FillColor'
    (i32.const 26)  ;; String literal at memory position 26
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'LineColor'
    (i32.const 34)  ;; String literal at memory position 34
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'LineWidth'
    (i32.const 4)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; == If Condition ==
    (global.get $var51)  ;; Global variable 'flag1'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var67)  ;; Global variable 'flag1_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var68)  ;; Global variable 'flag1_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var52)  ;; Global variable 'flag2'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var69)  ;; Global variable 'flag2_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var70)  ;; Global variable 'flag2_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var53)  ;; Global variable 'flag3'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var71)  ;; Global variable 'flag3_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var72)  ;; Global variable 'flag3_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var54)  ;; Global variable 'flag4'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var73)  ;; Global variable 'flag4_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var74)  ;; Global variable 'flag4_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var55)  ;; Global variable 'flag5'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var75)  ;; Global variable 'flag5_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var76)  ;; Global variable 'flag5_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var56)  ;; Global variable 'flag6'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var77)  ;; Global variable 'flag6_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var78)  ;; Global variable 'flag6_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var57)  ;; Global variable 'flag7'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var79)  ;; Global variable 'flag7_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var80)  ;; Global variable 'flag7_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var58)  ;; Global variable 'flag8'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var81)  ;; Global variable 'flag8_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var82)  ;; Global variable 'flag8_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var59)  ;; Global variable 'flag9'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var83)  ;; Global variable 'flag9_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var84)  ;; Global variable 'flag9_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var60)  ;; Global variable 'flag10'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var85)  ;; Global variable 'flag10_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var86)  ;; Global variable 'flag10_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var61)  ;; Global variable 'flag11'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var87)  ;; Global variable 'flag11_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var88)  ;; Global variable 'flag11_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var62)  ;; Global variable 'flag12'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var89)  ;; Global variable 'flag12_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var90)  ;; Global variable 'flag12_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var63)  ;; Global variable 'flag13'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var91)  ;; Global variable 'flag13_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var92)  ;; Global variable 'flag13_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var64)  ;; Global variable 'flag14'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var93)  ;; Global variable 'flag14_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var94)  ;; Global variable 'flag14_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var65)  ;; Global variable 'flag15'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var95)  ;; Global variable 'flag15_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var96)  ;; Global variable 'flag15_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var66)  ;; Global variable 'flag16'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var97)  ;; Global variable 'flag16_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var98)  ;; Global variable 'flag16_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Call function 'FillColor'
    (i32.const 42)  ;; String literal at memory position 42
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'LineColor'
    (i32.const 48)  ;; String literal at memory position 48
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'LineWidth'
    (i32.const 1)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; == If Condition ==
    (global.get $var51)  ;; Global variable 'flag1'
    (i32.eqz)  ;; Do operator '!'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Circle'
        (global.get $var67)  ;; Global variable 'flag1_x'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var68)  ;; Global variable 'flag1_y'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $drawCircle) ;; Call function Circle
      ) ;; End 'then'
      (else ;; 'else' block
        ;; == If Condition ==
        (global.get $var52)  ;; Global variable 'flag2'
        (i32.eqz)  ;; Do operator '!'
        (if ;; Execute code based on result of condition.
          (then ;; 'then' block
            ;; Call function 'Circle'
            (global.get $var69)  ;; Global variable 'flag2_x'
            (i32.const 10)  ;; Literal value
            (i32.div_s)
            (global.get $var70)  ;; Global variable 'flag2_y'
            (i32.const 10)  ;; Literal value
            (i32.div_s)
            (global.get $var99)  ;; Global variable 'flag_size'
            (call $drawCircle) ;; Call function Circle
          ) ;; End 'then'
          (else ;; 'else' block
            ;; == If Condition ==
            (global.get $var53)  ;; Global variable 'flag3'
            (i32.eqz)  ;; Do operator '!'
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; Call function 'Circle'
                (global.get $var71)  ;; Global variable 'flag3_x'
                (i32.const 10)  ;; Literal value
                (i32.div_s)
                (global.get $var72)  ;; Global variable 'flag3_y'
                (i32.const 10)  ;; Literal value
                (i32.div_s)
                (global.get $var99)  ;; Global variable 'flag_size'
                (call $drawCircle) ;; Call function Circle
              ) ;; End 'then'
              (else ;; 'else' block
                ;; == If Condition ==
                (global.get $var54)  ;; Global variable 'flag4'
                (i32.eqz)  ;; Do operator '!'
                (if ;; Execute code based on result of condition.
                  (then ;; 'then' block
                    ;; Call function 'Circle'
                    (global.get $var73)  ;; Global variable 'flag4_x'
                    (i32.const 10)  ;; Literal value
                    (i32.div_s)
                    (global.get $var74)  ;; Global variable 'flag4_y'
                    (i32.const 10)  ;; Literal value
                    (i32.div_s)
                    (global.get $var99)  ;; Global variable 'flag_size'
                    (call $drawCircle) ;; Call function Circle
                  ) ;; End 'then'
                  (else ;; 'else' block
                    ;; == If Condition ==
                    (global.get $var55)  ;; Global variable 'flag5'
                    (i32.eqz)  ;; Do operator '!'
                    (if ;; Execute code based on result of condition.
                      (then ;; 'then' block
                        ;; Call function 'Circle'
                        (global.get $var75)  ;; Global variable 'flag5_x'
                        (i32.const 10)  ;; Literal value
                        (i32.div_s)
                        (global.get $var76)  ;; Global variable 'flag5_y'
                        (i32.const 10)  ;; Literal value
                        (i32.div_s)
                        (global.get $var99)  ;; Global variable 'flag_size'
                        (call $drawCircle) ;; Call function Circle
                      ) ;; End 'then'
                      (else ;; 'else' block
                        ;; == If Condition ==
                        (global.get $var56)  ;; Global variable 'flag6'
                        (i32.eqz)  ;; Do operator '!'
                        (if ;; Execute code based on result of condition.
                          (then ;; 'then' block
                            ;; Call function 'Circle'
                            (global.get $var77)  ;; Global variable 'flag6_x'
                            (i32.const 10)  ;; Literal value
                            (i32.div_s)
                            (global.get $var78)  ;; Global variable 'flag6_y'
                            (i32.const 10)  ;; Literal value
                            (i32.div_s)
                            (global.get $var99)  ;; Global variable 'flag_size'
                            (call $drawCircle) ;; Call function Circle
                          ) ;; End 'then'
                          (else ;; 'else' block
                            ;; == If Condition ==
                            (global.get $var57)  ;; Global variable 'flag7'
                            (i32.eqz)  ;; Do operator '!'
                            (if ;; Execute code based on result of condition.
                              (then ;; 'then' block
                                ;; Call function 'Circle'
                                (global.get $var79)  ;; Global variable 'flag7_x'
                                (i32.const 10)  ;; Literal value
                                (i32.div_s)
                                (global.get $var80)  ;; Global variable 'flag7_y'
                                (i32.const 10)  ;; Literal value
                                (i32.div_s)
                                (global.get $var99)  ;; Global variable 'flag_size'
                                (call $drawCircle) ;; Call function Circle
                              ) ;; End 'then'
                              (else ;; 'else' block
                                ;; == If Condition ==
                                (global.get $var58)  ;; Global variable 'flag8'
                                (i32.eqz)  ;; Do operator '!'
                                (if ;; Execute code based on result of condition.
                                  (then ;; 'then' block
                                    ;; Call function 'Circle'
                                    (global.get $var81)  ;; Global variable 'flag8_x'
                                    (i32.const 10)  ;; Literal value
                                    (i32.div_s)
                                    (global.get $var82)  ;; Global variable 'flag8_y'
                                    (i32.const 10)  ;; Literal value
                                    (i32.div_s)
                                    (global.get $var99)  ;; Global variable 'flag_size'
                                    (call $drawCircle) ;; Call function Circle
                                  ) ;; End 'then'
                                  (else ;; 'else' block
                                    ;; == If Condition ==
                                    (global.get $var59)  ;; Global variable 'flag9'
                                    (i32.eqz)  ;; Do operator '!'
                                    (if ;; Execute code based on result of condition.
                                      (then ;; 'then' block
                                        ;; Call function 'Circle'
                                        (global.get $var83)  ;; Global variable 'flag9_x'
                                        (i32.const 10)  ;; Literal value
                                        (i32.div_s)
                                        (global.get $var84)  ;; Global variable 'flag9_y'
                                        (i32.const 10)  ;; Literal value
                                        (i32.div_s)
                                        (global.get $var99)  ;; Global variable 'flag_size'
                                        (call $drawCircle) ;; Call function Circle
                                      ) ;; End 'then'
                                      (else ;; 'else' block
                                        ;; == If Condition ==
                                        (global.get $var60)  ;; Global variable 'flag10'
                                        (i32.eqz)  ;; Do operator '!'
                                        (if ;; Execute code based on result of condition.
                                          (then ;; 'then' block
                                            ;; Call function 'Circle'
                                            (global.get $var85)  ;; Global variable 'flag10_x'
                                            (i32.const 10)  ;; Literal value
                                            (i32.div_s)
                                            (global.get $var86)  ;; Global variable 'flag10_y'
                                            (i32.const 10)  ;; Literal value
                                            (i32.div_s)
                                            (global.get $var99)  ;; Global variable 'flag_size'
                                            (call $drawCircle) ;; Call function Circle
                                          ) ;; End 'then'
                                          (else ;; 'else' block
                                            ;; == If Condition ==
                                            (global.get $var61)  ;; Global variable 'flag11'
                                            (i32.eqz)  ;; Do operator '!'
                                            (if ;; Execute code based on result of condition.
                                              (then ;; 'then' block
                                                ;; Call function 'Circle'
                                                (global.get $var87)  ;; Global variable 'flag11_x'
                                                (i32.const 10)  ;; Literal value
                                                (i32.div_s)
                                                (global.get $var88)  ;; Global variable 'flag11_y'
                                                (i32.const 10)  ;; Literal value
                                                (i32.div_s)
                                                (global.get $var99)  ;; Global variable 'flag_size'
                                                (call $drawCircle) ;; Call function Circle
                                              ) ;; End 'then'
                                              (else ;; 'else' block
                                                ;; == If Condition ==
                                                (global.get $var62)  ;; Global variable 'flag12'
                                                (i32.eqz)  ;; Do operator '!'
                                                (if ;; Execute code based on result of condition.
                                                  (then ;; 'then' block
                                                    ;; Call function 'Circle'
                                                    (global.get $var89)  ;; Global variable 'flag12_x'
                                                    (i32.const 10)  ;; Literal value
                                                    (i32.div_s)
                                                    (global.get $var90)  ;; Global variable 'flag12_y'
                                                    (i32.const 10)  ;; Literal value
                                                    (i32.div_s)
                                                    (global.get $var99)  ;; Global variable 'flag_size'
                                                    (call $drawCircle) ;; Call function Circle
                                                  ) ;; End 'then'
                                                  (else ;; 'else' block
                                                    ;; == If Condition ==
                                                    (global.get $var63)  ;; Global variable 'flag13'
                                                    (i32.eqz)  ;; Do operator '!'
                                                    (if ;; Execute code based on result of condition.
                                                      (then ;; 'then' block
                                                        ;; Call function 'Circle'
                                                        (global.get $var91)  ;; Global variable 'flag13_x'
                                                        (i32.const 10)  ;; Literal value
                                                        (i32.div_s)
                                                        (global.get $var92)  ;; Global variable 'flag13_y'
                                                        (i32.const 10)  ;; Literal value
                                                        (i32.div_s)
                                                        (global.get $var99)  ;; Global variable 'flag_size'
                                                        (call $drawCircle) ;; Call function Circle
                                                      ) ;; End 'then'
                                                      (else ;; 'else' block
                                                        ;; == If Condition ==
                                                        (global.get $var64)  ;; Global variable 'flag14'
                                                        (i32.eqz)  ;; Do operator '!'
                                                        (if ;; Execute code based on result of condition.
                                                          (then ;; 'then' block
                                                            ;; Call function 'Circle'
                                                            (global.get $var93)  ;; Global variable 'flag14_x'
                                                            (i32.const 10)  ;; Literal value
                                                            (i32.div_s)
                                                            (global.get $var94)  ;; Global variable 'flag14_y'
                                                            (i32.const 10)  ;; Literal value
                                                            (i32.div_s)
                                                            (global.get $var99)  ;; Global variable 'flag_size'
                                                            (call $drawCircle) ;; Call function Circle
                                                          ) ;; End 'then'
                                                          (else ;; 'else' block
                                                            ;; == If Condition ==
                                                            (global.get $var65)  ;; Global variable 'flag15'
                                                            (i32.eqz)  ;; Do operator '!'
                                                            (if ;; Execute code based on result of condition.
                                                              (then ;; 'then' block
                                                                ;; Call function 'Circle'
                                                                (global.get $var95)  ;; Global variable 'flag15_x'
                                                                (i32.const 10)  ;; Literal value
                                                                (i32.div_s)
                                                                (global.get $var96)  ;; Global variable 'flag15_y'
                                                                (i32.const 10)  ;; Literal value
                                                                (i32.div_s)
                                                                (global.get $var99)  ;; Global variable 'flag_size'
                                                                (call $drawCircle) ;; Call function Circle
                                                              ) ;; End 'then'
                                                              (else ;; 'else' block
                                                                ;; == If Condition ==
                                                                (global.get $var66)  ;; Global variable 'flag16'
                                                                (i32.eqz)  ;; Do operator '!'
                                                                (if ;; Execute code based on result of condition.
                                                                  (then ;; 'then' block
                                                                    ;; Call function 'Circle'
                                                                    (global.get $var97)  ;; Global variable 'flag16_x'
                                                                    (i32.const 10)  ;; Literal value
                                                                    (i32.div_s)
                                                                    (global.get $var98)  ;; Global variable 'flag16_y'
                                                                    (i32.const 10)  ;; Literal value
                                                                    (i32.div_s)
                                                                    (global.get $var99)  ;; Global variable 'flag_size'
                                                                    (call $drawCircle) ;; Call function Circle
                                                                  ) ;; End 'then'
                                                                ) ;; End 'if'
                                                              ) ;; End 'else'
                                                            ) ;; End 'if'
                                                          ) ;; End 'else'
                                                        ) ;; End 'if'
                                                      ) ;; End 'else'
                                                    ) ;; End 'if'
                                                  ) ;; End 'else'
                                                ) ;; End 'if'
                                              ) ;; End 'else'
                                            ) ;; End 'if'
                                          ) ;; End 'else'
                                        ) ;; End 'if'
                                      ) ;; End 'else'
                                    ) ;; End 'if'
                                  ) ;; End 'else'
                                ) ;; End 'if'
                              ) ;; End 'else'
                            ) ;; End 'if'
                          ) ;; End 'else'
                        ) ;; End 'if'
                      ) ;; End 'else'
                    ) ;; End 'if'
                  ) ;; End 'else'
                ) ;; End 'if'
              ) ;; End 'else'
            ) ;; End 'if'
          ) ;; End 'else'
        ) ;; End 'if'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; Call function 'LineColor'
    (i32.const 48)  ;; String literal at memory position 48
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'FillColor'
    (i32.const 54)  ;; String literal at memory position 54
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'LineWidth'
    (i32.const 2)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; Call function 'Circle'
    (global.get $var26)  ;; Global variable 'player_x'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var27)  ;; Global variable 'player_y'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var28)  ;; Global variable 'player_size'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (call $drawCircle) ;; Call function Circle
    ;; Call function 'LineColor'
    (i32.const 48)  ;; String literal at memory position 48
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'FillColor'
    (i32.const 59)  ;; String literal at memory position 59
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'LineWidth'
    (i32.const 1)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; Call function 'Circle'
    (global.get $var30)  ;; Global variable 'item1_x'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var31)  ;; Global variable 'item1_y'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var32)  ;; Global variable 'item1_size'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (call $drawCircle) ;; Call function Circle
    ;; Call function 'Circle'
    (global.get $var34)  ;; Global variable 'item2_x'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var35)  ;; Global variable 'item2_y'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var36)  ;; Global variable 'item2_size'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (call $drawCircle) ;; Call function Circle
    ;; Call function 'Circle'
    (global.get $var38)  ;; Global variable 'item3_x'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var39)  ;; Global variable 'item3_y'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var40)  ;; Global variable 'item3_size'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (call $drawCircle) ;; Call function Circle
    ;; Call function 'Circle'
    (global.get $var42)  ;; Global variable 'item4_x'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var43)  ;; Global variable 'item4_y'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (global.get $var44)  ;; Global variable 'item4_size'
    (i32.const 10)  ;; Literal value
    (i32.div_s)
    (call $drawCircle) ;; Call function Circle
    ;; == If Condition ==
    (global.get $var66)  ;; Global variable 'flag16'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 1)  ;; Literal value
        (global.set $var100)  ;; Set global var 'done'
        ;; Call function 'FillColor'
        (i32.const 0)  ;; String literal at memory position 0
        (call $setFillColor) ;; Call function FillColor
        ;; Call function 'LineColor'
        (i32.const 48)  ;; String literal at memory position 48
        (call $setStrokeColor) ;; Call function LineColor
        ;; Call function 'LineWidth'
        (i32.const 5)  ;; Literal value
        (call $setLineWidth) ;; Call function LineWidth
        ;; Call function 'Rect'
        (i32.const 180)  ;; Literal value
        (i32.const 30)  ;; Literal value
        (i32.const 240)  ;; Literal value
        (i32.const 60)  ;; Literal value
        (call $drawRect) ;; Call function Rect
        ;; Call function 'FillColor'
        (i32.const 63)  ;; String literal at memory position 63
        (call $setFillColor) ;; Call function FillColor
        ;; Call function 'Text'
        (i32.const 190)  ;; Literal value
        (i32.const 40)  ;; Literal value
        (i32.const 50)  ;; Literal value
        (i32.const 70)  ;; String literal at memory position 70
        (call $drawText) ;; Call function Text
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun18 (param $var117 f64) (result i32)
    (local $var118 i32) ;; Declare var 'old_x'
    (local $var119 i32) ;; Declare var 'old_y'
    ;; == If Condition ==
    (global.get $var100)  ;; Global variable 'done'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (global.get $var30)  ;; Global variable 'item1_x'
    (local.set $var118)  ;; Set var 'old_x'
    ;; Calculate RHS for assignment.
    (global.get $var31)  ;; Global variable 'item1_y'
    (local.set $var119)  ;; Set var 'old_y'
    ;; == If Condition ==
    (global.get $var30)  ;; Global variable 'item1_x'
    (global.get $var26)  ;; Global variable 'player_x'
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var30)  ;; Global variable 'item1_x'
        (i32.const 2)  ;; Literal value
        (i32.add)
        (global.set $var30)  ;; Set global var 'item1_x'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; Calculate RHS for assignment.
        (global.get $var30)  ;; Global variable 'item1_x'
        (i32.const 2)  ;; Literal value
        (i32.sub)
        (global.set $var30)  ;; Set global var 'item1_x'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var31)  ;; Global variable 'item1_y'
    (global.get $var27)  ;; Global variable 'player_y'
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var31)  ;; Global variable 'item1_y'
        (i32.const 2)  ;; Literal value
        (i32.add)
        (global.set $var31)  ;; Set global var 'item1_y'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; Calculate RHS for assignment.
        (global.get $var31)  ;; Global variable 'item1_y'
        (i32.const 2)  ;; Literal value
        (i32.sub)
        (global.set $var31)  ;; Set global var 'item1_y'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    ;; Call function 'TestCollide'
    (global.get $var26)  ;; Global variable 'player_x'
    (global.get $var27)  ;; Global variable 'player_y'
    (global.get $var28)  ;; Global variable 'player_size'
    (global.get $var30)  ;; Global variable 'item1_x'
    (global.get $var31)  ;; Global variable 'item1_y'
    (global.get $var32)  ;; Global variable 'item1_size'
    (call $Fun16)  ;; Call 'TestCollide'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Reset'
        (call $Fun14)  ;; Call 'Reset'
        (drop) ;; Result not used.
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    ;; Call function 'TestCollide'
    (global.get $var46)  ;; Global variable 'shield_x'
    (global.get $var47)  ;; Global variable 'shield_y'
    (global.get $var48)  ;; Global variable 'shield_size'
    (global.get $var30)  ;; Global variable 'item1_x'
    (global.get $var31)  ;; Global variable 'item1_y'
    (global.get $var32)  ;; Global variable 'item1_size'
    (call $Fun16)  ;; Call 'TestCollide'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (local.get $var118)  ;; Variable 'old_x'
        (global.set $var30)  ;; Set global var 'item1_x'
        ;; Calculate RHS for assignment.
        (local.get $var119)  ;; Variable 'old_y'
        (global.set $var31)  ;; Set global var 'item1_y'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (global.get $var34)  ;; Global variable 'item2_x'
    (local.set $var118)  ;; Set var 'old_x'
    ;; Calculate RHS for assignment.
    (global.get $var35)  ;; Global variable 'item2_y'
    (local.set $var119)  ;; Set var 'old_y'
    ;; == If Condition ==
    (global.get $var34)  ;; Global variable 'item2_x'
    (global.get $var26)  ;; Global variable 'player_x'
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var34)  ;; Global variable 'item2_x'
        (i32.const 3)  ;; Literal value
        (i32.add)
        (global.set $var34)  ;; Set global var 'item2_x'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; Calculate RHS for assignment.
        (global.get $var34)  ;; Global variable 'item2_x'
        (i32.const 3)  ;; Literal value
        (i32.sub)
        (global.set $var34)  ;; Set global var 'item2_x'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var35)  ;; Global variable 'item2_y'
    (global.get $var27)  ;; Global variable 'player_y'
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var35)  ;; Global variable 'item2_y'
        (i32.const 3)  ;; Literal value
        (i32.add)
        (global.set $var35)  ;; Set global var 'item2_y'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; Calculate RHS for assignment.
        (global.get $var35)  ;; Global variable 'item2_y'
        (i32.const 3)  ;; Literal value
        (i32.sub)
        (global.set $var35)  ;; Set global var 'item2_y'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    ;; Call function 'TestCollide'
    (global.get $var26)  ;; Global variable 'player_x'
    (global.get $var27)  ;; Global variable 'player_y'
    (global.get $var28)  ;; Global variable 'player_size'
    (global.get $var34)  ;; Global variable 'item2_x'
    (global.get $var35)  ;; Global variable 'item2_y'
    (global.get $var36)  ;; Global variable 'item2_size'
    (call $Fun16)  ;; Call 'TestCollide'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Reset'
        (call $Fun14)  ;; Call 'Reset'
        (drop) ;; Result not used.
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    ;; Call function 'TestCollide'
    (global.get $var46)  ;; Global variable 'shield_x'
    (global.get $var47)  ;; Global variable 'shield_y'
    (global.get $var48)  ;; Global variable 'shield_size'
    (global.get $var34)  ;; Global variable 'item2_x'
    (global.get $var35)  ;; Global variable 'item2_y'
    (global.get $var36)  ;; Global variable 'item2_size'
    (call $Fun16)  ;; Call 'TestCollide'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (local.get $var118)  ;; Variable 'old_x'
        (global.set $var34)  ;; Set global var 'item2_x'
        ;; Calculate RHS for assignment.
        (local.get $var119)  ;; Variable 'old_y'
        (global.set $var35)  ;; Set global var 'item2_y'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (global.get $var38)  ;; Global variable 'item3_x'
    (local.set $var118)  ;; Set var 'old_x'
    ;; Calculate RHS for assignment.
    (global.get $var39)  ;; Global variable 'item3_y'
    (local.set $var119)  ;; Set var 'old_y'
    ;; == If Condition ==
    (global.get $var38)  ;; Global variable 'item3_x'
    (global.get $var26)  ;; Global variable 'player_x'
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var38)  ;; Global variable 'item3_x'
        (i32.const 4)  ;; Literal value
        (i32.add)
        (global.set $var38)  ;; Set global var 'item3_x'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; Calculate RHS for assignment.
        (global.get $var38)  ;; Global variable 'item3_x'
        (i32.const 4)  ;; Literal value
        (i32.sub)
        (global.set $var38)  ;; Set global var 'item3_x'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var39)  ;; Global variable 'item3_y'
    (global.get $var27)  ;; Global variable 'player_y'
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var39)  ;; Global variable 'item3_y'
        (i32.const 4)  ;; Literal value
        (i32.add)
        (global.set $var39)  ;; Set global var 'item3_y'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; Calculate RHS for assignment.
        (global.get $var39)  ;; Global variable 'item3_y'
        (i32.const 4)  ;; Literal value
        (i32.sub)
        (global.set $var39)  ;; Set global var 'item3_y'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    ;; Call function 'TestCollide'
    (global.get $var26)  ;; Global variable 'player_x'
    (global.get $var27)  ;; Global variable 'player_y'
    (global.get $var28)  ;; Global variable 'player_size'
    (global.get $var38)  ;; Global variable 'item3_x'
    (global.get $var39)  ;; Global variable 'item3_y'
    (global.get $var40)  ;; Global variable 'item3_size'
    (call $Fun16)  ;; Call 'TestCollide'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Reset'
        (call $Fun14)  ;; Call 'Reset'
        (drop) ;; Result not used.
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    ;; Call function 'TestCollide'
    (global.get $var46)  ;; Global variable 'shield_x'
    (global.get $var47)  ;; Global variable 'shield_y'
    (global.get $var48)  ;; Global variable 'shield_size'
    (global.get $var38)  ;; Global variable 'item3_x'
    (global.get $var39)  ;; Global variable 'item3_y'
    (global.get $var40)  ;; Global variable 'item3_size'
    (call $Fun16)  ;; Call 'TestCollide'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (local.get $var118)  ;; Variable 'old_x'
        (global.set $var38)  ;; Set global var 'item3_x'
        ;; Calculate RHS for assignment.
        (local.get $var119)  ;; Variable 'old_y'
        (global.set $var39)  ;; Set global var 'item3_y'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (global.get $var42)  ;; Global variable 'item4_x'
    (local.set $var118)  ;; Set var 'old_x'
    ;; Calculate RHS for assignment.
    (global.get $var43)  ;; Global variable 'item4_y'
    (local.set $var119)  ;; Set var 'old_y'
    ;; == If Condition ==
    (global.get $var42)  ;; Global variable 'item4_x'
    (global.get $var26)  ;; Global variable 'player_x'
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var42)  ;; Global variable 'item4_x'
        (i32.const 5)  ;; Literal value
        (i32.add)
        (global.set $var42)  ;; Set global var 'item4_x'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; Calculate RHS for assignment.
        (global.get $var42)  ;; Global variable 'item4_x'
        (i32.const 5)  ;; Literal value
        (i32.sub)
        (global.set $var42)  ;; Set global var 'item4_x'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var43)  ;; Global variable 'item4_y'
    (global.get $var27)  ;; Global variable 'player_y'
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var43)  ;; Global variable 'item4_y'
        (i32.const 5)  ;; Literal value
        (i32.add)
        (global.set $var43)  ;; Set global var 'item4_y'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; Calculate RHS for assignment.
        (global.get $var43)  ;; Global variable 'item4_y'
        (i32.const 5)  ;; Literal value
        (i32.sub)
        (global.set $var43)  ;; Set global var 'item4_y'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    ;; Call function 'TestCollide'
    (global.get $var26)  ;; Global variable 'player_x'
    (global.get $var27)  ;; Global variable 'player_y'
    (global.get $var28)  ;; Global variable 'player_size'
    (global.get $var42)  ;; Global variable 'item4_x'
    (global.get $var43)  ;; Global variable 'item4_y'
    (global.get $var44)  ;; Global variable 'item4_size'
    (call $Fun16)  ;; Call 'TestCollide'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'Reset'
        (call $Fun14)  ;; Call 'Reset'
        (drop) ;; Result not used.
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    ;; Call function 'TestCollide'
    (global.get $var46)  ;; Global variable 'shield_x'
    (global.get $var47)  ;; Global variable 'shield_y'
    (global.get $var48)  ;; Global variable 'shield_size'
    (global.get $var42)  ;; Global variable 'item4_x'
    (global.get $var43)  ;; Global variable 'item4_y'
    (global.get $var44)  ;; Global variable 'item4_size'
    (call $Fun16)  ;; Call 'TestCollide'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (local.get $var118)  ;; Variable 'old_x'
        (global.set $var42)  ;; Set global var 'item4_x'
        ;; Calculate RHS for assignment.
        (local.get $var119)  ;; Variable 'old_y'
        (global.set $var43)  ;; Set global var 'item4_y'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (global.get $var26)  ;; Global variable 'player_x'
    (global.get $var49)  ;; Global variable 'vel_x'
    (i32.add)
    (global.set $var26)  ;; Set global var 'player_x'
    ;; == If Condition ==
    (global.get $var26)  ;; Global variable 'player_x'
    (i32.const 0)  ;; Literal value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (global.set $var26)  ;; Set global var 'player_x'
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (global.set $var49)  ;; Set global var 'vel_x'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var26)  ;; Global variable 'player_x'
    (i32.const 6000)  ;; Literal value
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 6000)  ;; Literal value
        (global.set $var26)  ;; Set global var 'player_x'
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (global.set $var49)  ;; Set global var 'vel_x'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (global.get $var27)  ;; Global variable 'player_y'
    (global.get $var50)  ;; Global variable 'vel_y'
    (i32.add)
    (global.set $var27)  ;; Set global var 'player_y'
    ;; == If Condition ==
    (global.get $var27)  ;; Global variable 'player_y'
    (i32.const 0)  ;; Literal value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (global.set $var27)  ;; Set global var 'player_y'
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (global.set $var50)  ;; Set global var 'vel_y'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var27)  ;; Global variable 'player_y'
    (i32.const 6000)  ;; Literal value
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 6000)  ;; Literal value
        (global.set $var27)  ;; Set global var 'player_y'
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (global.set $var50)  ;; Set global var 'vel_y'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var51)  ;; Global variable 'flag1'
    (i32.eqz)  ;; Do operator '!'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == If Condition ==
        ;; Call function 'TestCollide'
        (global.get $var26)  ;; Global variable 'player_x'
        (global.get $var27)  ;; Global variable 'player_y'
        (global.get $var28)  ;; Global variable 'player_size'
        (global.get $var67)  ;; Global variable 'flag1_x'
        (global.get $var68)  ;; Global variable 'flag1_y'
        (global.get $var99)  ;; Global variable 'flag_size'
        (call $Fun16)  ;; Call 'TestCollide'
        (if ;; Execute code based on result of condition.
          (then ;; 'then' block
            ;; Calculate RHS for assignment.
            (i32.const 1)  ;; Literal value
            (global.set $var51)  ;; Set global var 'flag1'
          ) ;; End 'then'
        ) ;; End 'if'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; == If Condition ==
        (global.get $var52)  ;; Global variable 'flag2'
        (i32.eqz)  ;; Do operator '!'
        (if ;; Execute code based on result of condition.
          (then ;; 'then' block
            ;; == If Condition ==
            ;; Call function 'TestCollide'
            (global.get $var26)  ;; Global variable 'player_x'
            (global.get $var27)  ;; Global variable 'player_y'
            (global.get $var28)  ;; Global variable 'player_size'
            (global.get $var69)  ;; Global variable 'flag2_x'
            (global.get $var70)  ;; Global variable 'flag2_y'
            (global.get $var99)  ;; Global variable 'flag_size'
            (call $Fun16)  ;; Call 'TestCollide'
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; Calculate RHS for assignment.
                (i32.const 1)  ;; Literal value
                (global.set $var52)  ;; Set global var 'flag2'
              ) ;; End 'then'
            ) ;; End 'if'
          ) ;; End 'then'
          (else ;; 'else' block
            ;; == If Condition ==
            (global.get $var53)  ;; Global variable 'flag3'
            (i32.eqz)  ;; Do operator '!'
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; == If Condition ==
                ;; Call function 'TestCollide'
                (global.get $var26)  ;; Global variable 'player_x'
                (global.get $var27)  ;; Global variable 'player_y'
                (global.get $var28)  ;; Global variable 'player_size'
                (global.get $var71)  ;; Global variable 'flag3_x'
                (global.get $var72)  ;; Global variable 'flag3_y'
                (global.get $var99)  ;; Global variable 'flag_size'
                (call $Fun16)  ;; Call 'TestCollide'
                (if ;; Execute code based on result of condition.
                  (then ;; 'then' block
                    ;; Calculate RHS for assignment.
                    (i32.const 1)  ;; Literal value
                    (global.set $var53)  ;; Set global var 'flag3'
                  ) ;; End 'then'
                ) ;; End 'if'
              ) ;; End 'then'
              (else ;; 'else' block
                ;; == If Condition ==
                (global.get $var54)  ;; Global variable 'flag4'
                (i32.eqz)  ;; Do operator '!'
                (if ;; Execute code based on result of condition.
                  (then ;; 'then' block
                    ;; == If Condition ==
                    ;; Call function 'TestCollide'
                    (global.get $var26)  ;; Global variable 'player_x'
                    (global.get $var27)  ;; Global variable 'player_y'
                    (global.get $var28)  ;; Global variable 'player_size'
                    (global.get $var73)  ;; Global variable 'flag4_x'
                    (global.get $var74)  ;; Global variable 'flag4_y'
                    (global.get $var99)  ;; Global variable 'flag_size'
                    (call $Fun16)  ;; Call 'TestCollide'
                    (if ;; Execute code based on result of condition.
                      (then ;; 'then' block
                        ;; Calculate RHS for assignment.
                        (i32.const 1)  ;; Literal value
                        (global.set $var54)  ;; Set global var 'flag4'
                      ) ;; End 'then'
                    ) ;; End 'if'
                  ) ;; End 'then'
                  (else ;; 'else' block
                    ;; == If Condition ==
                    (global.get $var55)  ;; Global variable 'flag5'
                    (i32.eqz)  ;; Do operator '!'
                    (if ;; Execute code based on result of condition.
                      (then ;; 'then' block
                        ;; == If Condition ==
                        ;; Call function 'TestCollide'
                        (global.get $var26)  ;; Global variable 'player_x'
                        (global.get $var27)  ;; Global variable 'player_y'
                        (global.get $var28)  ;; Global variable 'player_size'
                        (global.get $var75)  ;; Global variable 'flag5_x'
                        (global.get $var76)  ;; Global variable 'flag5_y'
                        (global.get $var99)  ;; Global variable 'flag_size'
                        (call $Fun16)  ;; Call 'TestCollide'
                        (if ;; Execute code based on result of condition.
                          (then ;; 'then' block
                            ;; Calculate RHS for assignment.
                            (i32.const 1)  ;; Literal value
                            (global.set $var55)  ;; Set global var 'flag5'
                          ) ;; End 'then'
                        ) ;; End 'if'
                      ) ;; End 'then'
                      (else ;; 'else' block
                        ;; == If Condition ==
                        (global.get $var56)  ;; Global variable 'flag6'
                        (i32.eqz)  ;; Do operator '!'
                        (if ;; Execute code based on result of condition.
                          (then ;; 'then' block
                            ;; == If Condition ==
                            ;; Call function 'TestCollide'
                            (global.get $var26)  ;; Global variable 'player_x'
                            (global.get $var27)  ;; Global variable 'player_y'
                            (global.get $var28)  ;; Global variable 'player_size'
                            (global.get $var77)  ;; Global variable 'flag6_x'
                            (global.get $var78)  ;; Global variable 'flag6_y'
                            (global.get $var99)  ;; Global variable 'flag_size'
                            (call $Fun16)  ;; Call 'TestCollide'
                            (if ;; Execute code based on result of condition.
                              (then ;; 'then' block
                                ;; Calculate RHS for assignment.
                                (i32.const 1)  ;; Literal value
                                (global.set $var56)  ;; Set global var 'flag6'
                              ) ;; End 'then'
                            ) ;; End 'if'
                          ) ;; End 'then'
                          (else ;; 'else' block
                            ;; == If Condition ==
                            (global.get $var57)  ;; Global variable 'flag7'
                            (i32.eqz)  ;; Do operator '!'
                            (if ;; Execute code based on result of condition.
                              (then ;; 'then' block
                                ;; == If Condition ==
                                ;; Call function 'TestCollide'
                                (global.get $var26)  ;; Global variable 'player_x'
                                (global.get $var27)  ;; Global variable 'player_y'
                                (global.get $var28)  ;; Global variable 'player_size'
                                (global.get $var79)  ;; Global variable 'flag7_x'
                                (global.get $var80)  ;; Global variable 'flag7_y'
                                (global.get $var99)  ;; Global variable 'flag_size'
                                (call $Fun16)  ;; Call 'TestCollide'
                                (if ;; Execute code based on result of condition.
                                  (then ;; 'then' block
                                    ;; Calculate RHS for assignment.
                                    (i32.const 1)  ;; Literal value
                                    (global.set $var57)  ;; Set global var 'flag7'
                                  ) ;; End 'then'
                                ) ;; End 'if'
                              ) ;; End 'then'
                              (else ;; 'else' block
                                ;; == If Condition ==
                                (global.get $var58)  ;; Global variable 'flag8'
                                (i32.eqz)  ;; Do operator '!'
                                (if ;; Execute code based on result of condition.
                                  (then ;; 'then' block
                                    ;; == If Condition ==
                                    ;; Call function 'TestCollide'
                                    (global.get $var26)  ;; Global variable 'player_x'
                                    (global.get $var27)  ;; Global variable 'player_y'
                                    (global.get $var28)  ;; Global variable 'player_size'
                                    (global.get $var81)  ;; Global variable 'flag8_x'
                                    (global.get $var82)  ;; Global variable 'flag8_y'
                                    (global.get $var99)  ;; Global variable 'flag_size'
                                    (call $Fun16)  ;; Call 'TestCollide'
                                    (if ;; Execute code based on result of condition.
                                      (then ;; 'then' block
                                        ;; Calculate RHS for assignment.
                                        (i32.const 1)  ;; Literal value
                                        (global.set $var58)  ;; Set global var 'flag8'
                                      ) ;; End 'then'
                                    ) ;; End 'if'
                                  ) ;; End 'then'
                                  (else ;; 'else' block
                                    ;; == If Condition ==
                                    (global.get $var59)  ;; Global variable 'flag9'
                                    (i32.eqz)  ;; Do operator '!'
                                    (if ;; Execute code based on result of condition.
                                      (then ;; 'then' block
                                        ;; == If Condition ==
                                        ;; Call function 'TestCollide'
                                        (global.get $var26)  ;; Global variable 'player_x'
                                        (global.get $var27)  ;; Global variable 'player_y'
                                        (global.get $var28)  ;; Global variable 'player_size'
                                        (global.get $var83)  ;; Global variable 'flag9_x'
                                        (global.get $var84)  ;; Global variable 'flag9_y'
                                        (global.get $var99)  ;; Global variable 'flag_size'
                                        (call $Fun16)  ;; Call 'TestCollide'
                                        (if ;; Execute code based on result of condition.
                                          (then ;; 'then' block
                                            ;; Calculate RHS for assignment.
                                            (i32.const 1)  ;; Literal value
                                            (global.set $var59)  ;; Set global var 'flag9'
                                          ) ;; End 'then'
                                        ) ;; End 'if'
                                      ) ;; End 'then'
                                      (else ;; 'else' block
                                        ;; == If Condition ==
                                        (global.get $var60)  ;; Global variable 'flag10'
                                        (i32.eqz)  ;; Do operator '!'
                                        (if ;; Execute code based on result of condition.
                                          (then ;; 'then' block
                                            ;; == If Condition ==
                                            ;; Call function 'TestCollide'
                                            (global.get $var26)  ;; Global variable 'player_x'
                                            (global.get $var27)  ;; Global variable 'player_y'
                                            (global.get $var28)  ;; Global variable 'player_size'
                                            (global.get $var85)  ;; Global variable 'flag10_x'
                                            (global.get $var86)  ;; Global variable 'flag10_y'
                                            (global.get $var99)  ;; Global variable 'flag_size'
                                            (call $Fun16)  ;; Call 'TestCollide'
                                            (if ;; Execute code based on result of condition.
                                              (then ;; 'then' block
                                                ;; Calculate RHS for assignment.
                                                (i32.const 1)  ;; Literal value
                                                (global.set $var60)  ;; Set global var 'flag10'
                                              ) ;; End 'then'
                                            ) ;; End 'if'
                                          ) ;; End 'then'
                                          (else ;; 'else' block
                                            ;; == If Condition ==
                                            (global.get $var61)  ;; Global variable 'flag11'
                                            (i32.eqz)  ;; Do operator '!'
                                            (if ;; Execute code based on result of condition.
                                              (then ;; 'then' block
                                                ;; == If Condition ==
                                                ;; Call function 'TestCollide'
                                                (global.get $var26)  ;; Global variable 'player_x'
                                                (global.get $var27)  ;; Global variable 'player_y'
                                                (global.get $var28)  ;; Global variable 'player_size'
                                                (global.get $var87)  ;; Global variable 'flag11_x'
                                                (global.get $var88)  ;; Global variable 'flag11_y'
                                                (global.get $var99)  ;; Global variable 'flag_size'
                                                (call $Fun16)  ;; Call 'TestCollide'
                                                (if ;; Execute code based on result of condition.
                                                  (then ;; 'then' block
                                                    ;; Calculate RHS for assignment.
                                                    (i32.const 1)  ;; Literal value
                                                    (global.set $var61)  ;; Set global var 'flag11'
                                                  ) ;; End 'then'
                                                ) ;; End 'if'
                                              ) ;; End 'then'
                                              (else ;; 'else' block
                                                ;; == If Condition ==
                                                (global.get $var62)  ;; Global variable 'flag12'
                                                (i32.eqz)  ;; Do operator '!'
                                                (if ;; Execute code based on result of condition.
                                                  (then ;; 'then' block
                                                    ;; == If Condition ==
                                                    ;; Call function 'TestCollide'
                                                    (global.get $var26)  ;; Global variable 'player_x'
                                                    (global.get $var27)  ;; Global variable 'player_y'
                                                    (global.get $var28)  ;; Global variable 'player_size'
                                                    (global.get $var89)  ;; Global variable 'flag12_x'
                                                    (global.get $var90)  ;; Global variable 'flag12_y'
                                                    (global.get $var99)  ;; Global variable 'flag_size'
                                                    (call $Fun16)  ;; Call 'TestCollide'
                                                    (if ;; Execute code based on result of condition.
                                                      (then ;; 'then' block
                                                        ;; Calculate RHS for assignment.
                                                        (i32.const 1)  ;; Literal value
                                                        (global.set $var62)  ;; Set global var 'flag12'
                                                      ) ;; End 'then'
                                                    ) ;; End 'if'
                                                  ) ;; End 'then'
                                                  (else ;; 'else' block
                                                    ;; == If Condition ==
                                                    (global.get $var63)  ;; Global variable 'flag13'
                                                    (i32.eqz)  ;; Do operator '!'
                                                    (if ;; Execute code based on result of condition.
                                                      (then ;; 'then' block
                                                        ;; == If Condition ==
                                                        ;; Call function 'TestCollide'
                                                        (global.get $var26)  ;; Global variable 'player_x'
                                                        (global.get $var27)  ;; Global variable 'player_y'
                                                        (global.get $var28)  ;; Global variable 'player_size'
                                                        (global.get $var91)  ;; Global variable 'flag13_x'
                                                        (global.get $var92)  ;; Global variable 'flag13_y'
                                                        (global.get $var99)  ;; Global variable 'flag_size'
                                                        (call $Fun16)  ;; Call 'TestCollide'
                                                        (if ;; Execute code based on result of condition.
                                                          (then ;; 'then' block
                                                            ;; Calculate RHS for assignment.
                                                            (i32.const 1)  ;; Literal value
                                                            (global.set $var63)  ;; Set global var 'flag13'
                                                          ) ;; End 'then'
                                                        ) ;; End 'if'
                                                      ) ;; End 'then'
                                                      (else ;; 'else' block
                                                        ;; == If Condition ==
                                                        (global.get $var64)  ;; Global variable 'flag14'
                                                        (i32.eqz)  ;; Do operator '!'
                                                        (if ;; Execute code based on result of condition.
                                                          (then ;; 'then' block
                                                            ;; == If Condition ==
                                                            ;; Call function 'TestCollide'
                                                            (global.get $var26)  ;; Global variable 'player_x'
                                                            (global.get $var27)  ;; Global variable 'player_y'
                                                            (global.get $var28)  ;; Global variable 'player_size'
                                                            (global.get $var93)  ;; Global variable 'flag14_x'
                                                            (global.get $var94)  ;; Global variable 'flag14_y'
                                                            (global.get $var99)  ;; Global variable 'flag_size'
                                                            (call $Fun16)  ;; Call 'TestCollide'
                                                            (if ;; Execute code based on result of condition.
                                                              (then ;; 'then' block
                                                                ;; Calculate RHS for assignment.
                                                                (i32.const 1)  ;; Literal value
                                                                (global.set $var64)  ;; Set global var 'flag14'
                                                              ) ;; End 'then'
                                                            ) ;; End 'if'
                                                          ) ;; End 'then'
                                                          (else ;; 'else' block
                                                            ;; == If Condition ==
                                                            (global.get $var65)  ;; Global variable 'flag15'
                                                            (i32.eqz)  ;; Do operator '!'
                                                            (if ;; Execute code based on result of condition.
                                                              (then ;; 'then' block
                                                                ;; == If Condition ==
                                                                ;; Call function 'TestCollide'
                                                                (global.get $var26)  ;; Global variable 'player_x'
                                                                (global.get $var27)  ;; Global variable 'player_y'
                                                                (global.get $var28)  ;; Global variable 'player_size'
                                                                (global.get $var95)  ;; Global variable 'flag15_x'
                                                                (global.get $var96)  ;; Global variable 'flag15_y'
                                                                (global.get $var99)  ;; Global variable 'flag_size'
                                                                (call $Fun16)  ;; Call 'TestCollide'
                                                                (if ;; Execute code based on result of condition.
                                                                  (then ;; 'then' block
                                                                    ;; Calculate RHS for assignment.
                                                                    (i32.const 1)  ;; Literal value
                                                                    (global.set $var65)  ;; Set global var 'flag15'
                                                                  ) ;; End 'then'
                                                                ) ;; End 'if'
                                                              ) ;; End 'then'
                                                              (else ;; 'else' block
                                                                ;; == If Condition ==
                                                                (global.get $var66)  ;; Global variable 'flag16'
                                                                (i32.eqz)  ;; Do operator '!'
                                                                (if ;; Execute code based on result of condition.
                                                                  (then ;; 'then' block
                                                                    ;; == If Condition ==
                                                                    ;; Call function 'TestCollide'
                                                                    (global.get $var26)  ;; Global variable 'player_x'
                                                                    (global.get $var27)  ;; Global variable 'player_y'
                                                                    (global.get $var28)  ;; Global variable 'player_size'
                                                                    (global.get $var97)  ;; Global variable 'flag16_x'
                                                                    (global.get $var98)  ;; Global variable 'flag16_y'
                                                                    (global.get $var99)  ;; Global variable 'flag_size'
                                                                    (call $Fun16)  ;; Call 'TestCollide'
                                                                    (if ;; Execute code based on result of condition.
                                                                      (then ;; 'then' block
                                                                        ;; Calculate RHS for assignment.
                                                                        (i32.const 1)  ;; Literal value
                                                                        (global.set $var66)  ;; Set global var 'flag16'
                                                                      ) ;; End 'then'
                                                                    ) ;; End 'if'
                                                                  ) ;; End 'then'
                                                                ) ;; End 'if'
                                                              ) ;; End 'else'
                                                            ) ;; End 'if'
                                                          ) ;; End 'else'
                                                        ) ;; End 'if'
                                                      ) ;; End 'else'
                                                    ) ;; End 'if'
                                                  ) ;; End 'else'
                                                ) ;; End 'if'
                                              ) ;; End 'else'
                                            ) ;; End 'if'
                                          ) ;; End 'else'
                                        ) ;; End 'if'
                                      ) ;; End 'else'
                                    ) ;; End 'if'
                                  ) ;; End 'else'
                                ) ;; End 'if'
                              ) ;; End 'else'
                            ) ;; End 'if'
                          ) ;; End 'else'
                        ) ;; End 'if'
                      ) ;; End 'else'
                    ) ;; End 'if'
                  ) ;; End 'else'
                ) ;; End 'if'
              ) ;; End 'else'
            ) ;; End 'if'
          ) ;; End 'else'
        ) ;; End 'if'
      ) ;; End 'else'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var48)  ;; Global variable 'shield_size'
    (i32.const 0)  ;; Literal value
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var48)  ;; Global variable 'shield_size'
        (i32.const 1)  ;; Literal value
        (i32.sub)
        (global.set $var48)  ;; Set global var 'shield_size'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Call function 'DrawBoard'
    (call $Fun17)  ;; Call 'DrawBoard'
    (drop) ;; Result not used.
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun19 (result i32)
    ;; Calculate RHS for assignment.
    (global.get $var50)  ;; Global variable 'vel_y'
    (global.get $var29)  ;; Global variable 'player_accel'
    (i32.sub)
    (global.set $var50)  ;; Set global var 'vel_y'
    ;; == If Condition ==
    (global.get $var50)  ;; Global variable 'vel_y'
    (i32.const 0)       ;; Setup negation
    (global.get $var29)  ;; Global variable 'player_accel'
    (i32.sub)           ;; Negate value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 0)       ;; Setup negation
        (global.get $var29)  ;; Global variable 'player_accel'
        (i32.sub)           ;; Negate value
        (global.set $var50)  ;; Set global var 'vel_y'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun20 (result i32)
    ;; Calculate RHS for assignment.
    (global.get $var50)  ;; Global variable 'vel_y'
    (global.get $var29)  ;; Global variable 'player_accel'
    (i32.add)
    (global.set $var50)  ;; Set global var 'vel_y'
    ;; == If Condition ==
    (global.get $var50)  ;; Global variable 'vel_y'
    (global.get $var29)  ;; Global variable 'player_accel'
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var29)  ;; Global variable 'player_accel'
        (global.set $var50)  ;; Set global var 'vel_y'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun21 (result i32)
    ;; Calculate RHS for assignment.
    (global.get $var49)  ;; Global variable 'vel_x'
    (global.get $var29)  ;; Global variable 'player_accel'
    (i32.sub)
    (global.set $var49)  ;; Set global var 'vel_x'
    ;; == If Condition ==
    (global.get $var49)  ;; Global variable 'vel_x'
    (i32.const 0)       ;; Setup negation
    (global.get $var29)  ;; Global variable 'player_accel'
    (i32.sub)           ;; Negate value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 0)       ;; Setup negation
        (global.get $var29)  ;; Global variable 'player_accel'
        (i32.sub)           ;; Negate value
        (global.set $var49)  ;; Set global var 'vel_x'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun22 (result i32)
    ;; Calculate RHS for assignment.
    (global.get $var49)  ;; Global variable 'vel_x'
    (global.get $var29)  ;; Global variable 'player_accel'
    (i32.add)
    (global.set $var49)  ;; Set global var 'vel_x'
    ;; == If Condition ==
    (global.get $var49)  ;; Global variable 'vel_x'
    (global.get $var29)  ;; Global variable 'player_accel'
    (i32.gt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (global.get $var29)  ;; Global variable 'player_accel'
        (global.set $var49)  ;; Set global var 'vel_x'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun23 (result i32)
    ;; Call function 'SetTitle'
    (i32.const 79)  ;; String literal at memory position 79
    (call $setTitle) ;; Call function SetTitle
    ;; Call function 'Reset'
    (call $Fun14)  ;; Call 'Reset'
    (drop) ;; Result not used.
    ;; Call function 'DrawBoard'
    (call $Fun17)  ;; Call 'DrawBoard'
    (drop) ;; Result not used.
    ;; Call function 'AddKeypress'
    (i32.const 106)  ;; String literal at memory position 106
    (i32.const 108)  ;; String literal at memory position 108
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 123)  ;; String literal at memory position 123
    (i32.const 131)  ;; String literal at memory position 131
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 137)  ;; String literal at memory position 137
    (i32.const 147)  ;; String literal at memory position 147
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 155)  ;; String literal at memory position 155
    (i32.const 165)  ;; String literal at memory position 165
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 173)  ;; String literal at memory position 173
    (i32.const 184)  ;; String literal at memory position 184
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddAnimFun'
    (i32.const 193)  ;; String literal at memory position 193
    (call $addAnimFun) ;; Call function AddAnimFun
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )

  (func $Init
    ;; Initialize global 'player_x'
    (i32.const 0)  ;; Literal value
    (global.set $var26)
    ;; Initialize global 'player_y'
    (i32.const 0)  ;; Literal value
    (global.set $var27)
    ;; Initialize global 'player_size'
    (i32.const 100)  ;; Literal value
    (global.set $var28)
    ;; Initialize global 'player_accel'
    (i32.const 10)  ;; Literal value
    (global.set $var29)
    ;; Initialize global 'item1_x'
    (i32.const 0)  ;; Literal value
    (global.set $var30)
    ;; Initialize global 'item1_y'
    (i32.const 0)  ;; Literal value
    (global.set $var31)
    ;; Initialize global 'item1_size'
    (i32.const 80)  ;; Literal value
    (global.set $var32)
    ;; Initialize global 'item1_accel'
    (i32.const 2)  ;; Literal value
    (global.set $var33)
    ;; Initialize global 'item2_x'
    (i32.const 0)  ;; Literal value
    (global.set $var34)
    ;; Initialize global 'item2_y'
    (i32.const 0)  ;; Literal value
    (global.set $var35)
    ;; Initialize global 'item2_size'
    (i32.const 70)  ;; Literal value
    (global.set $var36)
    ;; Initialize global 'item2_accel'
    (i32.const 3)  ;; Literal value
    (global.set $var37)
    ;; Initialize global 'item3_x'
    (i32.const 0)  ;; Literal value
    (global.set $var38)
    ;; Initialize global 'item3_y'
    (i32.const 0)  ;; Literal value
    (global.set $var39)
    ;; Initialize global 'item3_size'
    (i32.const 60)  ;; Literal value
    (global.set $var40)
    ;; Initialize global 'item3_accel'
    (i32.const 4)  ;; Literal value
    (global.set $var41)
    ;; Initialize global 'item4_x'
    (i32.const 0)  ;; Literal value
    (global.set $var42)
    ;; Initialize global 'item4_y'
    (i32.const 0)  ;; Literal value
    (global.set $var43)
    ;; Initialize global 'item4_size'
    (i32.const 50)  ;; Literal value
    (global.set $var44)
    ;; Initialize global 'item4_accel'
    (i32.const 5)  ;; Literal value
    (global.set $var45)
    ;; Initialize global 'shield_x'
    (i32.const 0)  ;; Literal value
    (global.set $var46)
    ;; Initialize global 'shield_y'
    (i32.const 0)  ;; Literal value
    (global.set $var47)
    ;; Initialize global 'shield_size'
    (i32.const 0)  ;; Literal value
    (global.set $var48)
    ;; Initialize global 'vel_x'
    (i32.const 0)  ;; Literal value
    (global.set $var49)
    ;; Initialize global 'vel_y'
    (i32.const 0)  ;; Literal value
    (global.set $var50)
    ;; Initialize global 'flag1'
    (i32.const 0)  ;; Literal value
    (global.set $var51)
    ;; Initialize global 'flag2'
    (i32.const 0)  ;; Literal value
    (global.set $var52)
    ;; Initialize global 'flag3'
    (i32.const 0)  ;; Literal value
    (global.set $var53)
    ;; Initialize global 'flag4'
    (i32.const 0)  ;; Literal value
    (global.set $var54)
    ;; Initialize global 'flag5'
    (i32.const 0)  ;; Literal value
    (global.set $var55)
    ;; Initialize global 'flag6'
    (i32.const 0)  ;; Literal value
    (global.set $var56)
    ;; Initialize global 'flag7'
    (i32.const 0)  ;; Literal value
    (global.set $var57)
    ;; Initialize global 'flag8'
    (i32.const 0)  ;; Literal value
    (global.set $var58)
    ;; Initialize global 'flag9'
    (i32.const 0)  ;; Literal value
    (global.set $var59)
    ;; Initialize global 'flag10'
    (i32.const 0)  ;; Literal value
    (global.set $var60)
    ;; Initialize global 'flag11'
    (i32.const 0)  ;; Literal value
    (global.set $var61)
    ;; Initialize global 'flag12'
    (i32.const 0)  ;; Literal value
    (global.set $var62)
    ;; Initialize global 'flag13'
    (i32.const 0)  ;; Literal value
    (global.set $var63)
    ;; Initialize global 'flag14'
    (i32.const 0)  ;; Literal value
    (global.set $var64)
    ;; Initialize global 'flag15'
    (i32.const 0)  ;; Literal value
    (global.set $var65)
    ;; Initialize global 'flag16'
    (i32.const 0)  ;; Literal value
    (global.set $var66)
    ;; Initialize global 'flag1_x'
    (i32.const 500)  ;; Literal value
    (global.set $var67)
    ;; Initialize global 'flag1_y'
    (i32.const 500)  ;; Literal value
    (global.set $var68)
    ;; Initialize global 'flag2_x'
    (i32.const 5500)  ;; Literal value
    (global.set $var69)
    ;; Initialize global 'flag2_y'
    (i32.const 5500)  ;; Literal value
    (global.set $var70)
    ;; Initialize global 'flag3_x'
    (i32.const 1750)  ;; Literal value
    (global.set $var71)
    ;; Initialize global 'flag3_y'
    (i32.const 500)  ;; Literal value
    (global.set $var72)
    ;; Initialize global 'flag4_x'
    (i32.const 4250)  ;; Literal value
    (global.set $var73)
    ;; Initialize global 'flag4_y'
    (i32.const 5500)  ;; Literal value
    (global.set $var74)
    ;; Initialize global 'flag5_x'
    (i32.const 3000)  ;; Literal value
    (global.set $var75)
    ;; Initialize global 'flag5_y'
    (i32.const 500)  ;; Literal value
    (global.set $var76)
    ;; Initialize global 'flag6_x'
    (i32.const 3000)  ;; Literal value
    (global.set $var77)
    ;; Initialize global 'flag6_y'
    (i32.const 5500)  ;; Literal value
    (global.set $var78)
    ;; Initialize global 'flag7_x'
    (i32.const 4250)  ;; Literal value
    (global.set $var79)
    ;; Initialize global 'flag7_y'
    (i32.const 500)  ;; Literal value
    (global.set $var80)
    ;; Initialize global 'flag8_x'
    (i32.const 1750)  ;; Literal value
    (global.set $var81)
    ;; Initialize global 'flag8_y'
    (i32.const 5500)  ;; Literal value
    (global.set $var82)
    ;; Initialize global 'flag9_x'
    (i32.const 5500)  ;; Literal value
    (global.set $var83)
    ;; Initialize global 'flag9_y'
    (i32.const 500)  ;; Literal value
    (global.set $var84)
    ;; Initialize global 'flag10_x'
    (i32.const 500)  ;; Literal value
    (global.set $var85)
    ;; Initialize global 'flag10_y'
    (i32.const 5500)  ;; Literal value
    (global.set $var86)
    ;; Initialize global 'flag11_x'
    (i32.const 5500)  ;; Literal value
    (global.set $var87)
    ;; Initialize global 'flag11_y'
    (i32.const 1750)  ;; Literal value
    (global.set $var88)
    ;; Initialize global 'flag12_x'
    (i32.const 500)  ;; Literal value
    (global.set $var89)
    ;; Initialize global 'flag12_y'
    (i32.const 4250)  ;; Literal value
    (global.set $var90)
    ;; Initialize global 'flag13_x'
    (i32.const 5500)  ;; Literal value
    (global.set $var91)
    ;; Initialize global 'flag13_y'
    (i32.const 3000)  ;; Literal value
    (global.set $var92)
    ;; Initialize global 'flag14_x'
    (i32.const 500)  ;; Literal value
    (global.set $var93)
    ;; Initialize global 'flag14_y'
    (i32.const 3000)  ;; Literal value
    (global.set $var94)
    ;; Initialize global 'flag15_x'
    (i32.const 5500)  ;; Literal value
    (global.set $var95)
    ;; Initialize global 'flag15_y'
    (i32.const 4250)  ;; Literal value
    (global.set $var96)
    ;; Initialize global 'flag16_x'
    (i32.const 500)  ;; Literal value
    (global.set $var97)
    ;; Initialize global 'flag16_y'
    (i32.const 1750)  ;; Literal value
    (global.set $var98)
    ;; Initialize global 'flag_size'
    (i32.const 10)  ;; Literal value
    (global.set $var99)
    ;; Initialize global 'done'
    (i32.const 0)  ;; Literal value
    (global.set $var100)
  )
  (start $Init)

  (export "ActivateShield" (func $Fun13))
  (export "Reset" (func $Fun14))
  (export "TestInRange" (func $Fun15))
  (export "TestCollide" (func $Fun16))
  (export "DrawBoard" (func $Fun17))
  (export "UpdateBoard" (func $Fun18))
  (export "KeyUp" (func $Fun19))
  (export "KeyDown" (func $Fun20))
  (export "KeyLeft" (func $Fun21))
  (export "KeyRight" (func $Fun22))
  (export "Main" (func $Fun23))
) ;; End module
