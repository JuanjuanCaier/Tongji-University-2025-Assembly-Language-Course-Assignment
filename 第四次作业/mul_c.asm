.LC0:
        .string "The 9mul9 table:"      ; 字符串常量：乘法表标题

main:
        push    rbp                     ; 保存旧的基址指针
        mov     rbp, rsp                ; 设置新的基址指针
        sub     rsp, 16                 ; 在栈上分配16字节空间（用于局部变量）
        
        ; 输出标题字符串
        mov     esi, OFFSET FLAT:.LC0   ; ESI = 字符串地址（第二个参数）
        mov     edi, OFFSET FLAT:std::cout  ; EDI = cout对象地址（第一个参数）
        call    std::basic_ostream<char, std::char_traits<char>>& std::operator<<<std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&, char const*)
        
        ; 输出换行
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char>>& std::endl<char, std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&)
        mov     rdi, rax                ; RAX包含上一个cout调用的返回值
        call    std::ostream::operator<<(std::ostream& (*)(std::ostream&))
        
        ; 初始化外层循环变量 i = 9
        mov     DWORD PTR [rbp-4], 9    ; [rbp-4] 存储外层循环变量i（被乘数）
        jmp     .L2                     ; 跳转到外层循环条件检查

; 外层循环体
.L5:
        ; 初始化内层循环变量 j = 1
        mov     DWORD PTR [rbp-8], 1    ; [rbp-8] 存储内层循环变量j（乘数）
        jmp     .L3                     ; 跳转到内层循环条件检查

; 内层循环体
.L4:
        ; 输出被乘数 i
        mov     eax, DWORD PTR [rbp-4]  ; EAX = i
        mov     esi, eax                ; ESI = i（第二个参数）
        mov     edi, OFFSET FLAT:std::cout  ; EDI = cout（第一个参数）
        call    std::ostream::operator<<(int)  ; 输出整数
        
        ; 输出乘号 '*'
        mov     esi, 42                 ; 42是'*'的ASCII码
        mov     rdi, rax                ; RAX包含上一个cout调用的返回值
        call    std::basic_ostream<char, std::char_traits<char>>& std::operator<<<std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&, char)
        
        ; 输出乘数 j
        mov     rdx, rax                ; RDX = 当前输出流对象
        mov     eax, DWORD PTR [rbp-8]  ; EAX = j
        mov     esi, eax                ; ESI = j（第二个参数）
        mov     rdi, rdx                ; RDI = 输出流对象（第一个参数）
        call    std::ostream::operator<<(int)  ; 输出整数
        
        ; 输出等号 '='
        mov     esi, 61                 ; 61是'='的ASCII码
        mov     rdi, rax                ; RAX包含上一个cout调用的返回值
        call    std::basic_ostream<char, std::char_traits<char>>& std::operator<<<std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&, char)
        
        ; 计算并输出乘积 i * j
        mov     rdx, rax                ; RDX = 当前输出流对象
        mov     eax, DWORD PTR [rbp-4]  ; EAX = i
        imul    eax, DWORD PTR [rbp-8]  ; EAX = i * j
        mov     esi, eax                ; ESI = 乘积结果（第二个参数）
        mov     rdi, rdx                ; RDI = 输出流对象（第一个参数）
        call    std::ostream::operator<<(int)  ; 输出乘积
        
        ; 输出空格 ' '
        mov     esi, 32                 ; 32是空格的ASCII码
        mov     rdi, rax                ; RAX包含上一个cout调用的返回值
        call    std::basic_ostream<char, std::char_traits<char>>& std::operator<<<std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&, char)
        
        ; 内层循环变量 j++
        add     DWORD PTR [rbp-8], 1    ; j = j + 1

; 内层循环条件检查: j <= i
.L3:
        mov     eax, DWORD PTR [rbp-8]  ; EAX = j
        cmp     eax, DWORD PTR [rbp-4]  ; 比较 j 和 i
        jle     .L4                     ; 如果 j <= i，继续内层循环
        
        ; 输出换行（一行乘法表结束）
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char>>& std::endl<char, std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&)
        mov     edi, OFFSET FLAT:std::cout
        call    std::ostream::operator<<(std::ostream& (*)(std::ostream&))
        
        ; 外层循环变量 i--
        sub     DWORD PTR [rbp-4], 1    ; i = i - 1

; 外层循环条件检查: i > 0
.L2:
        cmp     DWORD PTR [rbp-4], 0    ; 比较 i 和 0
        jg      .L5                     ; 如果 i > 0，继续外层循环
        
        ; 程序结束，返回0
        mov     eax, 0                  ; 返回值 = 0
        leave                           ; 恢复栈帧（相当于 mov rsp, rbp; pop rbp）
        ret                             ; 返回