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
  (global $free_mem (mut i32) (i32.const 244))

  (global $var26 (mut i32) (i32.const 0))  ;; Global variable 'num_rows'
  (global $var27 (mut i32) (i32.const 0))  ;; Global variable 'num_cols'
  (global $var28 (mut i32) (i32.const 0))  ;; Global variable 'player_row'
  (global $var29 (mut i32) (i32.const 0))  ;; Global variable 'player_col'
  (global $var30 (mut i32) (i32.const 0))  ;; Global variable 'layout'
  (global $var31 (mut i32) (i32.const 0))  ;; Global variable 'cell_width'
  (global $var32 (mut i32) (i32.const 0))  ;; Global variable 'cell_height'

  (data (i32.const 0) "black\00")  ;; String literal
  (data (i32.const 6) "white\00")  ;; String literal
  (data (i32.const 12) "#202020\00")  ;; String literal
  (data (i32.const 20) "green\00")  ;; String literal
  (data (i32.const 26) "red\00")  ;; String literal
  (data (i32.const 30) "blue\00")  ;; String literal
  (data (i32.const 35) "Test: Keyboard input\00")  ;; String literal
  (data (i32.const 56) "w\00")  ;; String literal
  (data (i32.const 58) "KeyUp\00")  ;; String literal
  (data (i32.const 64) "a\00")  ;; String literal
  (data (i32.const 66) "KeyLeft\00")  ;; String literal
  (data (i32.const 74) "s\00")  ;; String literal
  (data (i32.const 76) "KeyDown\00")  ;; String literal
  (data (i32.const 84) "d\00")  ;; String literal
  (data (i32.const 86) "KeyRight\00")  ;; String literal
  (data (i32.const 95) "ArrowUp\00")  ;; String literal
  (data (i32.const 103) "ArrowLeft\00")  ;; String literal
  (data (i32.const 113) "ArrowDown\00")  ;; String literal
  (data (i32.const 123) "ArrowRight\00")  ;; String literal
  (data (i32.const 134) "##########\00")  ;; String literal
  (data (i32.const 145) "+ #      #\00")  ;; String literal
  (data (i32.const 156) "# # ## # #\00")  ;; String literal
  (data (i32.const 167) "# # #  # #\00")  ;; String literal
  (data (i32.const 178) "# # # ####\00")  ;; String literal
  (data (i32.const 189) "#   #    #\00")  ;; String literal
  (data (i32.const 200) "# ###### #\00")  ;; String literal
  (data (i32.const 211) "# #   #  #\00")  ;; String literal
  (data (i32.const 222) "#   # # ##\00")  ;; String literal
  (data (i32.const 233) "#######-##\00")  ;; String literal

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

  (func $Fun13 (param $var33 i32) (param $var34 i32) (param $var35 i32) (result i32)
    ;; Call function 'LineColor'
    (i32.const 0)  ;; String literal at memory position 0
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'FillColor'
    (local.get $var35)  ;; Variable 'color'
    (call $setFillColor) ;; Call function FillColor
    ;; Call function 'LineWidth'
    (i32.const 1)  ;; Literal value
    (call $setLineWidth) ;; Call function LineWidth
    ;; Call function 'Rect'
    (local.get $var34)  ;; Variable 'col'
    (global.get $var31)  ;; Global variable 'cell_width'
    (i32.mul)
    (local.get $var33)  ;; Variable 'row'
    (global.get $var32)  ;; Global variable 'cell_height'
    (i32.mul)
    (global.get $var32)  ;; Global variable 'cell_height'
    (global.get $var32)  ;; Global variable 'cell_height'
    (call $drawRect) ;; Call function Rect
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun14 (result i32)
    (local $var36 i32) ;; Declare var 'row'
    (local $var37 i32) ;; Declare var 'col'
    (local $var38 i32) ;; Declare var 'id'
    (local $var39 i32) ;; Declare var 'cell_color'
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (local.set $var36)  ;; Set var 'row'
    (block $exit1 ;; Outer block for breaking while loop.
      (loop $loop1 ;; Inner loop for continuing while.
        ;; == WHILE 1 CONDITION ==
        (local.get $var36)  ;; Variable 'row'
        (global.get $var26)  ;; Global variable 'num_rows'
        (i32.lt_s)
        ;; == END WHILE 1 CONDITION ==
        (i32.eqz)       ;; Invert the result of the test condition.
        (br_if $exit1) ;; If condition was false (0), exit the loop
        ;; == WHILE 1 BODY ==
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (local.set $var37)  ;; Set var 'col'
        (block $exit2 ;; Outer block for breaking while loop.
          (loop $loop2 ;; Inner loop for continuing while.
            ;; == WHILE 2 CONDITION ==
            (local.get $var37)  ;; Variable 'col'
            (global.get $var27)  ;; Global variable 'num_cols'
            (i32.lt_s)
            ;; == END WHILE 2 CONDITION ==
            (i32.eqz)       ;; Invert the result of the test condition.
            (br_if $exit2) ;; If condition was false (0), exit the loop
            ;; == WHILE 2 BODY ==
            ;; Calculate RHS for assignment.
            (local.get $var36)  ;; Variable 'row'
            (global.get $var27)  ;; Global variable 'num_cols'
            (i32.mul)
            (local.get $var37)  ;; Variable 'col'
            (i32.add)
            (local.set $var38)  ;; Set var 'id'
            ;; Calculate RHS for assignment.
            (i32.const 6)  ;; String literal at memory position 6
            (call $_str_copy)  ;; Copy string to new memory location
            (local.set $var39)  ;; Set var 'cell_color'
            ;; == If Condition ==
            (global.get $var30)  ;; Global variable 'layout'
            (local.get $var38)  ;; Variable 'id'
            (i32.add)
            (i32.load8_u)
            (i32.const 35)  ;; Literal value
            (i32.eq)
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; Calculate RHS for assignment.
                (i32.const 12)  ;; String literal at memory position 12
                (call $_str_copy)  ;; Copy string to new memory location
                (local.set $var39)  ;; Set var 'cell_color'
              ) ;; End 'then'
              (else ;; 'else' block
                ;; == If Condition ==
                (global.get $var30)  ;; Global variable 'layout'
                (local.get $var38)  ;; Variable 'id'
                (i32.add)
                (i32.load8_u)
                (i32.const 43)  ;; Literal value
                (i32.eq)
                (if ;; Execute code based on result of condition.
                  (then ;; 'then' block
                    ;; Calculate RHS for assignment.
                    (i32.const 20)  ;; String literal at memory position 20
                    (call $_str_copy)  ;; Copy string to new memory location
                    (local.set $var39)  ;; Set var 'cell_color'
                  ) ;; End 'then'
                  (else ;; 'else' block
                    ;; == If Condition ==
                    (global.get $var30)  ;; Global variable 'layout'
                    (local.get $var38)  ;; Variable 'id'
                    (i32.add)
                    (i32.load8_u)
                    (i32.const 45)  ;; Literal value
                    (i32.eq)
                    (if ;; Execute code based on result of condition.
                      (then ;; 'then' block
                        ;; Calculate RHS for assignment.
                        (i32.const 26)  ;; String literal at memory position 26
                        (call $_str_copy)  ;; Copy string to new memory location
                        (local.set $var39)  ;; Set var 'cell_color'
                      ) ;; End 'then'
                    ) ;; End 'if'
                  ) ;; End 'else'
                ) ;; End 'if'
              ) ;; End 'else'
            ) ;; End 'if'
            ;; == If Condition ==
            (local.get $var36)  ;; Variable 'row'
            (global.get $var28)  ;; Global variable 'player_row'
            (i32.eq)
            (local.get $var37)  ;; Variable 'col'
            (global.get $var29)  ;; Global variable 'player_col'
            (i32.eq)
            (i32.mul)
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; Calculate RHS for assignment.
                (i32.const 30)  ;; String literal at memory position 30
                (call $_str_copy)  ;; Copy string to new memory location
                (local.set $var39)  ;; Set var 'cell_color'
              ) ;; End 'then'
            ) ;; End 'if'
            ;; Call function 'DrawCell'
            (local.get $var36)  ;; Variable 'row'
            (local.get $var37)  ;; Variable 'col'
            (local.get $var39)  ;; Variable 'cell_color'
            (call $Fun13)  ;; Call 'DrawCell'
            (drop) ;; Result not used.
            ;; Calculate RHS for assignment.
            (local.get $var37)  ;; Variable 'col'
            (i32.const 1)  ;; Literal value
            (i32.add)
            (local.set $var37)  ;; Set var 'col'
            ;; == END WHILE 2 BODY ==
            (br $loop2) ;; Branch back to the start of the loop
          ) ;; End loop
        ) ;; End block

        ;; Calculate RHS for assignment.
        (local.get $var36)  ;; Variable 'row'
        (i32.const 1)  ;; Literal value
        (i32.add)
        (local.set $var36)  ;; Set var 'row'
        ;; == END WHILE 1 BODY ==
        (br $loop1) ;; Branch back to the start of the loop
      ) ;; End loop
    ) ;; End block

    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun15 (param $var40 i32) (param $var41 i32) (result i32)
    (local $var42 i32) ;; Declare var 'new_id'
    ;; == If Condition ==
    (local.get $var40)  ;; Variable 'new_row'
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
    (local.get $var40)  ;; Variable 'new_row'
    (global.get $var26)  ;; Global variable 'num_rows'
    (i32.ge_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (local.get $var41)  ;; Variable 'new_col'
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
    (local.get $var41)  ;; Variable 'new_col'
    (global.get $var27)  ;; Global variable 'num_cols'
    (i32.ge_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (local.get $var40)  ;; Variable 'new_row'
    (global.get $var27)  ;; Global variable 'num_cols'
    (i32.mul)
    (local.get $var41)  ;; Variable 'new_col'
    (i32.add)
    (local.set $var42)  ;; Set var 'new_id'
    ;; == If Condition ==
    (global.get $var30)  ;; Global variable 'layout'
    (local.get $var42)  ;; Variable 'new_id'
    (i32.add)
    (i32.load8_u)
    (i32.const 35)  ;; Literal value
    (i32.ne)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (local.get $var40)  ;; Variable 'new_row'
        (global.set $var28)  ;; Set global var 'player_row'
        ;; Calculate RHS for assignment.
        (local.get $var41)  ;; Variable 'new_col'
        (global.set $var29)  ;; Set global var 'player_col'
        ;; Call function 'DrawBoard'
        (call $Fun14)  ;; Call 'DrawBoard'
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
  (func $Fun16 (result i32)
    ;; == Generate return code ==
    ;; Call function 'TryMove'
    (global.get $var28)  ;; Global variable 'player_row'
    (i32.const 1)  ;; Literal value
    (i32.sub)
    (global.get $var29)  ;; Global variable 'player_col'
    (call $Fun15)  ;; Call 'TryMove'
    (return)
  )
  (func $Fun17 (result i32)
    ;; == Generate return code ==
    ;; Call function 'TryMove'
    (global.get $var28)  ;; Global variable 'player_row'
    (i32.const 1)  ;; Literal value
    (i32.add)
    (global.get $var29)  ;; Global variable 'player_col'
    (call $Fun15)  ;; Call 'TryMove'
    (return)
  )
  (func $Fun18 (result i32)
    ;; == Generate return code ==
    ;; Call function 'TryMove'
    (global.get $var28)  ;; Global variable 'player_row'
    (global.get $var29)  ;; Global variable 'player_col'
    (i32.const 1)  ;; Literal value
    (i32.sub)
    (call $Fun15)  ;; Call 'TryMove'
    (return)
  )
  (func $Fun19 (result i32)
    ;; == Generate return code ==
    ;; Call function 'TryMove'
    (global.get $var28)  ;; Global variable 'player_row'
    (global.get $var29)  ;; Global variable 'player_col'
    (i32.const 1)  ;; Literal value
    (i32.add)
    (call $Fun15)  ;; Call 'TryMove'
    (return)
  )
  (func $Fun20 (result i32)
    ;; Call function 'SetTitle'
    (i32.const 35)  ;; String literal at memory position 35
    (call $setTitle) ;; Call function SetTitle
    ;; Call function 'DrawBoard'
    (call $Fun14)  ;; Call 'DrawBoard'
    (drop) ;; Result not used.
    ;; Call function 'AddKeypress'
    (i32.const 56)  ;; String literal at memory position 56
    (i32.const 58)  ;; String literal at memory position 58
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 64)  ;; String literal at memory position 64
    (i32.const 66)  ;; String literal at memory position 66
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 74)  ;; String literal at memory position 74
    (i32.const 76)  ;; String literal at memory position 76
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 84)  ;; String literal at memory position 84
    (i32.const 86)  ;; String literal at memory position 86
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 95)  ;; String literal at memory position 95
    (i32.const 58)  ;; String literal at memory position 58
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 103)  ;; String literal at memory position 103
    (i32.const 66)  ;; String literal at memory position 66
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 113)  ;; String literal at memory position 113
    (i32.const 76)  ;; String literal at memory position 76
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; Call function 'AddKeypress'
    (i32.const 123)  ;; String literal at memory position 123
    (i32.const 86)  ;; String literal at memory position 86
    (call $addKeyTrigger) ;; Call function AddKeypress
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )

  (func $Init
    ;; Initialize global 'num_rows'
    (i32.const 10)  ;; Literal value
    (global.set $var26)
    ;; Initialize global 'num_cols'
    (i32.const 10)  ;; Literal value
    (global.set $var27)
    ;; Initialize global 'player_row'
    (i32.const 1)  ;; Literal value
    (global.set $var28)
    ;; Initialize global 'player_col'
    (i32.const 0)  ;; Literal value
    (global.set $var29)
    ;; Initialize global 'layout'
    (i32.const 134)  ;; String literal at memory position 134
    (i32.const 145)  ;; String literal at memory position 145
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 156)  ;; String literal at memory position 156
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 167)  ;; String literal at memory position 167
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 178)  ;; String literal at memory position 178
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 189)  ;; String literal at memory position 189
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 200)  ;; String literal at memory position 200
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 211)  ;; String literal at memory position 211
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 222)  ;; String literal at memory position 222
    (call $_str_concat)  ;; Concatenate strings
    (i32.const 233)  ;; String literal at memory position 233
    (call $_str_concat)  ;; Concatenate strings
    (global.set $var30)
    ;; Initialize global 'cell_width'
    (i32.const 600)  ;; Literal value
    (global.get $var27)  ;; Global variable 'num_cols'
    (i32.div_s)
    (global.set $var31)
    ;; Initialize global 'cell_height'
    (i32.const 600)  ;; Literal value
    (global.get $var26)  ;; Global variable 'num_rows'
    (i32.div_s)
    (global.set $var32)
  )
  (start $Init)

  (export "DrawCell" (func $Fun13))
  (export "DrawBoard" (func $Fun14))
  (export "TryMove" (func $Fun15))
  (export "KeyUp" (func $Fun16))
  (export "KeyDown" (func $Fun17))
  (export "KeyLeft" (func $Fun18))
  (export "KeyRight" (func $Fun19))
  (export "Main" (func $Fun20))
) ;; End module
