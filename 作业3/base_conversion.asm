.model small
.stack 100h

; 用户输入16进制的数字（不超过0x64），输出10进制数字

.data
    input_msg    db 'Please enter a hexadecimal number (a-f, 1-64 in hex): $'
    error_msg    db 0Dh, 0Ah, 'Input out of range, please try again!', 0Dh, 0Ah, '$'
    result_msg   db 0Dh, 0Ah, 'The decimal equivalent is: $'
    newline      db 0Dh, 0Ah, '$'
    input_buffer db 10, ?, 10 dup(?)
    hex_first    db 0                                                                   ; 存储十六进制数的第一位
    hex_second   db 0                                                                   ; 存储十六进制数的第二位
    hex_value    dw 0                                                                   ; 存储转换后的十六进制数值

.code
    START:          
                    mov  ax, @data
                    mov  ds, ax
    
    get_input:      
    ; 显示输入提示
                    mov  ah, 09h
                    lea  dx, input_msg
                    int  21h
    
    ; 读取用户输入
                    mov  ah, 0Ah
                    lea  dx, input_buffer
                    int  21h
    
    ; 解析输入的十六进制字符串
                    lea  si, input_buffer    ; 获取input_buffer的地址
                    mov  bl, [si+1]          ; 获取实际输入字符数
                    cmp  bl, 0               ; 检查是否有输入
                    je   get_input           ; 如果没有输入，重新输入
                    cmp  bl, 2               ; 检查是否超过两位
                    jg   show_error          ; 如果超过两位，显示错误
    
    ; 初始化变量
                    mov  [hex_first], 0
                    mov  [hex_second], 0
    
    ; 存储十六进制数字的每一位
                    mov  al, [si+2]          ; 获取第一个字符
                    cmp  bl, 1               ; 检查是否只有一个字符
                    je   single_digit        ; 如果只有一个字符，跳转到single_digit
    ; 有两个字符的情况
                    mov  [hex_first], al     ; 存储第一位
                    mov  al, [si+3]          ; 获取第二个字符
                    mov  [hex_second], al    ; 存储第二位
                    jmp  convert_hex         ; 转换十六进制数
    
    single_digit:   
                    mov  [hex_second], al    ; 将单个字符存储到hex_second
    
    convert_hex:    
    ; 转换第一位十六进制数字
                    mov  al, [hex_first]
                    call hex_char_to_dec
                    mov  [hex_first], al     ; 存储转换后的数值
    
    ; 转换第二位十六进制数字
                    mov  al, [hex_second]
                    call hex_char_to_dec
                    mov  [hex_second], al    ; 存储转换后的数值
    
    ; 计算最终的十六进制数值 (first * 16 + second)
                    mov  al, [hex_first]
                    mov  ah, 0
                    mov  bl, 16
                    mul  bl                  ; AX = AL * 16
                    mov  bl, [hex_second]
                    mov  bh, 0
                    add  ax, bx              ; AX = AX + second
                    mov  [hex_value], ax     ; 存储到hex_value
    
    ; 检查数值是否在1到100范围内（十六进制1-64即十进制1-100）
                    cmp  ax, 1
                    jl   show_error          ; 如果小于1，显示错误
                    cmp  ax, 100
                    jg   show_error          ; 如果大于100，显示错误
    
    ; 显示结果消息
                    mov  ah, 09h
                    lea  dx, result_msg
                    int  21h
    
    ; 将结果转换为十进制字符串并显示
                    mov  ax, [hex_value]     ; 恢复结果到AX
                    call print_decimal       ; 调用子程序打印十进制数
    
    ; 打印换行
                    mov  ah, 09h
                    lea  dx, newline
                    int  21h
    
    ; 程序退出
                    mov  ax, 4C00h
                    int  21h
    
    show_error:     
    ; 显示错误信息
                    mov  ah, 09h
                    lea  dx, error_msg
                    int  21h
                    jmp  get_input           ; 重新要求用户输入
    
    ; 将十六进制字符转换为十进制数值的子程序
    hex_char_to_dec:
                    cmp  al, '0'
                    jl   htd_error
                    cmp  al, '9'
                    jle  htd_digit           ; 处理数字0-9
                    cmp  al, 'a'
                    jl   htd_error
                    cmp  al, 'f'
                    jg   htd_error
    ; 处理字母a-f
                    sub  al, 'a' - 10
                    ret
    
    htd_digit:      
                    sub  al, '0'
                    ret
    
    htd_error:      
                    mov  al, 0
                    ret
    
    ; 打印十进制数的子程序
    print_decimal:  
                    mov  cx, 0               ; 计数器清零
                    mov  bx, 10
    
    pd_loop:        
                    mov  dx, 0
                    div  bx
                    push dx                  ; 将余数压入栈
                    inc  cx                  ; 增加计数器
                    cmp  ax, 0
                    jne  pd_loop             ; 如果商不为0，继续循环
    
    pd_print:       
                    pop  dx                  ; 从栈中弹出数字
                    add  dl, '0'             ; 转换为ASCII字符
                    mov  ah, 02h
                    int  21h
                    loop pd_print            ; 使用LOOP指令控制循环
    
                    ret

END START