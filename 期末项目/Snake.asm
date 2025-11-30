.model small
.stack 1000h

; 数据段
.data
    ScoreMsg       db  'Press WASD to Move. Score: $'    ; 分数显示字符串
    Score          dw  0                                 ; 分数变量
    BorderTopLeftX dw  0                                 ; 边框左上角X坐标
    BorderTopLeftY dw  1                                 ; 边框左上角Y坐标
    BorderWidth    equ 24                                ; 边框宽度
    BorderHeight   equ 12                                ; 边框高度
    IfDie          dw  0                                 ; 是否死亡，撞到边界或是自己的身体就死亡
    IfWin          dw  0                                 ; 是否胜利，218分胜利
    DieMsg         db  'You Die!$'                       ; 失败
    WinMsg         db  'You Win!$'                       ; 胜利
    SnakeLength    dw  2                                 ; 蛇当前长度
    SnakePositions dw  440 dup(0)                        ; 蛇身位置数组，每个位置占用2字(x,y)，最多220段220 * 2 = 440个字
    SnakeDirection dw  0                                 ; 蛇移动方向: 0=上, 1=右, 2=下, 3=左
    FoodX          dw  0                                 ; 食物X坐标
    FoodY          dw  0                                 ; 食物Y坐标
.code                                                            ; 代码段
    
main PROC                                                        ; 主函数
                             mov  ax, @data
                             mov  ds, ax

                             call InitializeSnakePositions       ; 初始化蛇位置数组

    GameLoop:                                                    ; 游戏主循环

                             cmp  IfDie, 1                       ; 检查游戏结束条件
                             je   GameOver
                             cmp  IfWin, 1
                             je   GameWin

                             call CheckKeyboardInput             ; 检查键盘输入
                             call UpdateSnakePosition            ; 更新蛇的位置
                             call ClearConsole                   ; 清空屏幕
                             call PrintScore                     ; 打印分数
                             call PrintBorder                    ; 打印边框
                             call GenerateFood                   ; 生成和打印食物
                             call PrintSnake                     ; 打印蛇
                             call CheckFoodCollision             ; 检查是否吃到食物
                             call CheckGameStatus                ; 检查游戏状态
                             call DelayOneSecond                 ; 延时1秒
                             jmp  GameLoop                       ; 循环继续

    GameOver:                                                    ; 显示失败信息
                             mov  ah, 02h                        ; 设置光标位置
                             mov  bh, 00h
                             mov  dh, byte ptr BorderTopLeftY    ; Y坐标 = 边框顶部Y (字节)
                             add  dh, BorderHeight               ; 加上边框高度
                             add  dh, 1                          ; 再往下空一行
                             mov  dl, byte ptr BorderTopLeftX    ; X坐标 = 边框左侧X (字节)
                             int  10h
                   
                             mov  ah, 09h
                             mov  dx, offset DieMsg
                             int  21h
                             jmp  ExitGame

    GameWin:                                                     ; 显示胜利信息
                             mov  ah, 02h                        ; 设置光标位置
                             mov  bh, 00h
                             mov  dh, byte ptr BorderTopLeftY    ; Y坐标 = 边框顶部Y (字节)
                             add  dh, BorderHeight               ; 加上边框高度
                             add  dh, 1                          ; 再往下空一行
                             mov  dl, byte ptr BorderTopLeftX    ; X坐标 = 边框左侧X (字节)
                             int  10h
                   
                             mov  ah, 09h
                             mov  dx, offset WinMsg
                             int  21h
    
    ExitGame:                                                    ; 等待按键后退出

                             mov  ah, 01h
                             int  21h
    
                             mov  ah, 4ch                        ; 程序结束
                             int  21h

main ENDP

