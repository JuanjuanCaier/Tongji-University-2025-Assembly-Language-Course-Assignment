; 乘法表数据段 - 使用.long定义32位整数数组
multiplicationTable:
        .long   7   ; [0][0] 1*1应该是1，但表中是7
        .long   2   ; [0][1] 1*2=2 ✓
        .long   3   ; [0][2] 1*3=3 ✓
        .long   4   ; [0][3] 1*4=4 ✓
        .long   5   ; [0][4] 1*5=5 ✓
        .long   6   ; [0][5] 1*6=6 ✓
        .long   7   ; [0][6] 1*7=7 ✓
        .long   8   ; [0][7] 1*8=8 ✓
        .long   9   ; [0][8] 1*9=9 ✓
        .long   2   ; [1][0] 2*1=2 ✓
        .long   4   ; [1][1] 2*2=4 ✓
        .long   7   ; [1][2] 2*3应该是6，但表中是7
        .long   8   ; [1][3] 2*4=8 ✓
        .long   10  ; [1][4] 2*5=10 ✓
        .long   12  ; [1][5] 2*6=12 ✓
        .long   14  ; [1][6] 2*7=14 ✓
        .long   16  ; [1][7] 2*8=16 ✓
        .long   18  ; [1][8] 2*9=18 ✓
        .long   3   ; [2][0] 3*1=3 ✓
        .long   6   ; [2][1] 3*2=6 ✓
        .long   9   ; [2][2] 3*3=9 ✓
        .long   12  ; [2][3] 3*4=12 ✓
        .long   15  ; [2][4] 3*5=15 ✓
        .long   18  ; [2][5] 3*6=18 ✓
        .long   21  ; [2][6] 3*7=21 ✓
        .long   24  ; [2][7] 3*8=24 ✓
        .long   27  ; [2][8] 3*9=27 ✓
        .long   4   ; [3][0] 4*1=4 ✓
        .long   8   ; [3][1] 4*2=8 ✓
        .long   12  ; [3][2] 4*3=12 ✓
        .long   16  ; [3][3] 4*4=16 ✓
        .long   7   ; [3][4] 4*5应该是20，但表中是7
        .long   24  ; [3][5] 4*6=24 ✓
        .long   28  ; [3][6] 4*7=28 ✓
        .long   32  ; [3][7] 4*8=32 ✓
        .long   36  ; [3][8] 4*9=36 ✓
        .long   5   ; [4][0] 5*1=5 ✓
        .long   10  ; [4][1] 5*2=10 ✓
        .long   15  ; [4][2] 5*3=15 ✓
        .long   20  ; [4][3] 5*4=20 ✓
        .long   25  ; [4][4] 5*5=25 ✓
        .long   30  ; [4][5] 5*6=30 ✓
        .long   35  ; [4][6] 5*7=35 ✓
        .long   40  ; [4][7] 5*8=40 ✓
        .long   45  ; [4][8] 5*9=45 ✓
        .long   6   ; [5][0] 6*1=6 ✓
        .long   12  ; [5][1] 6*2=12 ✓
        .long   18  ; [5][2] 6*3=18 ✓
        .long   24  ; [5][3] 6*4=24 ✓
        .long   30  ; [5][4] 6*5=30 ✓
        .long   7   ; [5][5] 6*6应该是36，但表中是7
        .long   42  ; [5][6] 6*7=42 ✓
        .long   48  ; [5][7] 6*8=48 ✓
        .long   54  ; [5][8] 6*9=54 ✓
        .long   7   ; [6][0] 7*1=7 ✓
        .long   14  ; [6][1] 7*2=14 ✓
        .long   21  ; [6][2] 7*3=21 ✓
        .long   28  ; [6][3] 7*4=28 ✓
        .long   35  ; [6][4] 7*5=35 ✓
        .long   42  ; [6][5] 7*6=42 ✓
        .long   49  ; [6][6] 7*7=49 ✓
        .long   56  ; [6][7] 7*8=56 ✓
        .long   63  ; [6][8] 7*9=63 ✓
        .long   8   ; [7][0] 8*1=8 ✓
        .long   16  ; [7][1] 8*2=16 ✓
        .long   24  ; [7][2] 8*3=24 ✓
        .long   32  ; [7][3] 8*4=32 ✓
        .long   40  ; [7][4] 8*5=40 ✓
        .long   48  ; [7][5] 8*6=48 ✓
        .long   56  ; [7][6] 8*7=56 ✓
        .long   7   ; [7][7] 8*8应该是64，但表中是7
        .long   72  ; [7][8] 8*9=72 ✓
        .long   9   ; [8][0] 9*1=9 ✓
        .long   18  ; [8][1] 9*2=18 ✓
        .long   27  ; [8][2] 9*3=27 ✓
        .long   36  ; [8][3] 9*4=36 ✓
        .long   45  ; [8][4] 9*5=45 ✓
        .long   54  ; [8][5] 9*6=54 ✓
        .long   63  ; [8][6] 9*7=63 ✓
        .long   72  ; [8][7] 9*8=72 ✓
        .long   81  ; [8][8] 9*9=81 ✓

