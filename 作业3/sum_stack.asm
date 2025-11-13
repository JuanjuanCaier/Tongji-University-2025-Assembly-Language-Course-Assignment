.model small
.stack 100h

; 使用栈存结果

.data
    result_msg db '1+2+3+...+100 = $'

.code
    START:         
                   mov  ax, @data
                   mov  ds, ax
    
    ; 计算1+2+3+...+100的和
                   mov  cx, 1             ; 计数器初始化为1
                   mov  bx, 0             ; 累加器初始化为0
    
    sum_loop:      
                   cmp  cx, 100           ; 比较计数器与100
                   jg   store_result      ; 如果计数器大于100，跳转到结果存储
    
                   add  bx, cx            ; 将计数器值加到累加器
                   inc  cx                ; 计数器递增
                   jmp  sum_loop          ; 跳转回循环开始
    
    store_result:  
                   push bx                ; 将结果存储到栈中
    
    display_result:
    ; 显示结果消息
                   mov  ah, 09h           ; DOS功能号：显示字符串
                   lea  dx, result_msg    ; 加载结果消息地址
                   int  21h               ; 调用DOS中断
    
    ; 将结果(栈中的值)转换为十进制并显示
                   pop  ax                ; 从栈中取出结果到AX
                   push ax                ; 再次压入栈
               
    ; 分解结果为千位、百位、十位、个位
    
    ; 提取千位数字
                   mov  bx, 1000
                   mov  dx, 0             ; 清除DX，为除法做准备
                   div  bx                ; AX除以1000，商在AL，余数在DX
                   push dx                ; 保存余数到栈
                   add  al, '0'           ; 转换为ASCII字符
                   mov  dl, al            ; 准备显示
                   mov  ah, 02h           ; DOS功能号：显示字符
                   int  21h               ; 调用DOS中断
               
    ; 提取百位数字
                   pop  dx                ; 恢复余数
                   mov  ax, dx            ; 余数放入AX
                   mov  bx, 100
                   mov  dx, 0             ; 清除DX，为除法做准备
                   div  bx                ; AX除以100
                   push dx                ; 保存余数到栈
                   add  al, '0'           ; 转换为ASCII字符
                   mov  dl, al            ; 准备显示
                   mov  ah, 02h           ; DOS功能号：显示字符
                   int  21h               ; 调用DOS中断
               
    ; 提取十位数字
                   pop  dx                ; 恢复余数
                   mov  ax, dx            ; 余数放入AX
                   mov  bx, 10
                   mov  dx, 0             ; 清除DX，为除法做准备
                   div  bx                ; AX除以10
                   push dx                ; 保存余数到栈
                   add  al, '0'           ; 转换为ASCII字符
                   mov  dl, al            ; 准备显示
                   mov  ah, 02h           ; DOS功能号：显示字符
                   int  21h               ; 调用DOS中断
               
    ; 提取个位数字
                   pop  dx                ; 恢复余数
                   mov  ax, dx            ; 余数放入AX
                   add  al, '0'           ; 转换为ASCII字符
                   mov  dl, al            ; 准备显示
                   mov  ah, 02h           ; DOS功能号：显示字符
                   int  21h               ; 调用DOS中断
    
    ; 程序退出（结果仍在栈顶）
                   mov  ax, 4C00h
                   int  21h

END START