CheckFoodCollision PROC                                          ; 检查蛇头是否在食物上
                             push ax
                             push bx
                             push cx
                             push dx
    
    ; 比较蛇头坐标与食物坐标
                             mov  ax, [SnakePositions]           ; 蛇头X坐标
                             mov  bx, [SnakePositions+2]         ; 蛇头Y坐标
                             
                             cmp  ax, FoodX
                             jne  NoCollision
                             cmp  bx, FoodY
                             jne  NoCollision
    
    ; 如果蛇头在食物上，吃掉食物
                             mov  FoodX, 0                       ; 重置食物坐标
                             mov  FoodY, 0
    
                             inc  Score                          ; 分数加一
                             inc  SnakeLength                    ; 蛇长度加一
    
    NoCollision:             
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
                             ret
CheckFoodCollision ENDP

GenerateFood PROC                                                ; 生成食物函数
                             push ax
                             push bx
                             push cx
                             push dx
                             push si
                             push di


                             mov  ax, FoodX                      ; 检查食物坐标是否为(0,0)，如果不是则直接打印食物
                             cmp  ax, 0
                             jne  PrintExistingFood
                             mov  ax, FoodY
                             cmp  ax, 0
                             jne  PrintExistingFood
    
    GenerateNewFood:                                             ; 使用标签而不是函数名
    ; 生成随机位置（简单使用系统时间作为随机种子）
                             mov  ah, 00h                        ; 读取系统计时器
                             int  1Ah                            ; CX:DX = 计时器值
    

                             mov  ax, dx                         ; 使用DX作为随机数，计算X坐标
                             xor  dx, dx
                             mov  cx, BorderWidth
                             sub  cx, 2                          ; 减去左右边框
                             div  cx
                             add  dl, byte ptr BorderTopLeftX    ; 加上边框左边界
                             inc  dl                             ; 确保在边框内
                             mov  byte ptr FoodX, dl
    

                             mov  ax, cx                         ; 使用CX作为随机数，计算Y坐标
                             xor  dx, dx
                             mov  cx, BorderHeight
                             sub  cx, 2                          ; 减去上下边框
                             div  cx
                             add  dl, byte ptr BorderTopLeftY    ; 加上边框上边界
                             inc  dl                             ; 确保在边框内
                             mov  byte ptr FoodY, dl
    

                             call CheckFoodOnSnake               ; 检查生成的位置是否在蛇身上，如果是则重新生成
                             cmp  ax, 1
                             je   GenerateNewFood                ; 如果在蛇身上，重新生成（使用标签而不是函数名）
    
    PrintExistingFood:                                           ; 在食物坐标处打印"@"
                             mov  ah, 02h                        ; 设置光标位置
                             mov  bh, 00h
                             mov  dh, byte ptr FoodY
                             mov  dl, byte ptr FoodX
                             int  10h
    
                             mov  ah, 0Ah                        ; 打印字符
                             mov  al, '@'
                             mov  bh, 00h
                             mov  cx, 1
                             int  10h
    
                             pop  di
                             pop  si
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
                             ret
GenerateFood ENDP

CheckFoodOnSnake PROC                                            ; 检查食物是否在蛇身上
                             push bx
                             push cx
                             push si
    
                             mov  cx, SnakeLength
                             mov  si, offset SnakePositions
                             mov  ax, 0                          ; 默认不在蛇身上
    
    CheckFoodLoop:           
                             mov  bl, byte ptr [si]              ; 蛇段X坐标
                             mov  bh, byte ptr [si+2]            ; 蛇段Y坐标
                             
                             cmp  bl, byte ptr FoodX             ; 比较X坐标
                             jne  FoodNextSegment
                             cmp  bh, byte ptr FoodY             ; 比较Y坐标
                             jne  FoodNextSegment
                             
                             mov  ax, 1                          ; 在蛇身上，设置标志
                             jmp  FoodCheckEnd                   ; 修改标签名
    
    FoodNextSegment:         
                             add  si, 4
                             loop CheckFoodLoop
    
    FoodCheckEnd:                                                ; 修改标签名
                             pop  si
                             pop  cx
                             pop  bx
                             ret
CheckFoodOnSnake ENDP

