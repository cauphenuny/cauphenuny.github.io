---
title: "brainfuck 代码生成工具 - 将C代码编译到brainfuck"
date: 2024-11-22 00:05:35
categories:
  - CS
  - 编译原理
tags:
  - CS
  - 编译原理
  - Compiler
  - C++
  - cpp
  - C
  - brainfuck
---

最近在做一个编译原理lab

☝️🤓诶，我已经有结构化的AST和IR了，岂不是能不太费劲地地写出一些有意思的东西？

就这样一拍脑袋给编译器加了个brainfuck后端

由于还没想好怎么实现栈，现在所有变量都是`static`的，也不支持递归函数调用

# demo

```cpp
/// file: test/int_size.c
int main() {
    int bit = 0;
    int v = 1;
    while (v) {
        v = v * 2;
        bit = bit + 1;
    }
    return bit;
}
```

```shell
$ build/compiler -brainz test/int_size.c
>+[[>>>>+>+<<<<<-]>>>>>[<<<<<+>>>>>-][-]+<[->-<]+>[<->[-]]<[<+>-]<[->[-]<<<[-]>>
>[<<<+>>>-][-]+<<[-]>>[<<+>>-]<<<<[-]++>>>][-]>[-]>[-]<<<<<[>>>>+>+<<<<<-]>>>>>[
<<<<<+>>>>>-][-]++<[->-<]+>[<->[-]]<[<+>-]<[->[-]>[-]<<<[>>+>+<<<-]>>>[<<<+>>>-]
[-]+<[[-]>-<<<<<[-]+++>>>>]>[-<<<<<[-]++++>>>>>]<<][-][-]>[-]<<<<<[>>>>+>+<<<<<-
]>>>>>[<<<<<+>>>>>-][-]+++<[->-<]+>[<->[-]]<[<+>-]<[->[-]>[-]<<<[>>+>+<<<-]>>>[<
<<+>>>-][-]++<[>[>+>+<<-]>>[<<+>>-]<<<-]<<[-]>>>>[<<<<+>>>>-]<<[-]>[-]<<<<[>>>+>
+<<<<-]>>>>[<<<<+>>>>-][-]+>[-]<<[>>+<<-]>[>+<-]<<<<[-]>>>>>[<<<<<+>>>>>-]<<<<<<
[-]++>>>][-]>[-]>[-]<<<<<[>+>+<<<<<-]>>>>>[<<<<<+>>>>>-][-]++++<[->-<]+>[<->[-]]
<[<+>-]<[->[-]>[-]<<<<[>>>+>+<<<<-]>>>>[<<<<+>>>>-]<<<<<<[-]>>>>>[<<<<<+>>>>>-]<
<<<[-]>>>]<<<]<

$ build/compiler -brain test/int_size.c | brainfuck
exited with 8 after 35009 steps.
```

# 基础设施

维护一个`Tape`表示当前上下文，其中有：

- `cur_used`: 使用中的`cell`，在`Tape::alloc()`的时候不能重复使用

- `current_pos`: `cell pointer`位置

- `recurse_counter`: 生成 bf code 的缩进层数

`Tape`支持的操作一览：

```cpp
struct Tape {
    struct Var;
    struct RecurseGuard;
    unsigned current_pos{0};
    unsigned max_pos{0};
    bool cur_used[MAXN]{0};
    bool non_zero[MAXN]{0};
    std::string record_str;
    unsigned recurse_counter{0};
    [[nodiscard]] RecurseGuard comment(const std::string& fmt, const auto&... params);
    void record(const std::string& str);
    void free(unsigned pos, unsigned size = 1);
    void clear(unsigned pos);
    auto alloc() -> Var;
    auto claim(unsigned pos) -> Var;
    void jump(unsigned pos);
    void move(Var src, Var& dest, int sign = 1);
    void copy(Var& src, std::vector<std::reference_wrapper<Var>> dest, int sign = 1);
    auto clone(Var& src) -> Var;
    void inc(Var& pos, int val);
    void add(Var x, Var y, Var& ret);
    void sub(Var x, Var y, Var& ret);
    void mul(Var x, Var y, Var& ret);
    void div(Var x, Var y, Var& ret);
    void mod(Var x, Var y, Var& ret);
    void lor(Var x, Var y, Var& ret);
    void lnot(Var x, Var& ret);
    void eq(Var x, Var y, Var& ret);
    void lt(Var x, Var y, Var& ret);
    void constructInteger(Var& pos, int value);
    auto createInteger(int value) -> Var;
    void loop(Var&, std::function<void()>);
    void cond(Var, std::function<void()>);
    void cond(Var, std::function<void()>, std::function<void()>);
};
```

