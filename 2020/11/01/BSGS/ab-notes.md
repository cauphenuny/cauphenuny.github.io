---
title: 计组实验笔记
date: 2025-04-11 14:00:34
tags:
  - CS
  - System
  - verilog
---

记录一些踩到了的坑

---

# ALU

考虑如下的两组代码：

```verilog
wire         is_sub = ALUop[1] & (ALUop[0] | ALUop[2]);  // SUB, SLT, SLTU
wire [N-1:0] b_convert = is_sub ? ~B : B;
wire [N-1:0] arith_result;

assign {CarryOut, arith_result} = A + b_convert + is_sub;
```

```verilog
wire         is_sub = ALUop[1] & (ALUop[0] | ALUop[2]);  // SUB, SLT, SLTU
wire [N-1:0] arith_result;
assign {CarryOut, arith_result} = A + (is_sub ? ~B : B) + is_sub;
```

是不是几乎一模一样？但执行结果是不一样的

```shell
# 第一个输出
ERROR: A = 5ae0ff31, B = 4bd60e41, ALUop = 6, Result = 0f0af0f0, CarryOut = 1, CarryOutReference = 0.
# 第二个输出
Success: finished alu testbench.
```

原因：操作数位数不匹配，考虑上面的两个`assign`语句，左边的是 $N+1$ 位的，而右边的是 $N$ 位的。

Verilog会自动将 $N$ 位的数扩展成 $N+1$ 位的数，然而这样的扩展不是“惰性求值”（先尽可能不改动位数，遇到不匹配的地方再扩展）的，在运算一开始就会将所有的运算数扩展成 $N+1$ 位。
[ref: Verilog 中表达式位宽和类型的确定规则](https://www.crexyer.com/2020/04/expression-size-and-type-in-verilog/)

因此`~B`在经过扩展再取反后的最高位是 $1$，但`b_convert`的取反在`assign`运算前就被执行了，在`assign`语句中会直接在最高位补 $0$ ，因此造成错误。

解决方案：`wire [N:0] b_convert = is_sub ? ~B : B;`
