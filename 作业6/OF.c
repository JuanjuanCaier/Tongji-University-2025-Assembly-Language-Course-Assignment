#include <stdio.h>
// 编译工具：x86 msvc

// 模拟溢出中断处理的概念
void OverflowInterruptHandler(){
    printf("溢出中断发生！程序将安全终止。\n");
    exit(1);
}

// 手动检查溢出标志的函数
int CheckOverflowFlags(int A, int B){
    int Result;
    unsigned char OFFlag;

    __asm {
        mov eax, A // 将A加载到EAX
        add eax, B // 加上B
        mov Result, eax // 将结果存储到Result
        pushfd // 将标志寄存器压栈
        pop ebx // 弹出到EBX
        shr ebx, 11 // 将OF位(第11位)右移到最低位
        and ebx, 1 // 掩码保留最低位
        mov OFFlag, bl // 存储溢出标志
    }

    return OFFlag;
}

// 使用条件跳转模拟INTO行为
void SimulateIntoInstruction(int OFDetected){
    if (OFDetected)
    {
        printf("检测到溢出标志OF=1，触发中断处理\n");
        OverflowInterruptHandler();
    }
    else
    {
        printf("溢出标志OF=0，继续正常执行\n");
    }
}

// 触发溢出的测试函数
void TestOverflow(){
    int A = 2147483647; // INT_MAX
    int B = 1;
    int Result;

    printf("测试溢出情况：%d + %d\n", A, B);

    // 使用内联汇编进行有符号加法并手动检查溢出
    int OFFlag = CheckOverflowFlags(A, B);

    // 获取实际结果
    __asm {
        mov eax, A
        add eax, B
        mov Result, eax
    }

    printf("运算结果：%d\n", Result);
    printf("溢出标志OF：%d\n", OFFlag);

    // 模拟INTO指令的行为
    SimulateIntoInstruction(OFFlag);
}

// 不触发溢出的测试函数
void TestNoOverflow(){
    int A = 100;
    int B = 200;
    int Result;

    printf("测试无溢出情况：%d + %d\n", A, B);

    int OFFlag = CheckOverflowFlags(A, B);

    __asm {
        mov eax, A
        add eax, B
        mov Result, eax
    }

    printf("运算结果：%d\n", Result);
    printf("溢出标志OF：%d\n", OFFlag);

    // 模拟INTO指令的行为
    SimulateIntoInstruction(OFFlag);
}

// 主函数
int main(){
    printf("1. 测试无溢出情况：\n");
    TestNoOverflow();

    printf("2. 测试溢出情况：\n");
    TestOverflow();

    printf("演示完成。\n");

    return 0;
}