其中定义了一个`Var`类，封装一些变量的基本操作，在搭积木时能更方便一点。

保存了变量所属的`Tape`，以及变量位置。

独占`cell`资源，删除复制构造函数，只允许移动，使用`RAII`管理`cell`生命周期，防止`double free`或者`memory leak`（`brainfuck`的语境应该叫`cell leak`?）或者可能出现的对变量的意外修改。

```cpp
    struct Var {
        Tape* tape;
        unsigned pos;
        bool available{false};
        std::string debugInfo();
        Var() : tape(nullptr), pos(0) {}
        Var(Tape* tape);
        Var(Tape* tape, unsigned preset_pos);
        Var(Var&& v);
        Var(const Var& v) = delete;
        Var& operator=(Var&& v);
        Var& operator=(const Var& v) = delete;
        operator unsigned();
        std::string toString();
        ~Var();
        Var& operator++();
        void operator++(int);
        Var& operator--();
        void operator--(int);
        Var& operator=(int);
        friend Var operator!(Var exp);
    };
```

## `indent`

定义一个构造时添加缩进，析构时减少缩进的变量，这样能借助`RAII`在生成的`brainfuck`代码中自动维护缩进了

```cpp
struct Tape::RecurseGuard {
    Tape* tape;
    RecurseGuard(Tape* t) : tape(t) {
        ++tape->recurse_counter;
    }
    ~RecurseGuard() {
        --tape->recurse_counter;
    }
};
/*
    usage: 
    {
        auto _ = Tape::RecurseGuard(this);
        ... other code ... 
    }
*/
```

`comment()`: 在代码中插入一行注释，返回一个`RecurseGuard`对象，加一级缩进。

```cpp
Tape::RecurseGuard Tape::comment(const std::string& fmt, const auto&... params) {
    record(std::vformat("; " + fmt, std::make_format_args<std::format_context>(params...)));
    return RecurseGuard(this);
}
```

## `alloc` & `free`

在`Tape`中申请一个`cell`，自动分配位置或者手动选择位置

```cpp
Tape::Var::Var(Tape* tape) : tape(tape), available(true) {
    for (unsigned i = 0; i < MAXN; i++) {
        if (tape->cur_used[i]) continue;
        pos = i;
        break;
    }
    tape->max_pos = std::max(tape->max_pos, pos);
    tape->cur_used[pos] = true, tape->clear(pos);
    tape->non_zero[pos] = true;
}
Tape::Var::Var(Tape* tape, unsigned preset_pos) : tape(tape), pos(preset_pos), available(true) {
    if (tape->cur_used[pos]) runtimeError("double allocated cell #{}", pos);
    tape->max_pos = std::max(tape->max_pos, preset_pos);
    tape->cur_used[pos] = true;
    tape->non_zero[pos] = true;
    // debugLog("inplace allocated at {}", pos);
}


Var Tape::alloc() {
    return Var(this);
}
void Tape::free(unsigned pos, unsigned size) {
    for (unsigned i = 0; i < size; i++) {
        if (!cur_used[pos + i]) debugLog("warning: double freed cell #{}", pos + i);
        cur_used[pos + i] = false;
    }
}
```

赋值（转移所有权）

```cpp
Tape::Var::Var(Var&& v) : tape(v.tape), pos(v.pos), available(v.available) {
    // debugLog("move construct {} => {}", (void*)&v, (void*)this);
    v.available = false;
    if (!available) runtimeError("constructed by unavailable variable");
}
Tape::Var::Var& operator=(Var&& v) {
    // debugLog("move assign {} => {}", (void*)&v, (void*)this);
    this->~Var();
    if (this != &v) {
        tape = v.tape, pos = v.pos, available = v.available;
        v.available = false;
    }
    if (!available) runtimeError("assigned by unavailable variable");
    return *this;
}
```

## `jump`

将`cell pointer`移动到指定位置

```cpp
void Tape::jump(unsigned pos) {
    if (pos == current_pos) return;
    if (current_pos < pos) {
        record(repeat(">", pos - current_pos));
    } else {
        record(repeat("<", current_pos - pos));
    }
    current_pos = pos;
}
```

## `loop/cond`

封装了一下`brainfuck`中的`[` `]`运算符

如果`cond`变量不为$0$，则执行`then()`，其中`loop()`会反复判断这一过程，而`cond()`只会执行一次。