CheckKeyboardInput PROC                                          ; 检查键盘输入函数
                             push ax
                             push cx
                             push dx
    
    ; 检查是否有按键输入
                             mov  ah, 01h
                             int  16h
                             jz   NoInput                        ; 没有按键则直接返回
    
    ; 读取按键
                             mov  ah, 00h
                             int  16h
    
    ; 根据按键更新方向
                             cmp  al, 'w'                        ; W键 - 上
                             je   SetUp
                             cmp  al, 's'                        ; S键 - 下
                             je   SetDown
                             cmp  al, 'a'                        ; A键 - 左
                             je   SetLeft
                             cmp  al, 'd'                        ; D键 - 右
                             je   SetRight
                             jmp  ClearBuffer                    ; 如果是其他按键，只清空缓冲区
    
    SetUp:                   
                             cmp  SnakeDirection, 2              ; 防止直接反向
                             je   ClearBuffer
                             mov  SnakeDirection, 0
                             jmp  ClearBuffer
    SetDown:                 
                             cmp  SnakeDirection, 0              ; 防止直接反向
                             je   ClearBuffer
                             mov  SnakeDirection, 2
                             jmp  ClearBuffer
    SetLeft:                 
                             cmp  SnakeDirection, 1              ; 防止直接反向
                             je   ClearBuffer
                             mov  SnakeDirection, 3
                             jmp  ClearBuffer
    SetRight:                
                             cmp  SnakeDirection, 3              ; 防止直接反向
                             je   ClearBuffer
                             mov  SnakeDirection, 1

    ClearBuffer:             
    ; 清空键盘缓冲区
                             mov  ah, 0Ch                        ; 清空缓冲区功能
                             mov  al, 00h                        ; 不读取字符
                             int  21h
    
    NoInput:                 
                             pop  dx
                             pop  cx
                             pop  ax
                             ret
CheckKeyboardInput ENDP

CheckGameStatus PROC                                             ; 检查游戏状态函数
                             push ax
                             push bx
                             push cx
                             push si
                             push di
    
                             mov  ax, Score                      ; 先检查胜利条件（优先级更高）
                             cmp  ax, 218                        ; 检查分数是否达到218
                             jl   CheckDeath                     ; 如果小于218，检查死亡条件
    
                             mov  IfWin, 1                       ; 胜利条件满足
                             jmp  CheckEnd
    
    CheckDeath:              

                             mov  si, offset SnakePositions      ; 检查是否撞墙
                             mov  ax, [si]                       ; 蛇头X坐标
                             mov  bx, [si+2]                     ; 蛇头Y坐标
    

                             cmp  ax, BorderTopLeftX             ; 检查是否撞到左墙
                             jle  SetDie
    

                             mov  cx, BorderTopLeftX             ; 检查是否撞到右墙
                             add  cx, BorderWidth
                             dec  cx                             ; 右边墙位置 = BorderTopLeftX + BorderWidth - 1
                             cmp  ax, cx
                             jge  SetDie

                             cmp  bx, BorderTopLeftY             ; 检查是否撞到上墙
                             jle  SetDie

                             mov  cx, BorderTopLeftY             ; 检查是否撞到下墙
                             add  cx, BorderHeight
                             dec  cx                             ; 下边墙位置 = BorderTopLeftY + BorderHeight - 1
                             cmp  bx, cx
                             jge  SetDie
    
    ; 检查是否撞到自己的身体（从第5段开始检查）
                             mov  cx, SnakeLength
                             cmp  cx, 5                          ; 如果长度小于5，不可能撞到自己
                             jl   CheckEnd
    
                             mov  si, offset SnakePositions
                             add  si, 16                         ; 跳过前4段（4段×4字节=16字节）
                             mov  cx, SnakeLength
                             sub  cx, 4                          ; 循环次数 = 长度 - 4
    
    CheckBodyCollision:      
                             mov  ax, [si]                       ; 身体段X坐标
                             mov  bx, [si+2]                     ; 身体段Y坐标
                             cmp  ax, [SnakePositions]           ; 与蛇头X比较
                             jne  NextBody
                             cmp  bx, [SnakePositions+2]         ; 与蛇头Y比较
                             je   SetDie                         ; 如果都相等，撞到身体
    
    NextBody:                
                             add  si, 4                          ; 移动到下一段身体
                             loop CheckBodyCollision
                             jmp  CheckEnd
    
    SetDie:                  
                             mov  IfDie, 1
    
    CheckEnd:                
                             pop  di
                             pop  si
                             pop  cx
                             pop  bx
                             pop  ax
                             ret
