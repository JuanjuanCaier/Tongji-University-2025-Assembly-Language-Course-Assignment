.model small
.stack 100h

; C语言的反汇编的注释

.code
    START:

    ;int main() {
          push  rbp                                              ; 保存基址指针
          push  rdi                                              ; 保存rdi寄存器（可能用于调试）
          sub   rsp,128h                                         ; 在栈上分配128h字节空间给局部变量
          lea   rbp,[rsp+20h]                                    ; 设置新的基址指针（帧指针）
          lea   rcx,[__D3319B7B_sum_c@c (07FF7B4662008h)]        ; 加载调试符号地址
          call  __CheckForDebuggerJustMyCode (07FF7B465136Bh)    ; 调试器检查函数
          nop                                                    ; 空操作，用于对齐

    ;int Sum = 0;
          mov   dword ptr [Sum],0                                ; 初始化Sum变量为0

    ;for (int i = 1; i <= 100; i++) {
          mov   dword ptr [rbp+24h],1                            ; 初始化循环计数器i=1
          jmp   main+34h (07FF7B46518C4h)                        ; 跳转到循环条件检查

    ; 循环递增部分（标签在跳转目标处）
          mov   eax,dword ptr [rbp+24h]                          ; 加载i的值到eax
          inc   eax                                              ; i++
          mov   dword ptr [rbp+24h],eax                          ; 将递增后的值存回i

    ; 循环条件检查
          cmp   dword ptr [rbp+24h],64h                          ; 比较i与100（64h）
          jg    main+49h (07FF7B46518D9h)                        ; 如果i > 100，跳出循环

    ;Sum += i;
          mov   eax,dword ptr [rbp+24h]                          ; 将i的值加载到eax
          mov   ecx,dword ptr [Sum]                              ; 将Sum的值加载到ecx
          add   ecx,eax                                          ; Sum = Sum + i
          mov   eax,ecx                                          ; 将结果保存到eax
          mov   dword ptr [Sum],eax                              ; 更新Sum的值

    ;}
          jmp   main+2Ch (07FF7B46518BCh)                        ; 跳回循环递增部分

    ;printf("Sum is %d\n", Sum);
          mov   edx,dword ptr [Sum]                              ; 将Sum的值加载到edx作为第二个参数
          lea   rcx,[string "Sum is %d\n" (07FF7B465AC28h)]      ; 加载格式字符串地址到rcx作为第一个参数
          call  printf (07FF7B4651195h)                          ; 调用printf函数
          nop                                                    ; 空操作

    ;return 0;
          xor   eax,eax                                          ; 将eax清零，作为返回值0

    ;}
          lea   rsp,[rbp+108h]                                   ; 恢复栈指针（清理栈空间）
          pop   rdi                                              ; 恢复rdi寄存器
          pop   rbp                                              ; 恢复基址指针
          ret                                                    ; 从函数返回

END START