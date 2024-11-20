---
title: 给C++实现一个模式匹配
date: 2024-11-08 22:40:28
tags:
  - CS
  - cpp
categories:
  - CS
  - cpp
description: 没用的小玩具
abstract: 没用的小玩具
---

好吧标题党了，所谓“模式匹配”只是给把`std::visit`包装了一下，只能匹配类型，功能远不及其他语言。

效果：

```cpp
using T = std::variant<int, double>;
T v = 1.414;

T v2 = Match{v}(
    [](int x) -> T {
        std::cout << "get int value: " << x << std::endl;
        return x * x;
    },
    [](double x) -> T {
        std::cout << "get double value: " << x << std::endl;
        return x * x;
    }
);

Match{v2}(
    [](auto x) { std::cout << x << std::endl; }
);

/*******************************/

Match{std::move(ret)}(
    [&](Context::Int val)   { str += std::format("  li a0, {}\n", val); },
    [&](Context::Stack st)  { str += std::format("  lw a0, {}(sp)\n", st); },
    [&](Context::Reg&& reg) { str += std::format("  mv a0, {}\n", reg); },
    [&](auto&& s) { throw std::runtime_error("invalid type"); }
);
```

看着还是很像模式匹配的，可读性比`std::visit`头重脚轻的参数高点

---

首先定义一个辅助类，将不同类型的参数匹配到具体不同的`operator()`

```cpp
template <typename... Ts> struct Visitor : Ts... {
    using Ts::operator()...;
};

template <typename... Ts> Visitor(Ts...) -> Visitor<Ts...>; // 辅助编译器推导类型
```

然后是`Match`类，存一个引用以便于在`operator()`中调用`std::visit`

```cpp
template <typename T> struct Match {
    T value;
    Match(T&& value) : value(std::forward<T>(value)) {}
    template <typename... Ts> auto operator()(Ts&&... params) {
        return std::visit(Visitor{std::forward<Ts>(params)...}, std::forward<T>(value));
    }
    template <typename... Ts> auto operator()(Visitor<Ts...> visitor) {
        return std::visit(visitor, std::forward<T>(value));
    }
};

template <typename T> Match(T&&) -> Match<T&&>;
```