CheckGameStatus ENDP

InitializeSnakePositions PROC                                    ; 初始化蛇位置数组
                             push ax
                             push bx
                             push si
    
                             mov  si, offset SnakePositions      ; 设置蛇头位置（在边框内中央位置）
    
                             mov  ax, BorderWidth                ; 计算X坐标：BorderWidth / 2 + BorderTopLeftX
                             shr  ax, 1                          ; 除以2
                             add  ax, BorderTopLeftX
                             mov  [si], ax                       ; 蛇头X坐标
    
                             mov  ax, BorderHeight               ; 计算Y坐标：BorderHeight / 2 + BorderTopLeftY
                             shr  ax, 1                          ; 除以2
                             add  ax, BorderTopLeftY
                             mov  [si+2], ax                     ; 蛇头Y坐标
    
                             pop  si
                             pop  bx
                             pop  ax
                             ret
InitializeSnakePositions ENDP

PrintSnake PROC                                                  ; 打印蛇
                             push ax
                             push bx
                             push cx
                             push dx
                             push si

                             mov  cx, SnakeLength
                             mov  si, offset SnakePositions
                             mov  bx, 1

    PrintSnakeLoop:          

                             mov  ah, 02h                        ; 设置光标位置
                             mov  bh, 00h
                             mov  dh, byte ptr [si+2]
                             mov  dl, byte ptr [si]
                             int  10h


                             cmp  bx, 1                          ; 判断是蛇头还是蛇身
                             je   PrintHead
                   
                             push cx                             ; 保存循环计数
                             mov  ah, 0Ah
                             mov  al, 'o'
                             mov  bh, 00h
                             mov  cx, 1
                             int  10h
                             pop  cx                             ; 恢复循环计数
                             jmp  NextSegment

    PrintHead:                                                   ; 打印蛇头

                             push cx                             ; 保存循环计数
                             mov  ah, 0Ah
                             mov  al, 'O'
                             mov  bh, 00h
                             mov  cx, 1
                             int  10h
                             pop  cx                             ; 恢复循环计数

    NextSegment:             
                             add  si, 4
                             inc  bx
                             loop PrintSnakeLoop

                             pop  si
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
                             ret
PrintSnake ENDP

UpdateSnakePosition PROC                                         ; 更新蛇位置函数
                             push ax
                             push bx
                             push cx
                             push si
                             push di

                             mov  cx, SnakeLength                ; 蛇的长度
                             cmp  cx, 1                          ; 如果长度=1，直接移动蛇头
                             je   MoveHeadOnly

    ; 长度>1，从尾部开始向前移动每一段
                             mov  si, offset SnakePositions
                             mov  ax, cx
                             dec  ax                             ; 段数-1
                             shl  ax, 1                          ; 乘以2
                             shl  ax, 1                          ; 再乘以2，总共乘以4
                             add  si, ax                         ; si指向最后一段（蛇尾）

                             mov  di, si
                             sub  di, 4                          ; di指向前一段

                             mov  cx, SnakeLength
                             dec  cx                             ; 循环次数 = 长度-1

    MoveBodyLoop:            
    ; 将前一段的位置复制到当前段
                             mov  ax, [di]                       ; 前一段X坐标
                             mov  [si], ax                       ; 当前段X坐标
                             mov  ax, [di+2]                     ; 前一段Y坐标
                             mov  [si+2], ax                     ; 当前段Y坐标

    ; 移动到前一段
                             sub  si, 4                          ; 当前段向前移动
                             sub  di, 4                          ; 前一段向前移动
                             loop MoveBodyLoop

    MoveHeadOnly:                                                ; 移动蛇头
                             mov  si, offset SnakePositions
                             mov  ax, [si]                       ; 当前蛇头X坐标
                             mov  bx, [si+2]                     ; 当前蛇头Y坐标

                             cmp  SnakeDirection, 0              ; 上
                             je   MoveUp
                             cmp  SnakeDirection, 1              ; 右
                             je   MoveRight
                             cmp  SnakeDirection, 2              ; 下
                             je   MoveDown
                             cmp  SnakeDirection, 3              ; 左
                             je   MoveLeft

    MoveUp:                  
                             dec  bx                             ; Y坐标减1
                             jmp  UpdateHead

    MoveRight:               
                             inc  ax                             ; X坐标加1
                             jmp  UpdateHead

    MoveDown:                
                             inc  bx                             ; Y坐标加1
                             jmp  UpdateHead

    MoveLeft:                
                             dec  ax                             ; X坐标减1

    UpdateHead:              
                             mov  [si], ax                       ; 更新蛇头X坐标
                             mov  [si+2], bx                     ; 更新蛇头Y坐标

                             pop  di
                             pop  si
                             pop  cx
                             pop  bx
                             pop  ax
                             ret