; 字符串常量
.LC0:
        .string " "                    ; 空格字符串
.LC1:
        .string "    error"            ; 错误信息字符串

; checkTable() 函数 - 检查乘法表的正确性
checkTable():
        push    rbp                    ; 保存旧的基址指针
        mov     rbp, rsp               ; 设置新的基址指针
        sub     rsp, 16                ; 在栈上分配16字节空间
        
        ; 初始化外层循环变量 i = 1
        mov     DWORD PTR [rbp-4], 1   ; [rbp-4] 存储外层循环变量i（行号）
        jmp     .L2                    ; 跳转到外层循环条件检查

; 外层循环体
.L6:
        ; 初始化内层循环变量 j = 1
        mov     DWORD PTR [rbp-8], 1   ; [rbp-8] 存储内层循环变量j（列号）
        jmp     .L3                    ; 跳转到内层循环条件检查

; 内层循环体
.L5:
        ; 计算数组索引：table[i-1][j-1]
        mov     eax, DWORD PTR [rbp-4] ; EAX = i
        lea     edx, [rax-1]           ; EDX = i-1（行索引）
        mov     eax, DWORD PTR [rbp-8] ; EAX = j
        sub     eax, 1                 ; EAX = j-1（列索引）
        
        ; 计算一维数组偏移量：offset = (i-1)*9 + (j-1)
        movsx   rcx, eax               ; RCX = j-1（符号扩展）
        movsx   rdx, edx               ; RDX = i-1（符号扩展）
        mov     rax, rdx               ; RAX = i-1
        sal     rax, 3                 ; RAX = (i-1)*8（左移3位相当于乘以8）
        add     rax, rdx               ; RAX = (i-1)*8 + (i-1) = (i-1)*9
        add     rax, rcx               ; RAX = (i-1)*9 + (j-1) = 总偏移量
        
        ; 获取表中的值 table[i-1][j-1]
        mov     eax, DWORD PTR multiplicationTable[0+rax*4] ; EAX = table[i-1][j-1]
        mov     DWORD PTR [rbp-12], eax ; [rbp-12] 存储表中的值
        
        ; 计算正确的乘积值 i * j
        mov     eax, DWORD PTR [rbp-4] ; EAX = i
        imul    eax, DWORD PTR [rbp-8] ; EAX = i * j
        mov     DWORD PTR [rbp-16], eax ; [rbp-16] 存储计算值
        
        ; 比较表中的值和计算值
        mov     eax, DWORD PTR [rbp-12] ; EAX = 表中的值
        cmp     eax, DWORD PTR [rbp-16] ; 比较两个值
        je      .L4                     ; 如果相等，跳过错误输出
        
        ; 输出错误位置信息：格式为 "i j    error"
        ; 输出行号 i
        mov     eax, DWORD PTR [rbp-4] ; EAX = i
        mov     esi, eax               ; ESI = i（第二个参数）
        mov     edi, OFFSET FLAT:std::cout ; EDI = cout（第一个参数）
        call    std::ostream::operator<<(int) ; 输出整数
        
        ; 输出空格
        mov     esi, OFFSET FLAT:.LC0  ; ESI = " "（第二个参数）
        mov     rdi, rax               ; RDI = 当前输出流（第一个参数）
        call    std::basic_ostream<char, std::char_traits<char>>& std::operator<<<std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&, char const*)
        
        ; 输出列号 j
        mov     rdx, rax               ; RDX = 当前输出流
        mov     eax, DWORD PTR [rbp-8] ; EAX = j
        mov     esi, eax               ; ESI = j（第二个参数）
        mov     rdi, rdx               ; RDI = 输出流（第一个参数）
        call    std::ostream::operator<<(int) ; 输出整数
        
        ; 输出错误信息 "    error"
        mov     esi, OFFSET FLAT:.LC1  ; ESI = "    error"（第二个参数）
        mov     rdi, rax               ; RDI = 当前输出流（第一个参数）
        call    std::basic_ostream<char, std::char_traits<char>>& std::operator<<<std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&, char const*)
        
        ; 输出换行
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char>>& std::endl<char, std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&)
        mov     rdi, rax               ; RDI = 当前输出流
        call    std::ostream::operator<<(std::ostream& (*)(std::ostream&))

