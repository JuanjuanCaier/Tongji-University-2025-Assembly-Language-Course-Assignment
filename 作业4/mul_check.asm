.model small
.stack 100h

.data
    table          db 7,2,3,4,5,6,7,8,9               ; 9*9表数据
                   db 2,4,7,8,10,12,14,16,18
                   db 3,6,9,12,15,18,21,24,27
                   db 4,8,12,16,7,24,28,32,36
                   db 5,10,15,20,25,30,35,40,45
                   db 6,12,18,24,30,7,42,48,54
                   db 7,14,21,28,35,42,49,56,63
                   db 8,16,24,32,40,48,56,7,72
                   db 9,18,27,36,45,54,63,72,81
    
    error_msg      db ' error', 0dh, 0ah, '$'
    accomplish_msg db 'accomplish!', 0dh, 0ah, '$'
    space          db ' $'
    newline        db 0dh, 0ah, '$'
    num_buffer     db 3 dup(' '), '$'                 ; 数字输出缓冲区

.code

    ; 主程序
main proc
                         mov  ax, @data
                         mov  ds, ax
    
    ; 初始化行计数器
                         mov  bl, 1                        ; 行号（被乘数）
    
    row_loop:            
    ; 初始化列计数器
                         mov  bh, 1                        ; 列号（乘数）
    
    col_loop:            
    ; 计算当前元素在数组中的位置
                         call get_table_element
    
    ; 计算正确的乘积值
                         mov  al, bl                       ; 被乘数
                         mov  cl, bh                       ; 乘数
                         call multiply
    
    ; 比较计算值与表中值
                         call compare_values
    
    ; 列循环控制
                         inc  bh
                         cmp  bh, 10
                         jl   col_loop
    
    ; 行循环控制
                         inc  bl
                         cmp  bl, 10
                         jl   row_loop
    
    ; 输出完成信息
                         call print_accomplish
    
    ; 程序结束
                         mov  ah, 4ch
                         int  21h
main endp

    ; 获取表中元素函数
    ; 输入: bl = 行号, bh = 列号
    ; 输出: al = 表中的值
get_table_element proc
                         push bx
                         push cx
                         push dx
                         push si
    
    ; 计算偏移量 = (行号-1)*9 + (列号-1)
                         mov  al, bl
                         dec  al                           ; 行号-1
                         mov  cl, 9
                         mul  cl                           ; (行号-1)*9，结果在AX中
                         mov  dl, bh
                         dec  dl                           ; 列号-1
                         mov  dh, 0                        ; 清空DH，确保DX=DL
                         add  ax, dx                       ; 总偏移量在AX中
    
    ; 获取表中元素
                         mov  si, offset table
                         add  si, ax                       ; SI指向目标元素
                         mov  al, [si]                     ; 获取表中的值
    
                         pop  si
                         pop  dx
                         pop  cx
                         pop  bx
                         ret
get_table_element endp

    ; 乘法函数
    ; 输入: al = 被乘数, cl = 乘数
    ; 输出: ax = 乘积
multiply proc
                         push bx
                         mov  bl, cl
                         mul  bl                           ; al * bl = ax
                         pop  bx
                         ret
multiply endp

    ; 比较值函数
    ; 输入: bl = 行号, bh = 列号
compare_values proc
                         push ax
                         push bx
                         push cx
                         push dx
    
    ; 获取表中的值
                         call get_table_element            ; AL = 表中的值
                         mov  dl, al                       ; 保存表中的值到DL
    
    ; 计算正确的乘积值
                         mov  al, bl                       ; 被乘数
                         mov  cl, bh                       ; 乘数
                         call multiply                     ; AX = 计算值
    
    ; 比较两个值
                         cmp  dl, al
                         je   values_match                 ; 如果相等，跳过错误输出
    
    ; 输出错误位置信息
                         call print_error_position
    
    values_match:        
                         pop  dx
                         pop  cx
                         pop  bx
                         pop  ax
                         ret
compare_values endp

    ; 输出错误位置函数
    ; 输入: bl = 行号, bh = 列号
print_error_position proc
                         push ax
                         push bx
                         push cx
                         push dx
                         push si
    
    ; 输出行号
                         mov  al, bl                       ; 行号
                         mov  ah, 0                        ; 清空AH
                         call print_number
    
    ; 输出空格
                         call print_space
    
    ; 输出列号
                         mov  al, bh                       ; 列号
                         mov  ah, 0                        ; 清空AH
                         call print_number
    
    ; 输出错误信息
                         mov  dx, offset error_msg
                         mov  ah, 9
                         int  21h
    
                         pop  si
                         pop  dx
                         pop  cx
                         pop  bx
                         pop  ax
                         ret
print_error_position endp

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
                         div  bx                           ; ax / 10, dx = 余数
                         push dx                           ; 保存余数
                         inc  cx
                         cmp  ax, 0
                         jnz  convert_loop
    
    ; 将数字转换为ASCII码
    output_loop:         
                         pop  ax
                         add  al, '0'                      ; 转换为ASCII
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

    ; 输出完成信息函数
print_accomplish proc
                         push ax
                         push dx
    
                         mov  dx, offset accomplish_msg
                         mov  ah, 9
                         int  21h
    
                         pop  dx
                         pop  ax
                         ret
print_accomplish endp

end main