UpdateSnakePosition ENDP

DelayOneSecond PROC                                              ; 延时1秒函数
                             push ax
                             push cx
                             push dx
    
                             mov  cx, 0Fh                        ; 延时计数高位
                             mov  dx, 4240h                      ; 延时计数低位
                             mov  ah, 86h                        ; BIOS延时功能
                             int  15h                            ; 调用BIOS延时
    
                             pop  dx
                             pop  cx
                             pop  ax
                             ret
DelayOneSecond ENDP

PrintScore PROC                                                  ; 打印分数函数
                             push ax
                             push bx
                             push cx
                             push dx
                             push si
    
    ; 设置光标位置到左上角 (0,0)
                             mov  ah, 02h
                             mov  bh, 00h
                             mov  dh, 00h
                             mov  dl, 00h
                             int  10h
    
    ; 显示分数前缀 "Score: "
                             mov  ah, 09h
                             mov  dx, offset ScoreMsg
                             int  21h
    
    ; 将分数值转换为ASCII并显示
                             mov  ax, Score                      ; 获取分数值
                             mov  bx, 10                         ; 除数
                             mov  cx, 0                          ; 数字位数计数器
    
    ; 将数字分解为各位数字
    ConvertLoop:             
                             mov  dx, 0                          ; 清空DX用于除法
                             div  bx                             ; AX = AX/10, DX = 余数
                             push dx                             ; 保存余数（数字）
                             inc  cx                             ; 增加位数计数
                             cmp  ax, 0                          ; 检查是否还有数字
                             jnz  ConvertLoop
    
    ; 显示各位数字
    DisplayLoop:             
                             pop  dx                             ; 弹出数字
                             add  dl, '0'                        ; 转换为ASCII
                             mov  ah, 02h                        ; 显示字符功能
                             int  21h
                             loop DisplayLoop
    
                             pop  si
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
                             ret
PrintScore ENDP

