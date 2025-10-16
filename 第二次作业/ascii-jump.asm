.model small
.stack 100h

.code
    START:         
                   mov ax, @data
                   mov ds, ax
    
                   mov bl, 'a'           ; 从字母'a'开始
                   mov cx, 26            ; 总共26个小写字母
                   mov dh, 0             ; 计数器，记录当前行已打印的字符数
    
    print_jump:    
    ; 打印当前字符
                   mov ah, 02h           ; DOS功能号：显示字符
                   mov dl, bl            ; 要显示的字符
                   int 21h
    
    ; 打印空格
                   mov ah, 02h
                   mov dl, ' '           ; 空格字符
                   int 21h
    
                   inc bl                ; 指向下一个字符
                   inc dh                ; 行计数器加1
                   dec cx                ; 总计数器减1
    
    ; 检查是否需要换行（每行13个字符）
                   cmp dh, 13
                   jne check_finished    ; 如果不相等
    
    ; 打印换行（使用字符显示功能）
                   mov ah, 02h
                   mov dl, 0Dh           ; 回车符
                   int 21h
                   mov dl, 0Ah           ; 换行符
                   int 21h
    
                   mov dh, 0             ; 重置行计数器
    
    check_finished:
    ; 检查是否所有字符都已打印
                   cmp cx, 0
                   jg  print_jump        ; 如果cx比0大，继续打印
    
    ; 程序退出
                   mov ax, 4C00h
                   int 21h

END START