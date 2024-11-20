---
title: C++20 新特性试玩：concept
date: 2024-04-19 13:52:09
tags:
  - CS
  - C++
categories:
  - CS
  - cpp
---

定义 concept
```cpp
template<typename T>
concept c = (bool_expression);
```

`requires(args) {...}` 可以作为一个 bool 表达式，检查大括号中内容是否编译通过

e.g.

```cpp
template <typename T>
concept printable = requires(std::ostream& os, T a) { os << a; };
```

`requires` 字句也能嵌套，这样就不用把两个无关的条件参数写到同一个括号里面。

```cpp
template <typename T>
concept Field = 
```

`<concepts>` 头文件内有一些预定义的 `concept`

```cpp

```

可以做到根据性质不同实例化不同的代码，也能在模版实例化出错时大幅减少错误信息，提高可读性

```cpp
template <typename T>
concept addable = requires(T a, T b) { a += b; a + b; };

template <typename T>
concept printable = requires(std::ostream& os, T a) { os << a; };

template <typename T, typename V> 
concept divisible = requires(T a, V b) { a / b; a /= b; };

template <typename T, typename V>
concept multipliable = requires(T a, V b) { a * b; a *= b; };

class Matrix<T> {
  public:
  
    ...
      
    //根据矩阵是否能进行取逆操作执行不同的函数
      
    Matrix<T> operator^(unsigned p) requires (!divisible<T, T>) {
        assert(rsize() == csize());
        Matrix<T> base = (*this);
        Matrix<T> ans = id(rsize());
        while (p) {
            if (p & 1) {
                ans *= base;
            }
            base *= base;
            p /= 2;
        }
        return ans;
    }
    Matrix<T> operator^(int p) requires divisible<T, T> {
        assert(rsize() == csize());
        Matrix<T> base = (*this);
        Matrix<T> ans = id(rsize());
        if (p < 0) {
            base = base.inverse();
            p = -p;
        }
        while (p) {
            if (p & 1) {
                ans *= base;
            }
            base *= base;
            p /= 2;
        }
        return ans;
    }
}

```

