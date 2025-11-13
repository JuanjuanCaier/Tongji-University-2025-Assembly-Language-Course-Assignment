.model small
.stack 100h

.data
    title_msg  db 'The 9mul9 table:', 0dh, 0ah, '$'
    space      db ' $'
    newline    db 0dh, 0ah, '$'
    mul_sign   db '*$'
    equal_sign db '=$'
    num_buffer db 3 dup(' '), '$'                      ; 用于存储数字字符串的缓冲区

.code

    ; 主程序
main proc
                     mov  ax, @data
                     mov  ds, ax
    
    ; 输出标题
                     call print_title
    
    ; 初始化外层循环计数器（行数，从9到1）
                     mov  bl, 9                    ; 外层循环计数器（被乘数）
    
    outer_loop:      
    ; 初始化内层循环计数器（列数，从1到当前行数）
                     mov  bh, 1                    ; 内层循环计数器（乘数）
    
    inner_loop:      
    ; 输出被乘数
                     mov  al, bl                   ; 直接使用AL获取被乘数
                     mov  ah, 0                    ; 清空AH，确保AX=BL
                     call print_number
    
    ; 输出乘号
                     call print_mul_sign
    
    ; 输出乘数
                     mov  al, bh                   ; 直接使用AL获取乘数
                     mov  ah, 0                    ; 清空AH，确保AX=BH
                     call print_number
    
    ; 输出等号
                     call print_equal_sign
    
    ; 计算乘法 bl * bh
                     mov  al, bl                   ; 被乘数
                     mov  cl, bh                   ; 乘数
                     call multiply
    
    ; 输出乘法结果
                     call print_number
    
    ; 输出空格（如果不是最后一个）
                     mov  al, bh
                     cmp  al, bl                   ; 比较乘数和被乘数
                     jge  no_space                 ; 如果乘数 >= 被乘数，不输出空格
    
                     call print_space
    
    no_space:        
    ; 内层循环控制
                     inc  bh
                     cmp  bh, bl
                     jle  inner_loop               ; 乘数 <= 被乘数时继续
    
    ; 输出换行
                     call print_newline
    
    ; 外层循环控制
                     dec  bl
                     cmp  bl, 0
                     jg   outer_loop               ; 被乘数 > 0时继续
    
    ; 程序结束
                     mov  ah, 4ch
                     int  21h
main endp

    ; 乘法函数
    ; 输入: al = 被乘数, cl = 乘数
    ; 输出: ax = 乘积
multiply proc
                     push bx
                     mov  bl, cl
                     mul  bl                       ; al * bl = ax
                     pop  bx
                     ret
multiply endp

    ; 输出数字函数
    ; 输入: ax = 要输出的数字
print_number proc
                     push ax
                     push bx
                     push cx
                     push dx
                     push si
    
    ; 将数字转换为字符串
                     mov  si, offset num_buffer
                     call number_to_string
    
    ; 输出字符串
                     mov  dx, offset num_buffer
                     mov  ah, 9
                     int  21h
    
                     pop  si
                     pop  dx
                     pop  cx
                     pop  bx
                     pop  ax
                     ret
print_number endp

    ; 数字转字符串函数
    ; 输入: ax = 数字, si = 缓冲区地址
number_to_string proc
                     push ax
                     push bx
                     push cx
                     push dx
                     push si
    
    ; 清空缓冲区
                     mov  byte ptr [si], ' '
                     mov  byte ptr [si+1], ' '
                     mov  byte ptr [si+2], ' '
    
    ; 处理数字
                     mov  bx, 10
                     mov  cx, 0
    
    ; 特殊情况：数字为0
                     cmp  ax, 0
                     jnz  convert_loop
                     mov  byte ptr [si], '0'
                     jmp  end_convert
    
    convert_loop:    
                     xor  dx, dx
                     div  bx                       ; ax / 10, dx = 余数
                     push dx                       ; 保存余数
                     inc  cx
                     cmp  ax, 0
                     jnz  convert_loop
    
    ; 将数字转换为ASCII码
    output_loop:     
                     pop  ax
                     add  al, '0'                  ; 转换为ASCII
                     mov  [si], al
                     inc  si
                     loop output_loop
    
    end_convert:     
    ; 添加结束符
                     mov  byte ptr [si], '$'
    
                     pop  si
                     pop  dx
                     pop  cx
                     pop  bx
                     pop  ax
                     ret
number_to_string endp

    ; 输出乘号函数
print_mul_sign proc
                     push ax
                     push dx
    
                     mov  dx, offset mul_sign
                     mov  ah, 9
                     int  21h
    
                     pop  dx
                     pop  ax
                     ret
print_mul_sign endp

    ; 输出等号函数
print_equal_sign proc
                     push ax
                     push dx
    
                     mov  dx, offset equal_sign
                     mov  ah, 9
                     int  21h
    
                     pop  dx
                     pop  ax
                     ret
print_equal_sign endp

    ; 输出空格函数
print_space proc
                     push ax
                     push dx
    
                     mov  dx, offset space
                     mov  ah, 9
                     int  21h
    
                     pop  dx
                     pop  ax
                     ret
print_space endp

    ; 输出换行函数
print_newline proc
                     push ax
                     push dx
    
                     mov  dx, offset newline
                     mov  ah, 9
                     int  21h
    
                     pop  dx
                     pop  ax
                     ret
print_newline endp

    ; 输出标题函数
print_title proc
                     push ax
                     push dx
    
                     mov  dx, offset title_msg
                     mov  ah, 9
                     int  21h
    
                     pop  dx
                     pop  ax
                     ret
print_title endp

end main