.L4:
        ; 内层循环变量 j++
        add     DWORD PTR [rbp-8], 1   ; j = j + 1

; 内层循环条件检查: j <= 9
.L3:
        cmp     DWORD PTR [rbp-8], 9   ; 比较 j 和 9
        jle     .L5                    ; 如果 j <= 9，继续内层循环
        
        ; 外层循环变量 i++
        add     DWORD PTR [rbp-4], 1   ; i = i + 1

; 外层循环条件检查: i <= 9
.L2:
        cmp     DWORD PTR [rbp-4], 9   ; 比较 i 和 9
        jle     .L6                    ; 如果 i <= 9，继续外层循环
        
        nop
        nop
        leave                          ; 恢复栈帧
        ret                            ; 返回

; 字符串常量
.LC2:
        .string "The 9x9 multiplication table check result:" ; 标题字符串
.LC3:
        .string "accomplish!"           ; 完成信息字符串

; main 函数
main:
        push    rbp                    ; 保存旧的基址指针
        mov     rbp, rsp               ; 设置新的基址指针
        
        ; 输出标题
        mov     esi, OFFSET FLAT:.LC2  ; ESI = 标题字符串
        mov     edi, OFFSET FLAT:std::cout ; EDI = cout
        call    std::basic_ostream<char, std::char_traits<char>>& std::operator<<<std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&, char const*)
        
        ; 输出换行
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char>>& std::endl<char, std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&)
        mov     rdi, rax               ; RDI = 当前输出流
        call    std::ostream::operator<<(std::ostream& (*)(std::ostream&))
        
        ; 调用检查函数
        call    checkTable()
        
        ; 输出完成信息
        mov     esi, OFFSET FLAT:.LC3  ; ESI = "accomplish!"
        mov     edi, OFFSET FLAT:std::cout ; EDI = cout
        call    std::basic_ostream<char, std::char_traits<char>>& std::operator<<<std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&, char const*)
        
        ; 输出换行
        mov     esi, OFFSET FLAT:std::basic_ostream<char, std::char_traits<char>>& std::endl<char, std::char_traits<char>>(std::basic_ostream<char, std::char_traits<char>>&)
        mov     rdi, rax               ; RDI = 当前输出流
        call    std::ostream::operator<<(std::ostream& (*)(std::ostream&))
        
        ; 返回0
        mov     eax, 0                 ; 返回值 = 0
        pop     rbp                    ; 恢复旧的基址指针
        ret                            ; 返回