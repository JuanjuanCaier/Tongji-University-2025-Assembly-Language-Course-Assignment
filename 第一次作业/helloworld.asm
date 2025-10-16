.model small ;定义为小型模型
.data                                      ;数据段开始
         Hello DB'Hello world!',0DH,'$'    ;定义字符串，Hello是变量名，DB表示定义字节，'Hello world!'是字符串内容，0DH是回车，'$'是DOS字符串结束标志
.code                     ;代码段
    START:                ;程序入口点
          MOV AX,@DATA
          MOV DS,AX       ;将数据段地址移到DS数据段寄存器
          LEA DX,Hello    ;LEA指令将Hello字符串的地址加载到DX寄存器
          MOV AH,9        ;AH=9表示调用DOS的字符串显示功能
          INT 21H         ;调用DOS中断21H，执行AH中指定的功能

          MOV AX,4C00H    ;AX=4C00H，其中AH（AX高八位）=4CH表示程序退出功能，AL（AX低八位）=00H表示退出代码为0
          INT 21h         ;再次调用DOS中断21H，这次执行程序退出功能
END START ;程序结束标记