PrintBorder PROC                                                 ; 打印边框函数
                             push ax
                             push bx
                             push cx
                             push dx
    
    ; 获取边框左上角坐标
                             mov  bx, BorderTopLeftX
                             mov  dx, BorderTopLeftY
    
    ; 打印上边框
                             mov  cx, BorderWidth                ; 边框宽度
    TopLoop:                 
                             push cx
                             push bx
                             push dx
    
    ; 设置光标位置
                             mov  ah, 02h
                             mov  bh, 00h
                             mov  dh, dl                         ; Y坐标
                             mov  dl, bl                         ; X坐标
                             int  10h
    
    ; 打印井号
                             mov  ah, 0Ah
                             mov  al, '#'
                             mov  bh, 00h
                             mov  cx, 1
                             int  10h
    
                             pop  dx
                             pop  bx
                             pop  cx
    
                             inc  bx                             ; X坐标增加
                             loop TopLoop
    
    ; 打印下边框
                             mov  bx, BorderTopLeftX
                             mov  dx, BorderTopLeftY
                             add  dx, BorderHeight               ; 下边框Y坐标
                             dec  dx                             ; 调整到正确位置
                             mov  cx, BorderWidth
    BottomLoop:              
                             push cx
                             push bx
                             push dx
    
                             mov  ah, 02h
                             mov  bh, 00h
                             mov  dh, dl
                             mov  dl, bl
                             int  10h
    
                             mov  ah, 0Ah
                             mov  al, '#'
                             mov  bh, 00h
                             mov  cx, 1
                             int  10h
    
                             pop  dx
                             pop  bx
                             pop  cx
    
                             inc  bx
                             loop BottomLoop
    
    ; 打印左边框
                             mov  bx, BorderTopLeftX
                             mov  dx, BorderTopLeftY
                             inc  dx                             ; 从第二行开始
                             mov  cx, BorderHeight               ; 高度
                             dec  cx                             ; 减去上下角
                             dec  cx
    LeftLoop:                
                             push cx
                             push bx
                             push dx
    
                             mov  ah, 02h
                             mov  bh, 00h
                             mov  dh, dl
                             mov  dl, bl
                             int  10h
    
                             mov  ah, 0Ah
                             mov  al, '#'
                             mov  bh, 00h
                             mov  cx, 1
                             int  10h
    
                             pop  dx
                             pop  bx
                             pop  cx
    
                             inc  dx                             ; Y坐标增加
                             loop LeftLoop
    
    ; 打印右边框
                             mov  bx, BorderTopLeftX
                             add  bx, BorderWidth                ; 右边框X坐标
                             dec  bx                             ; 调整到正确位置
                             mov  dx, BorderTopLeftY
                             inc  dx                             ; 从第二行开始
                             mov  cx, BorderHeight               ; 高度
                             dec  cx                             ; 减去上下角
                             dec  cx
    RightLoop:               
                             push cx
                             push bx
                             push dx
    
                             mov  ah, 02h
                             mov  bh, 00h
                             mov  dh, dl
                             mov  dl, bl
                             int  10h
    
                             mov  ah, 0Ah
                             mov  al, '#'
                             mov  bh, 00h
                             mov  cx, 1
                             int  10h
    
                             pop  dx
                             pop  bx
                             pop  cx
    
                             inc  dx                             ; Y坐标增加
                             loop RightLoop
    
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
                             ret
PrintBorder ENDP

ClearConsole PROC                                                ; 清空控制台屏幕函数
    
    ; 保存寄存器
                             push ax
                             push bx
                             push cx
                             push dx
    
    ; 设置光标位置到左上角 (0,0)
                             mov  ah, 02h                        ; DOS 功能号：设置光标位置
                             mov  bh, 00h                        ; 显示页码（0为当前页）
                             mov  dh, 00h                        ; 行号 (0)
                             mov  dl, 00h                        ; 列号 (0)
                             int  10h                            ; 调用 BIOS 视频中断
    
    ; 清除屏幕内容
                             mov  ah, 06h                        ; DOS 功能号：屏幕上滚
                             mov  al, 00h                        ; 清空整个窗口
                             mov  bh, 07h                        ; 属性：黑底白字 (标准)
                             mov  ch, 00h                        ; 左上角行号
                             mov  cl, 00h                        ; 左上角列号
                             mov  dh, 24h                        ; 右下角行号 (24)
                             mov  dl, 79h                        ; 右下角列号 (79)
                             int  10h                            ; 调用 BIOS 视频中断
    
    ; 恢复光标到左上角
                             mov  ah, 02h                        ; DOS 功能号：设置光标位置
                             mov  bh, 00h                        ; 显示页码
                             mov  dh, 00h                        ; 行号 (0)
                             mov  dl, 00h                        ; 列号 (0)
                             int  10h                            ; 调用 BIOS 视频中断
    
    ; 恢复寄存器
                             pop  dx
                             pop  cx
                             pop  bx
                             pop  ax
    
                             ret
ClearConsole ENDP

end main ; 指定起始点