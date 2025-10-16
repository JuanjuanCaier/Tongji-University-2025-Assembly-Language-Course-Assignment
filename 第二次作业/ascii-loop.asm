.model small
.stack 100h

.code
    START:     
               mov  ax, @data
               mov  ds, ax
               mov  bl, 'a'       ; 从字母'a'开始
               mov  dh, 2         ; 外层循环2次，存在这里
    
    outer_loop:
               mov  cl, 13        ; 内层循环，13次
    
    inner_loop:
    ; 打印当前字符
               mov  ah, 02h       ; DOS功能号：显示字符
               mov  dl, bl        ; 要显示的字符
               int  21h
    
    ; 打印空格
               mov  ah, 02h
               mov  dl, ' '       ; 空格字符
               int  21h
    
               inc  bl            ; 指向下一个字符
               loop inner_loop    ; 内层循环，打印13个字符
    
    ; 一行结束，打印换行
               mov  ah, 02h
               mov  dl, 0Dh       ; 回车符
               int  21h
               mov  dl, 0Ah       ; 换行符
               int  21h
    
               mov  cl,dh         ; 将dh赋值给cl
               dec  dh            ; 模拟递减
               loop outer_loop    ; 外层循环，打印2行
    
    ; 程序退出
               mov  ax, 4C00h
               int  21h

END START