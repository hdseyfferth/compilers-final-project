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
  (global $free_mem (mut i32) (i32.const 1097))

  (global $var26 (mut i32) (i32.const 0))  ;; Global variable 'layout'
  (global $var27 (mut i32) (i32.const 0))  ;; Global variable 'num_rows'
  (global $var28 (mut i32) (i32.const 0))  ;; Global variable 'num_cols'
  (global $var29 (mut i32) (i32.const 0))  ;; Global variable 'player_row'
  (global $var30 (mut i32) (i32.const 0))  ;; Global variable 'player_col'
  (global $var31 (mut i32) (i32.const 0))  ;; Global variable 'lights'
  (global $var32 (mut i32) (i32.const 0))  ;; Global variable 'solved'
  (global $var33 (mut i32) (i32.const 0))  ;; Global variable 'cell_width'
  (global $var34 (mut i32) (i32.const 0))  ;; Global variable 'cell_height'

  (data (i32.const 0) "0\00")  ;; String literal
  (data (i32.const 2) "\00")  ;; String literal
  (data (i32.const 3) "-\00")  ;; String literal
  (data (i32.const 5) "black\00")  ;; String literal
  (data (i32.const 11) "blue\00")  ;; String literal
  (data (i32.const 16) "#303030\00")  ;; String literal
  (data (i32.const 24) "green\00")  ;; String literal
  (data (i32.const 30) "red\00")  ;; String literal
  (data (i32.const 34) "white\00")  ;; String literal
  (data (i32.const 40) "yellow\00")  ;; String literal
  (data (i32.const 47) "You Win!\00")  ;; String literal
  (data (i32.const 56) "Test ID: (\00")  ;; String literal
  (data (i32.const 67) ")\00")  ;; String literal
  (data (i32.const 69) "Test: Larger maze app with limited visibility\00")  ;; String literal
  (data (i32.const 115) "w\00")  ;; String literal
  (data (i32.const 117) "KeyUp\00")  ;; String literal
  (data (i32.const 123) "a\00")  ;; String literal
  (data (i32.const 125) "KeyLeft\00")  ;; String literal
  (data (i32.const 133) "s\00")  ;; String literal
  (data (i32.const 135) "KeyDown\00")  ;; String literal
  (data (i32.const 143) "d\00")  ;; String literal
  (data (i32.const 145) "KeyRight\00")  ;; String literal
  (data (i32.const 154) "ArrowUp\00")  ;; String literal
  (data (i32.const 162) "ArrowLeft\00")  ;; String literal
  (data (i32.const 172) "ArrowDown\00")  ;; String literal
  (data (i32.const 182) "ArrowRight\00")  ;; String literal
  (data (i32.const 193) "l\00")  ;; String literal
  (data (i32.const 195) "ToggleLights\00")  ;; String literal
  (data (i32.const 208) "Toggle Lights!\00")  ;; String literal
  (data (i32.const 223) "###################################+#\00")  ;; String literal
  (data (i32.const 261) "# #       #       #     #         # #\00")  ;; String literal
  (data (i32.const 299) "# # ##### # ### ##### ### ### ### # #\00")  ;; String literal
  (data (i32.const 337) "#       #   # #     #     # # #   # #\00")  ;; String literal
  (data (i32.const 375) "##### # ##### ##### ### # # # ##### #\00")  ;; String literal
  (data (i32.const 413) "#   # #       #     # # # # #     # #\00")  ;; String literal
  (data (i32.const 451) "# # ####### # # ##### ### # ##### # #\00")  ;; String literal
  (data (i32.const 489) "# #       # # #   #     #     #   # #\00")  ;; String literal
  (data (i32.const 527) "# ####### ### ### # ### ##### # ### #\00")  ;; String literal
  (data (i32.const 565) "#     #   # #   # #   #     # #     #\00")  ;; String literal
  (data (i32.const 603) "# ### ### # ### # ##### # # # #######\00")  ;; String literal
  (data (i32.const 641) "#   #   # # #   #   #   # # #   #   #\00")  ;; String literal
  (data (i32.const 679) "####### # # # ##### # ### # ### ### #\00")  ;; String literal
  (data (i32.const 717) "#     # #     #   # #   # #   #     #\00")  ;; String literal
  (data (i32.const 755) "# ### # ##### ### # ### ### ####### #\00")  ;; String literal
  (data (i32.const 793) "# #   #     #     #   # # #       # #\00")  ;; String literal
  (data (i32.const 831) "# # ##### # ### ##### # # ####### # #\00")  ;; String literal
  (data (i32.const 869) "# #     # # # # #     #       # #   #\00")  ;; String literal
  (data (i32.const 907) "# ##### # # # ### ##### ##### # #####\00")  ;; String literal
  (data (i32.const 945) "# #   # # #     #     # #   #       #\00")  ;; String literal
  (data (i32.const 983) "# # ### ### ### ##### ### # ##### # #\00")  ;; String literal
  (data (i32.const 1021) "# #         #     #       #       # #\00")  ;; String literal
  (data (i32.const 1059) "#-###################################\00")  ;; String literal

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

  (func $Fun13 (param $var35 i32) (result i32)
    (local $var36 i32) ;; Declare var 'out_string'
    ;; == If Condition ==
    (local.get $var35)  ;; Variable 'val'
    (i32.const 0)  ;; Literal value
    (i32.eq)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; String literal at memory position 0
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (i32.const 2)  ;; String literal at memory position 2
    (call $_str_copy)  ;; Copy string to new memory location
    (local.set $var36)  ;; Set var 'out_string'
    ;; == If Condition ==
    (local.get $var35)  ;; Variable 'val'
    (i32.const 0)  ;; Literal value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 3)  ;; String literal at memory position 3
        (call $_str_copy)  ;; Copy string to new memory location
        (local.set $var36)  ;; Set var 'out_string'
        ;; Calculate RHS for assignment.
        (i32.const 0)       ;; Setup negation
        (local.get $var35)  ;; Variable 'val'
        (i32.sub)           ;; Negate value
        (local.set $var35)  ;; Set var 'val'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (local.get $var35)  ;; Variable 'val'
    (i32.const 10)  ;; Literal value
    (i32.ge_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (local.get $var36)  ;; Variable 'out_string'
        ;; Call function 'IntToString'
        (local.get $var35)  ;; Variable 'val'
        (i32.const 10)  ;; Literal value
        (i32.div_s)
        (call $Fun13)  ;; Call 'IntToString'
        (call $_str_concat)  ;; Concatenate strings
        (call $_str_copy)  ;; Copy string to new memory location
        (local.set $var36)  ;; Set var 'out_string'
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (local.get $var36)  ;; Variable 'out_string'
    (i32.const 48)  ;; Literal value
    (local.get $var35)  ;; Variable 'val'
    (i32.const 10)  ;; Literal value
    (i32.rem_s)  ;; Remainder (int only)
    (i32.add)
    (call $_add_char)  ;; String + Int
    (return)
  )
  (func $Fun14 (param $var37 i32) (param $var38 i32) (param $var39 i32) (result i32)
    ;; Call function 'LineColor'
    (i32.const 5)  ;; String literal at memory position 5
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'FillColor'
    (local.get $var39)  ;; Variable 'color'
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'LineWidth'
    (i32.const 1)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; Call function 'Rect'
    (local.get $var38)  ;; Variable 'col'
    (global.get $var33)  ;; Global variable 'cell_width'
    (i32.mul)
    (local.get $var37)  ;; Variable 'row'
    (global.get $var34)  ;; Global variable 'cell_height'
    (i32.mul)
    (global.get $var33)  ;; Global variable 'cell_width'
    (global.get $var34)  ;; Global variable 'cell_height'
    (call $drawRect) ;; Call function Rect
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun15 (param $var40 i32) (result i32)
    ;; == If Condition ==
    (local.get $var40)  ;; Variable 'in'
    (i32.const 0)  ;; Literal value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)       ;; Setup negation
        (local.get $var40)  ;; Variable 'in'
        (i32.sub)           ;; Negate value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (local.get $var40)  ;; Variable 'in'
    (return)
  )
  (func $Fun16 (param $var41 i32) (param $var42 i32) (result i32)
    (local $var43 i32) ;; Declare var 'x_dist'
    (local $var44 i32) ;; Declare var 'x_sqr'
    (local $var45 i32) ;; Declare var 'y_dist'
    (local $var46 i32) ;; Declare var 'y_sqr'
    ;; Calculate RHS for assignment.
    (local.get $var42)  ;; Variable 'col'
    (global.get $var30)  ;; Global variable 'player_col'
    (i32.sub)
    (local.set $var43)  ;; Set var 'x_dist'
    ;; Calculate RHS for assignment.
    (local.get $var43)  ;; Variable 'x_dist'
    (local.get $var43)  ;; Variable 'x_dist'
    (i32.mul)
    (local.set $var44)  ;; Set var 'x_sqr'
    ;; Calculate RHS for assignment.
    (local.get $var41)  ;; Variable 'row'
    (global.get $var29)  ;; Global variable 'player_row'
    (i32.sub)
    (local.set $var45)  ;; Set var 'y_dist'
    ;; Calculate RHS for assignment.
    (local.get $var45)  ;; Variable 'y_dist'
    (local.get $var45)  ;; Variable 'y_dist'
    (i32.mul)
    (local.set $var46)  ;; Set var 'y_sqr'
    ;; == Generate return code ==
    (local.get $var44)  ;; Variable 'x_sqr'
    (local.get $var46)  ;; Variable 'y_sqr'
    (i32.add)
    (return)
  )
  (func $Fun17 (result i32)
    (local $var47 i32) ;; Declare var 'row'
    (local $var48 i32) ;; Declare var 'col'
    (local $var49 i32) ;; Declare var 'id'
    (local $var50 i32) ;; Declare var 'dist'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (local.set $var47)  ;; Set var 'row'
    (block $exit1 ;; Outer block for breaking while loop.
      (loop $loop1 ;; Inner loop for continuing while.
        ;; == WHILE 1 CONDITION ==
        (local.get $var47)  ;; Variable 'row'
        (global.get $var27)  ;; Global variable 'num_rows'
        (i32.lt_s)
        ;; == END WHILE 1 CONDITION ==
        (i32.eqz)       ;; Invert the result of the test condition.
        (br_if $exit1) ;; If condition was false (0), exit the loop
        ;; == WHILE 1 BODY ==
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (local.set $var48)  ;; Set var 'col'
        (block $exit2 ;; Outer block for breaking while loop.
          (loop $loop2 ;; Inner loop for continuing while.
            ;; == WHILE 2 CONDITION ==
            (local.get $var48)  ;; Variable 'col'
            (global.get $var28)  ;; Global variable 'num_cols'
            (i32.lt_s)
            ;; == END WHILE 2 CONDITION ==
            (i32.eqz)       ;; Invert the result of the test condition.
            (br_if $exit2) ;; If condition was false (0), exit the loop
            ;; == WHILE 2 BODY ==
            ;; Calculate RHS for assignment.
            (local.get $var47)  ;; Variable 'row'
            (global.get $var28)  ;; Global variable 'num_cols'
            (i32.mul)
            (local.get $var48)  ;; Variable 'col'
            (i32.add)
            (local.set $var49)  ;; Set var 'id'
            ;; Calculate RHS for assignment.
            ;; Call function 'PlayerDistance'
            (local.get $var47)  ;; Variable 'row'
            (local.get $var48)  ;; Variable 'col'
            (call $Fun16)  ;; Call 'PlayerDistance'
            (local.set $var50)  ;; Set var 'dist'
            ;; == If Condition ==
            (local.get $var50)  ;; Variable 'dist'
            (i32.const 0)  ;; Literal value
            (i32.eq)
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; Call function 'DrawCell'
                (local.get $var47)  ;; Variable 'row'
                (local.get $var48)  ;; Variable 'col'
                (i32.const 11)  ;; String literal at memory position 11
                (call $Fun14)  ;; Call 'DrawCell'
                (drop) ;; Result not used.
              ) ;; End 'then'
              (else ;; 'else' block
                ;; == If Condition ==
                (global.get $var31)  ;; Global variable 'lights'
                (i32.const 0)  ;; Literal value
                (i32.eq)
                (local.get $var50)  ;; Variable 'dist'
                (i32.const 16)  ;; Literal value
                (i32.ge_s)
                (i32.mul)
                (if ;; Execute code based on result of condition.
                  (then ;; 'then' block
                    ;; Call function 'DrawCell'
                    (local.get $var47)  ;; Variable 'row'
                    (local.get $var48)  ;; Variable 'col'
                    (i32.const 5)  ;; String literal at memory position 5
                    (call $Fun14)  ;; Call 'DrawCell'
                    (drop) ;; Result not used.
                  ) ;; End 'then'
                  (else ;; 'else' block
                    ;; == If Condition ==
                    (global.get $var26)  ;; Global variable 'layout'
                    (local.get $var49)  ;; Variable 'id'
                    (i32.add)
                    (i32.load8_u)
                    (i32.const 35)  ;; Literal value
                    (i32.eq)
                    (if ;; Execute code based on result of condition.
                      (then ;; 'then' block
                        ;; Call function 'DrawCell'
                        (local.get $var47)  ;; Variable 'row'
                        (local.get $var48)  ;; Variable 'col'
                        (i32.const 16)  ;; String literal at memory position 16
                        (call $Fun14)  ;; Call 'DrawCell'
                        (drop) ;; Result not used.
                      ) ;; End 'then'
                      (else ;; 'else' block
                        ;; == If Condition ==
                        (global.get $var26)  ;; Global variable 'layout'
                        (local.get $var49)  ;; Variable 'id'
                        (i32.add)
                        (i32.load8_u)
                        (i32.const 43)  ;; Literal value
                        (i32.eq)
                        (if ;; Execute code based on result of condition.
                          (then ;; 'then' block
                            ;; Call function 'DrawCell'
                            (local.get $var47)  ;; Variable 'row'
                            (local.get $var48)  ;; Variable 'col'
                            (i32.const 24)  ;; String literal at memory position 24
                            (call $Fun14)  ;; Call 'DrawCell'
                            (drop) ;; Result not used.
                          ) ;; End 'then'
                          (else ;; 'else' block
                            ;; == If Condition ==
                            (global.get $var26)  ;; Global variable 'layout'
                            (local.get $var49)  ;; Variable 'id'
                            (i32.add)
                            (i32.load8_u)
                            (i32.const 45)  ;; Literal value
                            (i32.eq)
                            (if ;; Execute code based on result of condition.
                              (then ;; 'then' block
                                ;; Call function 'DrawCell'
                                (local.get $var47)  ;; Variable 'row'
                                (local.get $var48)  ;; Variable 'col'
                                (i32.const 30)  ;; String literal at memory position 30
                                (call $Fun14)  ;; Call 'DrawCell'
                                (drop) ;; Result not used.
                              ) ;; End 'then'
                              (else ;; 'else' block
                                ;; Call function 'DrawCell'
                                (local.get $var47)  ;; Variable 'row'
                                (local.get $var48)  ;; Variable 'col'
                                (i32.const 34)  ;; String literal at memory position 34
                                (call $Fun14)  ;; Call 'DrawCell'
                                (drop) ;; Result not used.
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
            ;; Calculate RHS for assignment.
            (local.get $var48)  ;; Variable 'col'
            (i32.const 1)  ;; Literal value
            (i32.add)
            (local.set $var48)  ;; Set var 'col'
            ;; == END WHILE 2 BODY ==
            (br $loop2) ;; Branch back to the start of the loop
          ) ;; End loop
        ) ;; End block

        ;; Calculate RHS for assignment.
        (local.get $var47)  ;; Variable 'row'
        (i32.const 1)  ;; Literal value
        (i32.add)
        (local.set $var47)  ;; Set var 'row'
        ;; == END WHILE 1 BODY ==
        (br $loop1) ;; Branch back to the start of the loop
      ) ;; End loop
    ) ;; End block

    ;; == If Condition ==
    (global.get $var32)  ;; Global variable 'solved'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'FillColor'
        (i32.const 5)  ;; String literal at memory position 5
        (call $setFillColor) ;; Call function FillColor
        ;; Call function 'LineColor'
        (i32.const 34)  ;; String literal at memory position 34
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
        (i32.const 40)  ;; String literal at memory position 40
        (call $setFillColor) ;; Call function FillColor
        ;; Call function 'Text'
        (i32.const 190)  ;; Literal value
        (i32.const 40)  ;; Literal value
        (i32.const 50)  ;; Literal value
        (i32.const 47)  ;; String literal at memory position 47
        (call $drawText) ;; Call function Text
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun18 (param $var51 i32) (param $var52 i32) (result i32)
    (local $var53 i32) ;; Declare var 'new_id'
    ;; == If Condition ==
    (local.get $var51)  ;; Variable 'new_row'
    (i32.const 0)  ;; Literal value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (local.get $var51)  ;; Variable 'new_row'
    (global.get $var27)  ;; Global variable 'num_rows'
    (i32.ge_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (local.get $var52)  ;; Variable 'new_col'
    (i32.const 0)  ;; Literal value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (local.get $var52)  ;; Variable 'new_col'
    (global.get $var28)  ;; Global variable 'num_cols'
    (i32.ge_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (local.get $var51)  ;; Variable 'new_row'
    (global.get $var28)  ;; Global variable 'num_cols'
    (i32.mul)
    (local.get $var52)  ;; Variable 'new_col'
    (i32.add)
    (local.set $var53)  ;; Set var 'new_id'
    ;; Call function 'SetTitle'
    (i32.const 56)  ;; String literal at memory position 56
    ;; Call function 'IntToString'
    (local.get $var53)  ;; Variable 'new_id'
    (call $Fun13)  ;; Call 'IntToString'
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 67)  ;; String literal at memory position 67
    (call $_str_concat)  ;; Concatenate strings
    (call $setTitle) ;; Call function SetTitle
    ;; == If Condition ==
    (global.get $var26)  ;; Global variable 'layout'
    (local.get $var53)  ;; Variable 'new_id'
    (i32.add)
    (i32.load8_u)
    (i32.const 35)  ;; Literal value
    (i32.ne)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (local.get $var51)  ;; Variable 'new_row'
        (global.set $var29)  ;; Set global var 'player_row'
        ;; Calculate RHS for assignment.
        (local.get $var52)  ;; Variable 'new_col'
        (global.set $var30)  ;; Set global var 'player_col'
        ;; Calculate RHS for assignment.
        (global.get $var26)  ;; Global variable 'layout'
        (local.get $var53)  ;; Variable 'new_id'
        (i32.add)
        (i32.load8_u)
        (i32.const 43)  ;; Literal value
        (i32.eq)
        (global.set $var32)  ;; Set global var 'solved'
        ;; Call function 'DrawBoard'
        (call $Fun17)  ;; Call 'DrawBoard'
        (drop) ;; Result not used.
        ;; == Generate return code ==
        (i32.const 1)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun19 (result i32)
    ;; == Generate return code ==
    ;; Call function 'TryMove'
    (global.get $var29)  ;; Global variable 'player_row'
    (i32.const 1)  ;; Literal value
    (i32.sub)
    (global.get $var30)  ;; Global variable 'player_col'
    (call $Fun18)  ;; Call 'TryMove'
    (return)
  )
  (func $Fun20 (result i32)
    ;; == Generate return code ==
    ;; Call function 'TryMove'
    (global.get $var29)  ;; Global variable 'player_row'
    (i32.const 1)  ;; Literal value
    (i32.add)
    (global.get $var30)  ;; Global variable 'player_col'
    (call $Fun18)  ;; Call 'TryMove'
    (return)
  )
  (func $Fun21 (result i32)
    ;; == Generate return code ==
    ;; Call function 'TryMove'
    (global.get $var29)  ;; Global variable 'player_row'
    (global.get $var30)  ;; Global variable 'player_col'
    (i32.const 1)  ;; Literal value
    (i32.sub)
    (call $Fun18)  ;; Call 'TryMove'
    (return)
  )
  (func $Fun22 (result i32)
    ;; == Generate return code ==
    ;; Call function 'TryMove'
    (global.get $var29)  ;; Global variable 'player_row'
    (global.get $var30)  ;; Global variable 'player_col'
    (i32.const 1)  ;; Literal value
    (i32.add)
    (call $Fun18)  ;; Call 'TryMove'
    (return)
  )
  (func $Fun23 (result i32)
    ;; Calculate RHS for assignment.
    (global.get $var31)  ;; Global variable 'lights'
    (i32.eqz)  ;; Do operator '!'
    (global.set $var31)  ;; Set global var 'lights'
    ;; Call function 'DrawBoard'
    (call $Fun17)  ;; Call 'DrawBoard'
    (drop) ;; Result not used.
    ;; == Generate return code ==
    (global.get $var31)  ;; Global variable 'lights'
    (return)
  )
  (func $Fun24 (result i32)
    ;; Call function 'SetTitle'
    (i32.const 69)  ;; String literal at memory position 69
    (call $setTitle) ;; Call function SetTitle
    ;; Call function 'DrawBoard'
    (call $Fun17)  ;; Call 'DrawBoard'
    (drop) ;; Result not used.
    ;; Call function 'AddKeypress'
    (i32.const 115)  ;; String literal at memory position 115
    (i32.const 117)  ;; String literal at memory position 117
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 123)  ;; String literal at memory position 123
    (i32.const 125)  ;; String literal at memory position 125
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 133)  ;; String literal at memory position 133
    (i32.const 135)  ;; String literal at memory position 135
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 143)  ;; String literal at memory position 143
    (i32.const 145)  ;; String literal at memory position 145
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 154)  ;; String literal at memory position 154
    (i32.const 117)  ;; String literal at memory position 117
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 162)  ;; String literal at memory position 162
    (i32.const 125)  ;; String literal at memory position 125
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 172)  ;; String literal at memory position 172
    (i32.const 135)  ;; String literal at memory position 135
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 182)  ;; String literal at memory position 182
    (i32.const 145)  ;; String literal at memory position 145
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 193)  ;; String literal at memory position 193
    (i32.const 195)  ;; String literal at memory position 195
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddButton'
    (i32.const 208)  ;; String literal at memory position 208
    (i32.const 195)  ;; String literal at memory position 195
    (call $addButton) ;; Call function AddButton
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )

  (func $Init
    ;; Initialize global 'layout'
    (i32.const 223)  ;; String literal at memory position 223
    (i32.const 261)  ;; String literal at memory position 261
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 299)  ;; String literal at memory position 299
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 337)  ;; String literal at memory position 337
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 375)  ;; String literal at memory position 375
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 413)  ;; String literal at memory position 413
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 451)  ;; String literal at memory position 451
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 489)  ;; String literal at memory position 489
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 527)  ;; String literal at memory position 527
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 565)  ;; String literal at memory position 565
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 603)  ;; String literal at memory position 603
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 641)  ;; String literal at memory position 641
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 679)  ;; String literal at memory position 679
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 717)  ;; String literal at memory position 717
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 755)  ;; String literal at memory position 755
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 793)  ;; String literal at memory position 793
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 831)  ;; String literal at memory position 831
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 869)  ;; String literal at memory position 869
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 907)  ;; String literal at memory position 907
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 945)  ;; String literal at memory position 945
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 983)  ;; String literal at memory position 983
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 1021)  ;; String literal at memory position 1021
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 1059)  ;; String literal at memory position 1059
    (call $_str_concat)  ;; Concatenate strings
    (global.set $var26)
    ;; Initialize global 'num_rows'
    (i32.const 23)  ;; Literal value
    (global.set $var27)
    ;; Initialize global 'num_cols'
    (i32.const 37)  ;; Literal value
    (global.set $var28)
    ;; Initialize global 'player_row'
    (i32.const 22)  ;; Literal value
    (global.set $var29)
    ;; Initialize global 'player_col'
    (i32.const 1)  ;; Literal value
    (global.set $var30)
    ;; Initialize global 'lights'
    (i32.const 0)  ;; Literal value
    (global.set $var31)
    ;; Initialize global 'solved'
    (i32.const 0)  ;; Literal value
    (global.set $var32)
    ;; Initialize global 'cell_width'
    (i32.const 600)  ;; Literal value
    (global.get $var28)  ;; Global variable 'num_cols'
    (i32.div_s)
    (global.set $var33)
    ;; Initialize global 'cell_height'
    (i32.const 600)  ;; Literal value
    (global.get $var27)  ;; Global variable 'num_rows'
    (i32.div_s)
    (global.set $var34)
  )
  (start $Init)

  (export "IntToString" (func $Fun13))
  (export "DrawCell" (func $Fun14))
  (export "Abs" (func $Fun15))
  (export "PlayerDistance" (func $Fun16))
  (export "DrawBoard" (func $Fun17))
  (export "TryMove" (func $Fun18))
  (export "KeyUp" (func $Fun19))
  (export "KeyDown" (func $Fun20))
  (export "KeyLeft" (func $Fun21))
  (export "KeyRight" (func $Fun22))
  (export "ToggleLights" (func $Fun23))
  (export "Main" (func $Fun24))
) ;; End module
