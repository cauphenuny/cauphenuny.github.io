---
title: 计组实验笔记
date: 2025-04-11 14:00:34
tags:
  - CS
  - System
  - verilog
---

记录一些踩到了的坑，或者一些有趣的东西。

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

---

# MIPS-CPU

`addi` 和 `addiu` 其实都是符号扩展的，不要被 `addiu` 名字骗了。`addiu` 的 unsigned 只体现在不出现 Overflow Exception。

---

考虑 I-Type Branch 指令 `beq,bne,blez,bgtz` 写入 PC 的条件：

- `beq`: $r_s = r_t$
- `bne`: $r_s \neq r_t$
- `blez`: $r_s \leq r_t(0)$
- `bgtz`: $r_s > r_t(0)$

为了统一判断条件，可以使用 ALU 的 Zero 输出

- `beq`: $r_s-r_t$ $\text{Zero}$
- `bne`: $r_s-r_t$ $\overline{\text{Zero}}$
- `blez`: $r_t(0)-r_s$ $\text{Zero}$ ($r_t(0) < r_s$ 不成立 $\Longleftrightarrow$ ALU 输出 0 $\Longleftrightarrow \, \text{Zero}$)
- `bgtz`: $r_t(0)<r_s$ $\overline{\text{Zero}}$

对这四条指令的语义进行正交分组：

- `beq,bne` 属于 EQ 组，相等语义，ALU 做减法操作
- `bne,blez` 属于 NEG 组，否定语义

上面的跳转条件总结如下（空代表 $0$）：

| Inst  | EQ | NEG | Zero |
|-------|----|----|------|
| beq   | 1  |    | 1    |
| bne   | 1  | 1  |      |
| bgtz  |    |    |      |
| blez  |    | 1  | 1    |

似乎看不出什么规律，别急，我们反转一位，将 EQ 组改成 GT 组，表示比较操作

| Inst  | GT | NEG | Zero |
|-------|----|----|------|
| beq   |    |    | 1    |
| bne   |    | 1  |      |
| bgtz  | 1  |    |      |
| blez  | 1  | 1  | 1    |

Amazing啊，现在可以发现只要标志位数量是奇数，就要写入PC

所以 PC 更新条件是：`type_gt ^ type_neg ^ alu_zero`，非常简洁！

类似地，regimm 类型指令 PC 更新条件是 `type_neg ^ (~alu_zero)`

R-Type Move 类型指令 寄存器写条件是 `type_neg ^ alu_zero`

这些 `type_` 标志都可以从 opcode/func 中很简单地判定。

例子：

| Inst | opcode |
|-------|--------|
| beq | 000100 |
| bne | 000101 |
| bgtz | 000111 |
| blez | 000110 |

`type_gt = opcode[1]`
`type_neg = opcode[0] ^ opcode[1]`
