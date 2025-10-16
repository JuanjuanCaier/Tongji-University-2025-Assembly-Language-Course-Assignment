.model small
.stack 100h

.code
    START:

    ;int main() {
          push  rbp                                              ; 保存基址指针
          push  rdi                                              ; 保存rdi寄存器（可能用于调试）
          sub   rsp,148h                                         ; 在栈上分配148h字节空间给局部变量
          lea   rbp,[rsp+20h]                                    ; 设置新的基址指针（帧指针）
          lea   rcx,[__1DEAC8A1_ascii-C@c (07FF65DB32008h)]      ; 加载调试符号地址
          call  __CheckForDebuggerJustMyCode (07FF65DB2136Bh)    ; 调试器检查函数
          nop                                                    ; 空操作，用于对齐

    ;char Ch = 'a';
          mov   byte ptr [Ch],61h                                ; 将字符'a'（ASCII 61h）存入Ch变量

    ;for (int i = 0; i < 2; i++) {
          mov   dword ptr [rbp+24h],0                            ; 初始化循环计数器i=0
          jmp   main+31h (07FF65DB218C1h)                        ; 跳转到循环条件检查

    ; 循环递增部分（标签在跳转目标处）
          mov   eax,dword ptr [rbp+24h]                          ; 加载i的值到eax
          inc   eax                                              ; i++
          mov   dword ptr [rbp+24h],eax                          ; 将递增后的值存回i
          cmp   dword ptr [rbp+24h],2                            ; 比较i与2
          jge   main+7Bh (07FF65DB2190Bh)                        ; 如果i >= 2，跳出外层循环

    ;for (int j = 0; j < 13; j++) {
          mov   dword ptr [rbp+44h],0                            ; 初始化内层循环计数器j=0
          jmp   main+48h (07FF65DB218D8h)                        ; 跳转到内层循环条件检查

    ; 内层循环递增部分
          mov   eax,dword ptr [rbp+44h]                          ; 加载j的值到eax
          inc   eax                                              ; j++
          mov   dword ptr [rbp+44h],eax                          ; 将递增后的值存回j
          cmp   dword ptr [rbp+44h],0Dh                          ; 比较j与13（0Dh）
          jge   main+6Ch (07FF65DB218FCh)                        ; 如果j >= 13，跳出内层循环

    ;printf("%c ", Ch);
          movsx eax,byte ptr [Ch]                                ; 将Ch字符符号扩展为32位整数
          mov   edx,eax                                          ; 将字符作为第二个参数传递给printf
          lea   rcx,[string "%c " (07FF65DB2AC24h)]              ; 加载格式字符串地址作为第一个参数
          call  printf (07FF65DB21195h)                          ; 调用printf函数
          nop                                                    ; 空操作

    ;Ch++;
          movzx eax,byte ptr [Ch]                                ; 将Ch字符零扩展为32位整数
          inc   al                                               ; 字符值加1
          mov   byte ptr [Ch],al                                 ; 将递增后的字符存回Ch

    ;}
          jmp   main+40h (07FF65DB218D0h)                        ; 跳回内层循环递增部分

    ;printf("\n");
          lea   rcx,[string "\n" (07FF65DB2AC28h)]               ; 加载换行符字符串地址
          call  printf (07FF65DB21195h)                          ; 调用printf打印换行
          nop

    ;}
          jmp   main+29h (07FF65DB218B9h)                        ; 跳回外层循环递增部分

    ;return 0;
          xor   eax,eax                                          ; 将eax清零，作为返回值0

    ;}
          lea   rsp,[rbp+128h]                                   ; 恢复栈指针（清理栈空间）
          pop   rdi                                              ; 恢复rdi寄存器
          pop   rbp                                              ; 恢复基址指针
          ret                                                    ; 从函数返回

END START