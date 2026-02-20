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

  (global $var26 (mut i32) (i32.const 0))  ;; Global variable 'board'
  (global $var27 (mut i32) (i32.const 0))  ;; Global variable 'mouse_id'
  (global $var28 (mut i32) (i32.const 0))  ;; Global variable 'turn'
  (global $var29 (mut i32) (i32.const 0))  ;; Global variable 'win_id'
  (global $var30 (mut i32) (i32.const 0))  ;; Global variable 'move_count'

  (data (i32.const 0) "black\00")  ;; String literal
  (data (i32.const 6) "White\00")  ;; String literal
  (data (i32.const 12) "#600000\00")  ;; String literal
  (data (i32.const 20) "#000060\00")  ;; String literal
  (data (i32.const 28) "white\00")  ;; String literal
  (data (i32.const 34) "#C0C0C0\00")  ;; String literal
  (data (i32.const 42) "#006000\00")  ;; String literal
  (data (i32.const 50) "Winner: \00")  ;; String literal
  (data (i32.const 59) "Tie game!\00")  ;; String literal
  (data (i32.const 69) "yellow\00")  ;; String literal
  (data (i32.const 76) "Test: Canvas clicks with tic-tac-toe\00")  ;; String literal
  (data (i32.const 113) "MouseClick\00")  ;; String literal
  (data (i32.const 124) "MouseMove\00")  ;; String literal
  (data (i32.const 134) "---------\00")  ;; String literal

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
    (global.get $var30)  ;; Global variable 'move_count'
    (i32.const 5)  ;; Literal value
    (i32.lt_s)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 0)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == If Condition ==
    (global.get $var26)  ;; Global variable 'board'
    (i32.const 0)  ;; Literal value
    (i32.add)
    (i32.load8_u)
    (i32.const 45)  ;; Literal value
    (i32.ne)
    (global.get $var26)  ;; Global variable 'board'
    (i32.const 0)  ;; Literal value
    (i32.add)
    (i32.load8_u)
    (global.get $var26)  ;; Global variable 'board'
    (i32.const 1)  ;; Literal value
    (i32.add)
    (i32.load8_u)
    (i32.eq)
    (i32.mul)
    (global.get $var26)  ;; Global variable 'board'
    (i32.const 1)  ;; Literal value
    (i32.add)
    (i32.load8_u)
    (global.get $var26)  ;; Global variable 'board'
    (i32.const 2)  ;; Literal value
    (i32.add)
    (i32.load8_u)
    (i32.eq)
    (i32.mul)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Calculate RHS for assignment.
        (i32.const 1)  ;; Literal value
        (global.set $var29)  ;; Set global var 'win_id'
      ) ;; End 'then'
      (else ;; 'else' block
        ;; == If Condition ==
        (global.get $var26)  ;; Global variable 'board'
        (i32.const 3)  ;; Literal value
        (i32.add)
        (i32.load8_u)
        (i32.const 45)  ;; Literal value
        (i32.ne)
        (global.get $var26)  ;; Global variable 'board'
        (i32.const 3)  ;; Literal value
        (i32.add)
        (i32.load8_u)
        (global.get $var26)  ;; Global variable 'board'
        (i32.const 4)  ;; Literal value
        (i32.add)
        (i32.load8_u)
        (i32.eq)
        (i32.mul)
        (global.get $var26)  ;; Global variable 'board'
        (i32.const 4)  ;; Literal value
        (i32.add)
        (i32.load8_u)
        (global.get $var26)  ;; Global variable 'board'
        (i32.const 5)  ;; Literal value
        (i32.add)
        (i32.load8_u)
        (i32.eq)
        (i32.mul)
        (if ;; Execute code based on result of condition.
          (then ;; 'then' block
            ;; Calculate RHS for assignment.
            (i32.const 2)  ;; Literal value
            (global.set $var29)  ;; Set global var 'win_id'
          ) ;; End 'then'
          (else ;; 'else' block
            ;; == If Condition ==
            (global.get $var26)  ;; Global variable 'board'
            (i32.const 6)  ;; Literal value
            (i32.add)
            (i32.load8_u)
            (i32.const 45)  ;; Literal value
            (i32.ne)
            (global.get $var26)  ;; Global variable 'board'
            (i32.const 6)  ;; Literal value
            (i32.add)
            (i32.load8_u)
            (global.get $var26)  ;; Global variable 'board'
            (i32.const 7)  ;; Literal value
            (i32.add)
            (i32.load8_u)
            (i32.eq)
            (i32.mul)
            (global.get $var26)  ;; Global variable 'board'
            (i32.const 7)  ;; Literal value
            (i32.add)
            (i32.load8_u)
            (global.get $var26)  ;; Global variable 'board'
            (i32.const 8)  ;; Literal value
            (i32.add)
            (i32.load8_u)
            (i32.eq)
            (i32.mul)
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; Calculate RHS for assignment.
                (i32.const 3)  ;; Literal value
                (global.set $var29)  ;; Set global var 'win_id'
              ) ;; End 'then'
              (else ;; 'else' block
                ;; == If Condition ==
                (global.get $var26)  ;; Global variable 'board'
                (i32.const 0)  ;; Literal value
                (i32.add)
                (i32.load8_u)
                (i32.const 45)  ;; Literal value
                (i32.ne)
                (global.get $var26)  ;; Global variable 'board'
                (i32.const 0)  ;; Literal value
                (i32.add)
                (i32.load8_u)
                (global.get $var26)  ;; Global variable 'board'
                (i32.const 3)  ;; Literal value
                (i32.add)
                (i32.load8_u)
                (i32.eq)
                (i32.mul)
                (global.get $var26)  ;; Global variable 'board'
                (i32.const 3)  ;; Literal value
                (i32.add)
                (i32.load8_u)
                (global.get $var26)  ;; Global variable 'board'
                (i32.const 6)  ;; Literal value
                (i32.add)
                (i32.load8_u)
                (i32.eq)
                (i32.mul)
                (if ;; Execute code based on result of condition.
                  (then ;; 'then' block
                    ;; Calculate RHS for assignment.
                    (i32.const 4)  ;; Literal value
                    (global.set $var29)  ;; Set global var 'win_id'
                  ) ;; End 'then'
                  (else ;; 'else' block
                    ;; == If Condition ==
                    (global.get $var26)  ;; Global variable 'board'
                    (i32.const 1)  ;; Literal value
                    (i32.add)
                    (i32.load8_u)
                    (i32.const 45)  ;; Literal value
                    (i32.ne)
                    (global.get $var26)  ;; Global variable 'board'
                    (i32.const 1)  ;; Literal value
                    (i32.add)
                    (i32.load8_u)
                    (global.get $var26)  ;; Global variable 'board'
                    (i32.const 4)  ;; Literal value
                    (i32.add)
                    (i32.load8_u)
                    (i32.eq)
                    (i32.mul)
                    (global.get $var26)  ;; Global variable 'board'
                    (i32.const 4)  ;; Literal value
                    (i32.add)
                    (i32.load8_u)
                    (global.get $var26)  ;; Global variable 'board'
                    (i32.const 7)  ;; Literal value
                    (i32.add)
                    (i32.load8_u)
                    (i32.eq)
                    (i32.mul)
                    (if ;; Execute code based on result of condition.
                      (then ;; 'then' block
                        ;; Calculate RHS for assignment.
                        (i32.const 5)  ;; Literal value
                        (global.set $var29)  ;; Set global var 'win_id'
                      ) ;; End 'then'
                      (else ;; 'else' block
                        ;; == If Condition ==
                        (global.get $var26)  ;; Global variable 'board'
                        (i32.const 2)  ;; Literal value
                        (i32.add)
                        (i32.load8_u)
                        (i32.const 45)  ;; Literal value
                        (i32.ne)
                        (global.get $var26)  ;; Global variable 'board'
                        (i32.const 2)  ;; Literal value
                        (i32.add)
                        (i32.load8_u)
                        (global.get $var26)  ;; Global variable 'board'
                        (i32.const 5)  ;; Literal value
                        (i32.add)
                        (i32.load8_u)
                        (i32.eq)
                        (i32.mul)
                        (global.get $var26)  ;; Global variable 'board'
                        (i32.const 5)  ;; Literal value
                        (i32.add)
                        (i32.load8_u)
                        (global.get $var26)  ;; Global variable 'board'
                        (i32.const 8)  ;; Literal value
                        (i32.add)
                        (i32.load8_u)
                        (i32.eq)
                        (i32.mul)
                        (if ;; Execute code based on result of condition.
                          (then ;; 'then' block
                            ;; Calculate RHS for assignment.
                            (i32.const 6)  ;; Literal value
                            (global.set $var29)  ;; Set global var 'win_id'
                          ) ;; End 'then'
                          (else ;; 'else' block
                            ;; == If Condition ==
                            (global.get $var26)  ;; Global variable 'board'
                            (i32.const 0)  ;; Literal value
                            (i32.add)
                            (i32.load8_u)
                            (i32.const 45)  ;; Literal value
                            (i32.ne)
                            (global.get $var26)  ;; Global variable 'board'
                            (i32.const 0)  ;; Literal value
                            (i32.add)
                            (i32.load8_u)
                            (global.get $var26)  ;; Global variable 'board'
                            (i32.const 4)  ;; Literal value
                            (i32.add)
                            (i32.load8_u)
                            (i32.eq)
                            (i32.mul)
                            (global.get $var26)  ;; Global variable 'board'
                            (i32.const 4)  ;; Literal value
                            (i32.add)
                            (i32.load8_u)
                            (global.get $var26)  ;; Global variable 'board'
                            (i32.const 8)  ;; Literal value
                            (i32.add)
                            (i32.load8_u)
                            (i32.eq)
                            (i32.mul)
                            (if ;; Execute code based on result of condition.
                              (then ;; 'then' block
                                ;; Calculate RHS for assignment.
                                (i32.const 7)  ;; Literal value
                                (global.set $var29)  ;; Set global var 'win_id'
                              ) ;; End 'then'
                              (else ;; 'else' block
                                ;; == If Condition ==
                                (global.get $var26)  ;; Global variable 'board'
                                (i32.const 2)  ;; Literal value
                                (i32.add)
                                (i32.load8_u)
                                (i32.const 45)  ;; Literal value
                                (i32.ne)
                                (global.get $var26)  ;; Global variable 'board'
                                (i32.const 2)  ;; Literal value
                                (i32.add)
                                (i32.load8_u)
                                (global.get $var26)  ;; Global variable 'board'
                                (i32.const 4)  ;; Literal value
                                (i32.add)
                                (i32.load8_u)
                                (i32.eq)
                                (i32.mul)
                                (global.get $var26)  ;; Global variable 'board'
                                (i32.const 4)  ;; Literal value
                                (i32.add)
                                (i32.load8_u)
                                (global.get $var26)  ;; Global variable 'board'
                                (i32.const 6)  ;; Literal value
                                (i32.add)
                                (i32.load8_u)
                                (i32.eq)
                                (i32.mul)
                                (if ;; Execute code based on result of condition.
                                  (then ;; 'then' block
                                    ;; Calculate RHS for assignment.
                                    (i32.const 8)  ;; Literal value
                                    (global.set $var29)  ;; Set global var 'win_id'
                                  ) ;; End 'then'
                                  (else ;; 'else' block
                                    ;; == If Condition ==
                                    (global.get $var30)  ;; Global variable 'move_count'
                                    (i32.const 9)  ;; Literal value
                                    (i32.eq)
                                    (if ;; Execute code based on result of condition.
                                      (then ;; 'then' block
                                        ;; Calculate RHS for assignment.
                                        (i32.const 9)  ;; Literal value
                                        (global.set $var29)  ;; Set global var 'win_id'
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
    ;; == Generate return code ==
    (global.get $var29)  ;; Global variable 'win_id'
    (return)
  )
  (func $Fun14 (result i32)
    (local $var31 i32) ;; Declare var 'row'
    (local $var32 i32) ;; Declare var 'col'
    (local $var33 i32) ;; Declare var 'id'
    (local $var34 i32) ;; Declare var 'win_char'
    (local $var35 i32) ;; Declare var 'win_label'
    ;; Call function 'LineColor'
    (i32.const 0)  ;; String literal at memory position 0
    (call $setStrokeColor) ;; Call function LineColor
    ;; Call function 'FillColor'
    (i32.const 6)  ;; String literal at memory position 6
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
    ;; Call function 'Line'
    (i32.const 200)  ;; Literal value
    (i32.const 0)  ;; Literal value
    (i32.const 200)  ;; Literal value
    (i32.const 600)  ;; Literal value
    (call $drawLine) ;; Call function Line
    ;; Call function 'Line'
    (i32.const 400)  ;; Literal value
    (i32.const 0)  ;; Literal value
    (i32.const 400)  ;; Literal value
    (i32.const 600)  ;; Literal value
    (call $drawLine) ;; Call function Line
    ;; Call function 'Line'
    (i32.const 0)  ;; Literal value
    (i32.const 200)  ;; Literal value
    (i32.const 600)  ;; Literal value
    (i32.const 200)  ;; Literal value
    (call $drawLine) ;; Call function Line
    ;; Call function 'Line'
    (i32.const 0)  ;; Literal value
    (i32.const 400)  ;; Literal value
    (i32.const 600)  ;; Literal value
    (i32.const 400)  ;; Literal value
    (call $drawLine) ;; Call function Line
    ;; Calculate RHS for assignment.
    (i32.const 0)  ;; Literal value
    (local.set $var31)  ;; Set var 'row'
    (block $exit1 ;; Outer block for breaking while loop.
      (loop $loop1 ;; Inner loop for continuing while.
        ;; == WHILE 1 CONDITION ==
        (local.get $var31)  ;; Variable 'row'
        (i32.const 3)  ;; Literal value
        (i32.lt_s)
        ;; == END WHILE 1 CONDITION ==
        (i32.eqz)       ;; Invert the result of the test condition.
        (br_if $exit1) ;; If condition was false (0), exit the loop
        ;; == WHILE 1 BODY ==
        ;; Calculate RHS for assignment.
        (i32.const 0)  ;; Literal value
        (local.set $var32)  ;; Set var 'col'
        (block $exit2 ;; Outer block for breaking while loop.
          (loop $loop2 ;; Inner loop for continuing while.
            ;; == WHILE 2 CONDITION ==
            (local.get $var32)  ;; Variable 'col'
            (i32.const 3)  ;; Literal value
            (i32.lt_s)
            ;; == END WHILE 2 CONDITION ==
            (i32.eqz)       ;; Invert the result of the test condition.
            (br_if $exit2) ;; If condition was false (0), exit the loop
            ;; == WHILE 2 BODY ==
            ;; Calculate RHS for assignment.
            (local.get $var31)  ;; Variable 'row'
            (i32.const 3)  ;; Literal value
            (i32.mul)
            (local.get $var32)  ;; Variable 'col'
            (i32.add)
            (local.set $var33)  ;; Set var 'id'
            ;; == If Condition ==
            (global.get $var26)  ;; Global variable 'board'
            (local.get $var33)  ;; Variable 'id'
            (i32.add)
            (i32.load8_u)
            (i32.const 88)  ;; Literal value
            (i32.eq)
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; Call function 'LineColor'
                (i32.const 12)  ;; String literal at memory position 12
                (call $setStrokeColor) ;; Call function LineColor
                ;; Call function 'LineWidth'
                (i32.const 12)  ;; Literal value
                (call $setLineWidth) ;; Call function LineWidth
                ;; Call function 'Line'
                (local.get $var32)  ;; Variable 'col'
                (i32.const 200)  ;; Literal value
                (i32.mul)
                (i32.const 20)  ;; Literal value
                (i32.add)
                (local.get $var31)  ;; Variable 'row'
                (i32.const 200)  ;; Literal value
                (i32.mul)
                (i32.const 20)  ;; Literal value
                (i32.add)
                (local.get $var32)  ;; Variable 'col'
                (i32.const 200)  ;; Literal value
                (i32.mul)
                (i32.const 180)  ;; Literal value
                (i32.add)
                (local.get $var31)  ;; Variable 'row'
                (i32.const 200)  ;; Literal value
                (i32.mul)
                (i32.const 180)  ;; Literal value
                (i32.add)
                (call $drawLine) ;; Call function Line
                ;; Call function 'Line'
                (local.get $var32)  ;; Variable 'col'
                (i32.const 200)  ;; Literal value
                (i32.mul)
                (i32.const 180)  ;; Literal value
                (i32.add)
                (local.get $var31)  ;; Variable 'row'
                (i32.const 200)  ;; Literal value
                (i32.mul)
                (i32.const 20)  ;; Literal value
                (i32.add)
                (local.get $var32)  ;; Variable 'col'
                (i32.const 200)  ;; Literal value
                (i32.mul)
                (i32.const 20)  ;; Literal value
                (i32.add)
                (local.get $var31)  ;; Variable 'row'
                (i32.const 200)  ;; Literal value
                (i32.mul)
                (i32.const 180)  ;; Literal value
                (i32.add)
                (call $drawLine) ;; Call function Line
              ) ;; End 'then'
              (else ;; 'else' block
                ;; == If Condition ==
                (global.get $var26)  ;; Global variable 'board'
                (local.get $var33)  ;; Variable 'id'
                (i32.add)
                (i32.load8_u)
                (i32.const 79)  ;; Literal value
                (i32.eq)
                (if ;; Execute code based on result of condition.
                  (then ;; 'then' block
                    ;; Call function 'LineColor'
                    (i32.const 20)  ;; String literal at memory position 20
                    (call $setStrokeColor) ;; Call function LineColor
                    ;; Call function 'LineWidth'
                    (i32.const 12)  ;; Literal value
                    (call $setLineWidth) ;; Call function LineWidth
                    ;; Call function 'FillColor'
                    (i32.const 28)  ;; String literal at memory position 28
                    (call $setFillColor) ;; Call function FillColor
                    ;; Call function 'Circle'
                    (local.get $var32)  ;; Variable 'col'
                    (i32.const 200)  ;; Literal value
                    (i32.mul)
                    (i32.const 100)  ;; Literal value
                    (i32.add)
                    (local.get $var31)  ;; Variable 'row'
                    (i32.const 200)  ;; Literal value
                    (i32.mul)
                    (i32.const 100)  ;; Literal value
                    (i32.add)
                    (i32.const 80)  ;; Literal value
                    (call $drawCircle) ;; Call function Circle
                  ) ;; End 'then'
                  (else ;; 'else' block
                    ;; == If Condition ==
                    (local.get $var33)  ;; Variable 'id'
                    (global.get $var27)  ;; Global variable 'mouse_id'
                    (i32.eq)
                    (if ;; Execute code based on result of condition.
                      (then ;; 'then' block
                        ;; Call function 'LineColor'
                        (i32.const 34)  ;; String literal at memory position 34
                        (call $setStrokeColor) ;; Call function LineColor
                        ;; Call function 'LineWidth'
                        (i32.const 12)  ;; Literal value
                        (call $setLineWidth) ;; Call function LineWidth
                        ;; == If Condition ==
                        (global.get $var28)  ;; Global variable 'turn'
                        (i32.const 88)  ;; Literal value
                        (i32.eq)
                        (if ;; Execute code based on result of condition.
                          (then ;; 'then' block
                            ;; Call function 'Line'
                            (local.get $var32)  ;; Variable 'col'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 20)  ;; Literal value
                            (i32.add)
                            (local.get $var31)  ;; Variable 'row'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 20)  ;; Literal value
                            (i32.add)
                            (local.get $var32)  ;; Variable 'col'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 180)  ;; Literal value
                            (i32.add)
                            (local.get $var31)  ;; Variable 'row'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 180)  ;; Literal value
                            (i32.add)
                            (call $drawLine) ;; Call function Line
                            ;; Call function 'Line'
                            (local.get $var32)  ;; Variable 'col'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 180)  ;; Literal value
                            (i32.add)
                            (local.get $var31)  ;; Variable 'row'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 20)  ;; Literal value
                            (i32.add)
                            (local.get $var32)  ;; Variable 'col'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 20)  ;; Literal value
                            (i32.add)
                            (local.get $var31)  ;; Variable 'row'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 180)  ;; Literal value
                            (i32.add)
                            (call $drawLine) ;; Call function Line
                          ) ;; End 'then'
                          (else ;; 'else' block
                            ;; Call function 'Circle'
                            (local.get $var32)  ;; Variable 'col'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 100)  ;; Literal value
                            (i32.add)
                            (local.get $var31)  ;; Variable 'row'
                            (i32.const 200)  ;; Literal value
                            (i32.mul)
                            (i32.const 100)  ;; Literal value
                            (i32.add)
                            (i32.const 80)  ;; Literal value
                            (call $drawCircle) ;; Call function Circle
                          ) ;; End 'else'
                        ) ;; End 'if'
                      ) ;; End 'then'
                    ) ;; End 'if'
                  ) ;; End 'else'
                ) ;; End 'if'
              ) ;; End 'else'
            ) ;; End 'if'
            ;; Calculate RHS for assignment.
            (local.get $var32)  ;; Variable 'col'
            (i32.const 1)  ;; Literal value
            (i32.add)
            (local.set $var32)  ;; Set var 'col'
            ;; == END WHILE 2 BODY ==
            (br $loop2) ;; Branch back to the start of the loop
          ) ;; End loop
        ) ;; End block

        ;; Calculate RHS for assignment.
        (local.get $var31)  ;; Variable 'row'
        (i32.const 1)  ;; Literal value
        (i32.add)
        (local.set $var31)  ;; Set var 'row'
        ;; == END WHILE 1 BODY ==
        (br $loop1) ;; Branch back to the start of the loop
      ) ;; End loop
    ) ;; End block

    ;; == If Condition ==
    (global.get $var29)  ;; Global variable 'win_id'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; Call function 'LineColor'
        (i32.const 42)  ;; String literal at memory position 42
        (call $setStrokeColor) ;; Call function LineColor
        ;; Call function 'LineWidth'
        (i32.const 8)  ;; Literal value
        (call $setLineWidth) ;; Call function LineWidth
        ;; Calculate RHS for assignment.
        (i32.const 45)  ;; Literal value
        (local.set $var34)  ;; Set var 'win_char'
        ;; == If Condition ==
        (global.get $var29)  ;; Global variable 'win_id'
        (i32.const 1)  ;; Literal value
        (i32.eq)
        (if ;; Execute code based on result of condition.
          (then ;; 'then' block
            ;; Call function 'Line'
            (i32.const 20)  ;; Literal value
            (i32.const 100)  ;; Literal value
            (i32.const 580)  ;; Literal value
            (i32.const 100)  ;; Literal value
            (call $drawLine) ;; Call function Line
            ;; Calculate RHS for assignment.
            (global.get $var26)  ;; Global variable 'board'
            (i32.const 0)  ;; Literal value
            (i32.add)
            (i32.load8_u)
            (local.set $var34)  ;; Set var 'win_char'
          ) ;; End 'then'
          (else ;; 'else' block
            ;; == If Condition ==
            (global.get $var29)  ;; Global variable 'win_id'
            (i32.const 2)  ;; Literal value
            (i32.eq)
            (if ;; Execute code based on result of condition.
              (then ;; 'then' block
                ;; Call function 'Line'
                (i32.const 20)  ;; Literal value
                (i32.const 300)  ;; Literal value
                (i32.const 580)  ;; Literal value
                (i32.const 300)  ;; Literal value
                (call $drawLine) ;; Call function Line
                ;; Calculate RHS for assignment.
                (global.get $var26)  ;; Global variable 'board'
                (i32.const 3)  ;; Literal value
                (i32.add)
                (i32.load8_u)
                (local.set $var34)  ;; Set var 'win_char'
              ) ;; End 'then'
              (else ;; 'else' block
                ;; == If Condition ==
                (global.get $var29)  ;; Global variable 'win_id'
                (i32.const 3)  ;; Literal value
                (i32.eq)
                (if ;; Execute code based on result of condition.
                  (then ;; 'then' block
                    ;; Call function 'Line'
                    (i32.const 20)  ;; Literal value
                    (i32.const 500)  ;; Literal value
                    (i32.const 580)  ;; Literal value
                    (i32.const 500)  ;; Literal value
                    (call $drawLine) ;; Call function Line
                    ;; Calculate RHS for assignment.
                    (global.get $var26)  ;; Global variable 'board'
                    (i32.const 6)  ;; Literal value
                    (i32.add)
                    (i32.load8_u)
                    (local.set $var34)  ;; Set var 'win_char'
                  ) ;; End 'then'
                  (else ;; 'else' block
                    ;; == If Condition ==
                    (global.get $var29)  ;; Global variable 'win_id'
                    (i32.const 4)  ;; Literal value
                    (i32.eq)
                    (if ;; Execute code based on result of condition.
                      (then ;; 'then' block
                        ;; Call function 'Line'
                        (i32.const 100)  ;; Literal value
                        (i32.const 20)  ;; Literal value
                        (i32.const 100)  ;; Literal value
                        (i32.const 580)  ;; Literal value
                        (call $drawLine) ;; Call function Line
                        ;; Calculate RHS for assignment.
                        (global.get $var26)  ;; Global variable 'board'
                        (i32.const 0)  ;; Literal value
                        (i32.add)
                        (i32.load8_u)
                        (local.set $var34)  ;; Set var 'win_char'
                      ) ;; End 'then'
                      (else ;; 'else' block
                        ;; == If Condition ==
                        (global.get $var29)  ;; Global variable 'win_id'
                        (i32.const 5)  ;; Literal value
                        (i32.eq)
                        (if ;; Execute code based on result of condition.
                          (then ;; 'then' block
                            ;; Call function 'Line'
                            (i32.const 300)  ;; Literal value
                            (i32.const 20)  ;; Literal value
                            (i32.const 300)  ;; Literal value
                            (i32.const 580)  ;; Literal value
                            (call $drawLine) ;; Call function Line
                            ;; Calculate RHS for assignment.
                            (global.get $var26)  ;; Global variable 'board'
                            (i32.const 1)  ;; Literal value
                            (i32.add)
                            (i32.load8_u)
                            (local.set $var34)  ;; Set var 'win_char'
                          ) ;; End 'then'
                          (else ;; 'else' block
                            ;; == If Condition ==
                            (global.get $var29)  ;; Global variable 'win_id'
                            (i32.const 6)  ;; Literal value
                            (i32.eq)
                            (if ;; Execute code based on result of condition.
                              (then ;; 'then' block
                                ;; Call function 'Line'
                                (i32.const 500)  ;; Literal value
                                (i32.const 20)  ;; Literal value
                                (i32.const 500)  ;; Literal value
                                (i32.const 580)  ;; Literal value
                                (call $drawLine) ;; Call function Line
                                ;; Calculate RHS for assignment.
                                (global.get $var26)  ;; Global variable 'board'
                                (i32.const 2)  ;; Literal value
                                (i32.add)
                                (i32.load8_u)
                                (local.set $var34)  ;; Set var 'win_char'
                              ) ;; End 'then'
                              (else ;; 'else' block
                                ;; == If Condition ==
                                (global.get $var29)  ;; Global variable 'win_id'
                                (i32.const 7)  ;; Literal value
                                (i32.eq)
                                (if ;; Execute code based on result of condition.
                                  (then ;; 'then' block
                                    ;; Call function 'Line'
                                    (i32.const 20)  ;; Literal value
                                    (i32.const 20)  ;; Literal value
                                    (i32.const 580)  ;; Literal value
                                    (i32.const 580)  ;; Literal value
                                    (call $drawLine) ;; Call function Line
                                    ;; Calculate RHS for assignment.
                                    (global.get $var26)  ;; Global variable 'board'
                                    (i32.const 0)  ;; Literal value
                                    (i32.add)
                                    (i32.load8_u)
                                    (local.set $var34)  ;; Set var 'win_char'
                                  ) ;; End 'then'
                                  (else ;; 'else' block
                                    ;; == If Condition ==
                                    (global.get $var29)  ;; Global variable 'win_id'
                                    (i32.const 8)  ;; Literal value
                                    (i32.eq)
                                    (if ;; Execute code based on result of condition.
                                      (then ;; 'then' block
                                        ;; Call function 'Line'
                                        (i32.const 20)  ;; Literal value
                                        (i32.const 580)  ;; Literal value
                                        (i32.const 580)  ;; Literal value
                                        (i32.const 20)  ;; Literal value
                                        (call $drawLine) ;; Call function Line
                                        ;; Calculate RHS for assignment.
                                        (global.get $var26)  ;; Global variable 'board'
                                        (i32.const 2)  ;; Literal value
                                        (i32.add)
                                        (i32.load8_u)
                                        (local.set $var34)  ;; Set var 'win_char'
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
        ;; Calculate RHS for assignment.
        (i32.const 50)  ;; String literal at memory position 50
        (local.get $var34)  ;; Variable 'win_char'
        (call $_add_char)  ;; String + Int
        (call $_str_copy)  ;; Copy string to new memory location
        (local.set $var35)  ;; Set var 'win_label'
        ;; == If Condition ==
        (global.get $var29)  ;; Global variable 'win_id'
        (i32.const 9)  ;; Literal value
        (i32.eq)
        (if ;; Execute code based on result of condition.
          (then ;; 'then' block
            ;; Calculate RHS for assignment.
            (i32.const 59)  ;; String literal at memory position 59
            (call $_str_copy)  ;; Copy string to new memory location
            (local.set $var35)  ;; Set var 'win_label'
          ) ;; End 'then'
        ) ;; End 'if'
        ;; Call function 'FillColor'
        (i32.const 0)  ;; String literal at memory position 0
        (call $setFillColor) ;; Call function FillColor
        ;; Call function 'LineColor'
        (i32.const 28)  ;; String literal at memory position 28
        (call $setStrokeColor) ;; Call function LineColor
        ;; Call function 'LineWidth'
        (i32.const 5)  ;; Literal value
        (call $setLineWidth) ;; Call function LineWidth
        ;; Call function 'Rect'
        (i32.const 180)  ;; Literal value
        (i32.const 0)  ;; Literal value
        (i32.const 240)  ;; Literal value
        (i32.const 60)  ;; Literal value
        (call $drawRect) ;; Call function Rect
        ;; Call function 'FillColor'
        (i32.const 69)  ;; String literal at memory position 69
        (call $setFillColor) ;; Call function FillColor
        ;; Call function 'Text'
        (i32.const 190)  ;; Literal value
        (i32.const 10)  ;; Literal value
        (i32.const 50)  ;; Literal value
        (local.get $var35)  ;; Variable 'win_label'
        (call $drawText) ;; Call function Text
      ) ;; End 'then'
    ) ;; End 'if'
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun15 (param $var36 i32) (param $var37 i32) (result i32)
    (local $var38 i32) ;; Declare var 'col'
    (local $var39 i32) ;; Declare var 'row'
    ;; == If Condition ==
    (global.get $var29)  ;; Global variable 'win_id'
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == Generate return code ==
        (i32.const 1)  ;; Literal value
        (return)
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Calculate RHS for assignment.
    (local.get $var36)  ;; Variable 'x'
    (i32.const 200)  ;; Literal value
    (i32.div_s)
    (local.set $var38)  ;; Set var 'col'
    ;; Calculate RHS for assignment.
    (local.get $var37)  ;; Variable 'y'
    (i32.const 200)  ;; Literal value
    (i32.div_s)
    (local.set $var39)  ;; Set var 'row'
    ;; Calculate RHS for assignment.
    (local.get $var39)  ;; Variable 'row'
    (i32.const 3)  ;; Literal value
    (i32.mul)
    (local.get $var38)  ;; Variable 'col'
    (i32.add)
    (global.set $var27)  ;; Set global var 'mouse_id'
    ;; == If Condition ==
    (global.get $var26)  ;; Global variable 'board'
    (global.get $var27)  ;; Global variable 'mouse_id'
    (i32.add)
    (i32.load8_u)
    (i32.const 45)  ;; Literal value
    (i32.eq)
    (if ;; Execute code based on result of condition.
      (then ;; 'then' block
        ;; == If Condition ==
        (global.get $var28)  ;; Global variable 'turn'
        (i32.const 88)  ;; Literal value
        (i32.eq)
        (if ;; Execute code based on result of condition.
          (then ;; 'then' block
            ;; Calculate RHS for assignment.
            (i32.const 88)  ;; Literal value
            (global.get $var26)  ;; Global variable 'board'
            (global.get $var27)  ;; Global variable 'mouse_id'
            (i32.add)
            (call $_swap32)
            (i32.store8)
            ;; Calculate RHS for assignment.
            (i32.const 79)  ;; Literal value
            (global.set $var28)  ;; Set global var 'turn'
          ) ;; End 'then'
          (else ;; 'else' block
            ;; Calculate RHS for assignment.
            (i32.const 79)  ;; Literal value
            (global.get $var26)  ;; Global variable 'board'
            (global.get $var27)  ;; Global variable 'mouse_id'
            (i32.add)
            (call $_swap32)
            (i32.store8)
            ;; Calculate RHS for assignment.
            (i32.const 88)  ;; Literal value
            (global.set $var28)  ;; Set global var 'turn'
          ) ;; End 'else'
        ) ;; End 'if'
        ;; Calculate RHS for assignment.
        (global.get $var30)  ;; Global variable 'move_count'
        (i32.const 1)  ;; Literal value
        (i32.add)
        (global.set $var30)  ;; Set global var 'move_count'
        ;; Call function 'TestWin'
        (call $Fun13)  ;; Call 'TestWin'
        (drop) ;; Result not used.
      ) ;; End 'then'
    ) ;; End 'if'
    ;; Call function 'DrawBoard'
    (call $Fun14)  ;; Call 'DrawBoard'
    (drop) ;; Result not used.
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun16 (param $var40 i32) (param $var41 i32) (result i32)
    (local $var42 i32) ;; Declare var 'col'
    (local $var43 i32) ;; Declare var 'row'
    ;; Calculate RHS for assignment.
    (local.get $var40)  ;; Variable 'x'
    (i32.const 200)  ;; Literal value
    (i32.div_s)
    (local.set $var42)  ;; Set var 'col'
    ;; Calculate RHS for assignment.
    (local.get $var41)  ;; Variable 'y'
    (i32.const 200)  ;; Literal value
    (i32.div_s)
    (local.set $var43)  ;; Set var 'row'
    ;; Calculate RHS for assignment.
    (local.get $var43)  ;; Variable 'row'
    (i32.const 3)  ;; Literal value
    (i32.mul)
    (local.get $var42)  ;; Variable 'col'
    (i32.add)
    (global.set $var27)  ;; Set global var 'mouse_id'
    ;; Call function 'DrawBoard'
    (call $Fun14)  ;; Call 'DrawBoard'
    (drop) ;; Result not used.
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )
  (func $Fun17 (result i32)
    ;; Call function 'SetTitle'
    (i32.const 76)  ;; String literal at memory position 76
    (call $setTitle) ;; Call function SetTitle
    ;; Call function 'DrawBoard'
    (call $Fun14)  ;; Call 'DrawBoard'
    (drop) ;; Result not used.
    ;; Call function 'AddClickFun'
    (i32.const 113)  ;; String literal at memory position 113
    (call $addClickFun) ;; Call function AddClickFun
    ;; Call function 'AddMoveFun'
    (i32.const 124)  ;; String literal at memory position 124
    (call $addMoveFun) ;; Call function AddMoveFun
    ;; == Generate return code ==
    (i32.const 0)  ;; Literal value
    (return)
  )

  (func $Init
    ;; Initialize global 'board'
    (i32.const 134)  ;; String literal at memory position 134
    (global.set $var26)
    ;; Initialize global 'mouse_id'
    (i32.const 0)       ;; Setup negation
    (i32.const 1)  ;; Literal value
    (i32.sub)           ;; Negate value
    (global.set $var27)
    ;; Initialize global 'turn'
    (i32.const 88)  ;; Literal value
    (global.set $var28)
    ;; Initialize global 'win_id'
    (i32.const 0)  ;; Literal value
    (global.set $var29)
    ;; Initialize global 'move_count'
    (i32.const 0)  ;; Literal value
    (global.set $var30)
  )
  (start $Init)

  (export "TestWin" (func $Fun13))
  (export "DrawBoard" (func $Fun14))
  (export "MouseClick" (func $Fun15))
  (export "MouseMove" (func $Fun16))
  (export "Main" (func $Fun17))
) ;; End module