`cond()`要求`cond`的所有权，因为会将`cond`变量置为$0$。

```cpp
void Tape::loop(Var& cond, std::function<void()> then) {
    auto _ = comment("loop #{}\n", cond);
    jump(cond), record("[\n");
    then();
    jump(cond), record("]\n");
}

void Tape::cond(Var cond, std::function<void()> then) {
    auto _ = comment("if ${}\n", cond);
    jump(cond);
    record("[[-]\n");
    then();
    jump(cond);
    record("]\n");
}

void Tape::cond(Var cond, std::function<void()> then, std::function<void()> otherwise) {
    auto _ = comment("if_else ${}\n", cond);
    Var tmp = alloc();
    tmp++;
    jump(cond), record("[\n[-]\n");
    tmp--, then();
    jump(cond), record("]");
    jump(tmp), record("[-\n");
    otherwise();
    jump(tmp), record("]");
}
```

# 基本运算符

## `int`

创建`int`常量

```cpp
void Tape::constructInteger(Var& pos, int value) {
    auto _ = comment("#{} = int {}", pos, (uint8_t)value);
    if (!value) return;
    jump(pos);
    record(repeat(value > 0 ? "+" : "-", std::abs(value)));
}

Var Tape::createInteger(int value) {
    Var pos = alloc();
    constructInteger(pos, value);
    return pos;
}
```

## `inc/dec`

`increase/decrease`特定的`cell`

```cpp
void Tape::inc(Var& pos, int val) {
    std::string ch, name;
    if (val > 0)
        ch = "+", name = "inc";
    else
        ch = "-", val = -val, name = "dec";
    auto _ = comment("{} #{} by {}", name, pos, val);
    jump(pos);
    record(repeat(ch, val));
}
```

让`operator--/operator++`调用`Tape::inc()`，从而能直接使用`var--;`的语句

## `move/copy/clone`

移动或者复制变量，其中`clone`不需要一个确定的变量地址，直接返回一个新变量，在其他的算术运算中很有用。

```cpp
void Tape::move(Var src, Var& dest, int sign) {
    if (src.pos == dest.pos) return;
    auto _ = comment("#{} = move #{}", dest, src);
    std::string op = sign > 0 ? "+" : "-";
    loop(src, [&] { jump(dest), record(op), --src; }); // 只要`src`不为$0$就递增/递减 dest
}

void Tape::copy(Var& src, std::vector<std::reference_wrapper<Var>> dest, int sign) {
    std::string comment_str;
    for (auto d : dest) {
        comment_str += std::format("#{} ", d.get());
    }
    comment_str += std::format("= copy #{}", src);
    auto _ = comment(comment_str);
    Var tmp = alloc(); // 保存原来的`src`值
    dest.push_back(tmp);
    std::string ch = sign == 1 ? "+" : "-";
    loop(src, [this, &dest, &src, ch] {
        for (auto d : dest) {
            jump(d.get()), record(ch);
        }
        --src;
    });
    move(std::move(tmp), src);
}

Var Tape::clone(Var& src) {
    Var pos = alloc();
    copy(src, {pos});
    return pos;
}
```

## `add/sub/mul`

```cpp
void Tape::add(Var x, Var y, Var& ret) {
    auto _ = comment("#{} = add (${} ${})", ret, x, y);
    move(std::move(x), ret);
    move(std::move(y), ret);
}

void Tape::sub(Var x, Var y, Var& ret) {
    auto _ = comment("#{} = sub (${} ${})", ret, x, y);
    move(std::move(x), ret);
    move(std::move(y), ret, -1);
}

void Tape::mul(Var x, Var y, Var& ret) {
    auto _ = comment("#{} = mul (${} ${})", ret, x, y);
    loop(x, [this, &x, &y, &ret] { copy(y, {ret}), --x; });
}
```

## `div/mod`

> 这里有很大优化空间

对于`div`，我们有计算方法

```c
while (x) {
    for (tmp = y; tmp; tmp--) {
        x--;
        if (!x) {
            tmp--;
            if (tmp) {
                ret--;
                tmp = 0;
            }
            tmp++;
        }
    }
    ret++;
}
```

翻译成bf code:

```cpp
void Tape::div(Var x, Var y, Var& ret) {
    auto _ = comment("#{} = div (${} ${})", ret, x, y);
    loop(x, [&] {
        auto tmp = clone(y);
        loop(tmp, [&] {
            x--;
            cond(!clone(x), [&] {
                tmp--;
                cond(clone(tmp), [&] {
                    ret--;
                    clear(tmp);
                });
                tmp++;
            });
            tmp--;
        });
        ret++;
    });
}
```

