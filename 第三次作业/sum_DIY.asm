.model small
.stack 100h

; 用户输入1~100的一个数字，程序计算并输出从1到该数字的十进制和

.data
    input_msg   db 'Please enter a number (1-100): $'           ; 输入提示信息
    error_msg   db 0Dh, 0Ah, 'Input out of range!', 0Dh, 0Ah    ; 错误信息
    result_msg1 db 0Dh, 0Ah, 'The sum from 1 to $'              ; 结果信息前半部分
    result_msg2 db ' is: $'                                     ; 结果信息后半部分
    newline     db 0Dh, 0Ah, '$'                                ; 换行符
    num_value   dw 0                                            ; 存储用户输入的数值
    sum_result  dw 0                                            ; 存储累加结果的变量

.code
    START:         
                   mov  ax, @data
                   mov  ds, ax

    get_input:     
    ; 显示输入提示
                   mov  ah, 09h            ; DOS功能号：显示字符串
                   lea  dx, input_msg      ; 加载输入提示信息地址
                   int  21h                ; 调用DOS中断

    ; 调用读取数字函数
                   call READ_NUM
                   mov  num_value, ax      ; 保存输入的数字

    ; 检查数值是否在1到100范围内
                   cmp  num_value, 1       ; 比较数值与1
                   jl   show_error         ; 如果小于1，显示错误
                   cmp  num_value, 100     ; 比较数值与100
                   jg   show_error         ; 如果大于100，显示错误

    ; 计算从1到num_value的累加和
                   mov  sum_result, 0      ; 累加结果初始化为0
                   mov  cx, 1              ; 计数器初始化为1

    sum_loop:      
                   cmp  cx, num_value      ; 比较计数器与用户输入的数值
                   jg   display_result     ; 如果计数器大于用户输入值，跳转到结果显示
    
                   add  sum_result, cx     ; 将计数器值加到累加器
                   inc  cx                 ; 计数器递增
                   jmp  sum_loop           ; 跳转回循环开始

    display_result:
    ; 显示结果消息第一部分
                   mov  ah, 09h            ; DOS功能号：显示字符串
                   lea  dx, result_msg1    ; 加载结果消息前半部分地址
                   int  21h                ; 调用DOS中断
    
    ; 显示用户输入的数字
                   mov  ax, num_value      ; 将用户输入的数字加载到AX
                   call PRINT_DECIMAL      ; 调用子程序打印十进制数
    
    ; 显示结果消息第二部分
                   mov  ah, 09h            ; DOS功能号：显示字符串
                   lea  dx, result_msg2    ; 加载结果消息后半部分地址
                   int  21h                ; 调用DOS中断
    
    ; 显示计算得到的和
                   mov  ax, sum_result     ; 将结果加载到AX
                   call PRINT_DECIMAL      ; 调用子程序打印十进制数
    
    ; 打印换行
                   mov  ah, 09h            ; DOS功能号：显示字符串
                   lea  dx, newline        ; 加载换行符地址
                   int  21h                ; 调用DOS中断
    
    ; 程序退出
                   mov  ax, 4C00h          ; DOS功能号：程序终止
                   int  21h                ; 调用DOS中断

    show_error:    
    ; 显示错误信息
                   mov  ah, 09h            ; DOS功能号：显示字符串
                   lea  dx, error_msg      ; 加载错误信息地址
                   int  21h                ; 调用DOS中断
                   jmp  get_input          ; 重新要求用户输入

    ; =============================================
    ; 读取正整数输入函数
    ; 输出：AX = 读取的数值
    ; =============================================
READ_NUM PROC
                   PUSH BX                 ; 保存寄存器
                   PUSH CX
                   PUSH DX
    
                   MOV  AX, 0              ; 初始化AX为0
                   PUSH AX                 ; 将初始值0压栈，用于存储输入的数字
    
    READ_LOOP:     
    ; 读取单个字符到AL
                   MOV  AH, 01h
                   INT  21h
    
    ; 检查是否为回车（结束输入）
                   CMP  AL, 0Dh
                   JE   END_READ
    
    ; 检查字符是否在'0'到'9'之间
                   CMP  AL, '0'
                   JB   READ_LOOP
                   CMP  AL, '9'
                   JA   READ_LOOP
    
    ; 将ASCII字符转换为数字
                   SUB  AL, '0'            ; AL = AL - '0'，得到数字值
                   MOV  CL, AL
                   MOV  CH, 0
                   POP  AX                 ; 取出当前累计值
                   MOV  BX, 10
                   MUL  BX                 ; AX = AX * 10
                   ADD  AX, CX             ; 加上新输入的数字
                   PUSH AX                 ; 将新的累计值压栈
                   JMP  READ_LOOP          ; 继续读取下一个字符

    END_READ:      
                   POP  AX                 ; 将最终结果弹出到AX
                   POP  DX                 ; 恢复寄存器
                   POP  CX
                   POP  BX
                   RET
READ_NUM ENDP

    ; =============================================
    ; 打印十进制数的函数
    ; 输入：AX = 要打印的数字
    ; =============================================
PRINT_DECIMAL PROC
                   mov  cx, 0              ; 计数器清零
                   mov  bx, 10             ; 除数设为10
    
                   cmp  ax, 0              ; 检查是否为0
                   jne  pd_loop            ; 如果不是0，进入循环
    
    ; 特殊处理0的情况
                   mov  dl, '0'            ; 显示字符'0'
                   mov  ah, 02h            ; DOS功能号：显示字符
                   int  21h                ; 调用DOS中断
                   ret                     ; 返回调用者
    
    pd_loop:       
                   mov  dx, 0              ; 清空DX，为除法做准备
                   div  bx                 ; AX除以10，商在AX，余数在DX
                   push dx                 ; 将余数压入栈
                   inc  cx                 ; 增加计数器
                   cmp  ax, 0              ; 比较商是否为0
                   jne  pd_loop            ; 如果商不为0，继续循环
    
    pd_print:      
                   pop  dx                 ; 从栈中弹出数字
                   add  dl, '0'            ; 转换为ASCII字符
                   mov  ah, 02h            ; DOS功能号：显示字符
                   int  21h                ; 调用DOS中断
                   loop pd_print           ; 使用LOOP指令控制循环
    
                   ret                     ; 返回调用者
PRINT_DECIMAL ENDP

END START