对于`mod`，有`a mod b = a - b * (a / b)`

```cpp
void Tape::mod(Var x, Var y, Var& ret) {
    auto _ = comment("#{} = mod (${} ${})", ret, x, y);
    Var tmp0 = alloc(), tmp1 = alloc();
    div(clone(x), clone(y), tmp0);
    mul(std::move(tmp0), std::move(y), tmp1);
    sub(std::move(x), std::move(tmp1), ret);
}
```

## `logic or/not`

```cpp
void Tape::lor(Var x, Var y, Var& ret) {
    auto _ = comment("#{} = or (${} ${})", ret, x, y);
    cond(std::move(x), [&] { clear(y), y++; });
    cond(std::move(y), [&] { ret++; });
}

void Tape::lnot(Var x, Var& ret) {
    auto _ = comment("#{} = not (${})", ret, x);
    ret++, cond(std::move(x), [&] { ret--; });
}
```

## `eq/lt`

```cpp
void Tape::eq(Var x, Var y, Var& ret) {
    auto _ = comment("#{} = eq (${} ${})", ret, x, y);
    loop(x, [&] { x--, y--; });
    cond(!std::move(y), [&] { ret++; });
}

void Tape::lt(Var x, Var y, Var& ret) {
    auto _ = comment("#{} = lt (${} ${})", ret, x, y);
    ret++;
    loop(x, [&] {
        x--, y--;
        cond(!clone(y), [&] { ret--; });
    });
}
```

# 分支与跳转

设置 $1$ 号`cell`保存 PC 值，给 IR 中的每一个 block 分配一个 PC值，整个程序就是一个大循环，每次遍历一遍所有的 block，如果`cell #1`保存的值跟当前 block 的 PC 值相同，就执行这个 block 的代码，否则就跳过，`cell #1`值为0时退出程序。

```cpp
/// file: bf.cpp
/// func: ValueIR::printBF
{
    auto& ctx = *context;
    auto& tape = ctx.tape;
    std::vector<decltype(BfContext::ret)> ret;
    for (auto& param : params) {
        param->printBf(context);
        ret.push_back(std::move(ctx.ret));
    }
    auto get = [&ret](size_t index) { return std::move(std::get<Var>(ret[index])); };
    auto get_int = [&ret](size_t index) { return std::get<int>(ret[index]); };
    switch (inst) {
        // other instruments
        case Inst::Jump: {
            unsigned target = ctx.getBlockPC(content);
            auto _ = tape.comment("jump {}", target);
            ctx.pc = target;
            break;
        }
        case Inst::Branch: {
            Var exp = get(0);
            unsigned block_pc1 = get_int(1), block_pc2 = get_int(2);
            auto _ = tape.comment("jump ${} ? {} : {}", exp, block_pc1, block_pc2);
            tape.cond(
                std::move(exp),  //
                [&] { ctx.pc = block_pc1; }, [&] { ctx.pc = block_pc2; });
            break;
        }
        case Inst::Label: {
            ctx.label_end(), ctx.label_end = []() {};
            unsigned pc = ctx.getBlockPC(content);
            tape.record(
                std::format("; BLOCK {}(PC: {}):", content.length() ? content : "entry", pc));
            auto recurse_guard = std::make_shared<Tape::RecurseGuard>(&tape);
            auto tmp =
                std::make_shared<Var>(tape.alloc());  // std::function only supports copy,
                                                      // and std::move_only_function requires c++23
            tape.eq(tape.clone(ctx.pc), tape.createInteger(pc), *tmp);
            tape.jump(*tmp), tape.record("[-");
            ctx.label_end = [this, tmp, context, recurse_guard]() {
                auto _ = context->tape.comment("ENDBLOCK {}",
                                               this->content.length() ? this->content : "entry");
                context->tape.jump(*tmp), context->tape.record("]");
            };
            break;
        }
    }
}
```

# 一些问题

当前的架构很难支持函数递归调用栈，下一步的改进计划是引入栈`cell`，把现在写死的通过`alloc`获得的变量地址改成相对寻址。

进一步地，或许可以将 PC 的粒度调细，一条指令一个 PC，将指令 opcode 以及操作数写入`cell`中，通过译码一条一条执行，这样就能更方便地计算栈空间，而不是像现在这样在各种算术运算中生成大量临时的`clone cell`
