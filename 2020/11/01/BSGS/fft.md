---
title: FFT 笔记
tags:
  - 多项式
  - FFT
categories:
  - oi
  - 学习笔记
  - 多项式
mathjax: true
comment: true
date: 2021-02-08 16:37:59
---

~~防止过了几个月就忘了~~

单位复根 $\omega_n=e^{\frac{2\pi i}{n}}=\cos\left(\dfrac{2\pi}{n}\right)+i\cdot \sin\left(\dfrac{2\pi}{n}\right)$

性质
$$
\begin{aligned}
\omega_n^n&=1\\
\omega_n^k&=\omega_{2n}^{2k}\\
\omega_{2n}^{k+n}&=-\omega_{2n}^k\\
\end{aligned}
$$
位逆序置换：
$$
R(x)=\left\lfloor \frac{R\left(\left\lfloor \frac{x}{2} \right\rfloor\right)}{2} \right\rfloor + (x\bmod 2)\times \frac{len}{2}
$$
IDFT（傅里叶反变换）的作用，是把目标多项式的点值形式转换成系数形式。我们把单位复根代入多项式之后，就是下面这个样子（矩阵表示方程组）

$$
\begin{bmatrix}y_0 \\ y_1 \\ y_2 \\ y_3 \\ \vdots \\ y_{n-1} \end{bmatrix}
=
\begin{bmatrix}1 & 1 & 1 & 1 & \cdots & 1 \\
1 & \omega_n^1 & \omega_n^2 & \omega_n^3 & \cdots & \omega_n^{n-1} \\
1 & \omega_n^2 & \omega_n^4 & \omega_n^6 & \cdots & \omega_n^{2(n-1)} \\
1 & \omega_n^3 & \omega_n^6 & \omega_n^9 & \cdots & \omega_n^{3(n-1)} \\
\vdots & \vdots & \vdots & \vdots & \ddots & \vdots \\
1 & \omega_n^{n-1} & \omega_n^{2(n-1)} & \omega_n^{3(n-1)} & \cdots & \omega_n^{(n-1)^2} \end{bmatrix}
\begin{bmatrix} a_0 \\ a_1 \\ a_2 \\ a_3 \\ \vdots \\ a_{n-1} \end{bmatrix}
$$

现在我们已经得到最左边的结果了，中间的 $x$ 值在目标多项式的点值表示中也是一一对应的，所以，根据矩阵的基础知识，我们只要在式子两边左乘中间那个大矩阵的逆矩阵就行了。由于这个矩阵的元素非常特殊，他的逆矩阵也有特殊的性质，就是每一项取倒数，再除以 $n$ ，就能得到他的逆矩阵。

为了使计算的结果为原来的倒数，根据单位复根的性质并结合欧拉公式，可以得到

$$
\frac{1}{\omega_k}=\omega_k^{-1}=e^{-\frac{2\pi i}{k}}=\cos\left(\frac{2\pi}{k}\right)+i\cdot \sin\left(-\frac{2\pi}{k}\right)
$$

因此我们可以尝试着把 $π$ 取成 - 3.14159…，这样我们的计算结果就会变成原来的倒数，而其它的操作过程与 DFT 是完全相同的。我们可以定义一个函数，在里面加一个参数 $1$ 或者是 $-1$ ，然后把它乘到 $π$ 的身上。传入 $1$ 就是 DFT，传入 $-1$ 就是 IDFT。



---

以上为 `Ctrl-c` `Ctrl-v` 结果。

---

```cpp
//author: ycp | https://ycpedef.github.io
//#pragma GCC diagnostic error "-std=c++11"
//#pragma GCC optimize(2)
#include <iostream>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <cstdarg>
#include <cmath>
#include <complex>
#define debug(x) cerr << #x << " = " << x << endl
#define debugf(...) fprintf(stderr, __VA_ARGS__)
#define debugs(x) fputs(x"\n", stderr)
using namespace std;
template <class T> bool cmax(T &a, T b) { return b > a ? (a = b, 1) : 0; }
template <class T> bool cmin(T &a, T b) { return b < a ? (a = b, 1) : 0; }
template <class T> void read(T &a) {
    a = 0; char c = getchar(); int f = 0;
    while (!isdigit(c)) { f ^= c == '-',  c = getchar(); }
    while (isdigit(c)) { a = a * 10 + (c ^ 48),  c = getchar(); }
    a *= f ? -1 : 1;
}
struct Fastin {
    template <class T> Fastin& operator >> (T &x) {read(x); return *this;}
} fastin;

template <typename T>
class Complex {
    T a, b;
    public:
    Complex(T new_a = 0., T new_b = 0.): a(new_a), b(new_b) {}
    Complex(const Complex<T> &cur): a(cur.a), b(cur.b) {}
    friend Complex<T> operator - (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a - z2.a, z1.b - z2.b);
    }
    friend Complex<T> operator + (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a + z2.a, z1.b + z2.b);
    }
    friend Complex<T> operator * (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a * z2.a - z1.b * z2.b, z1.b * z2.a + z1.a * z2.b);
    }
    T real() { return a; }
    T imag() { return b; }
    void real(T cur) { a = cur; }
    void imag(T cur) { b = cur; }
    void print() { cout << a << " + " << b << "i" << endl; }
};

typedef Complex<long double> comp;

const long double pi = acos(-1);

const int MAXN = 4e6 + 10;

void change(comp f[], int len) {
    static int rev[MAXN];
    for (int i = 0; i < len; i++) {
        rev[i] = rev[i >> 1] >> 1;
        rev[i] |= (i & 1) * (len >> 1);
    }
    for (int i = 0; i < len; i++) {
        if (i < rev[i]) {
            swap(f[i], f[rev[i]]);
        }
    }
}

void fft(comp f[], int len, int mode) {
    change(f, len);
    for (int n = 2; n <= len; n <<= 1) {
        comp wn(cos(2 * pi / n), sin(2 * pi * mode / n));
        for (int st = 0; st < len; st += n) {
            comp cur(1, 0);
            for (int k = st; k < st + n / 2; k++) {
                comp u = f[k], v = cur * f[k + n / 2];
                f[k] = u + v, f[k + n / 2] = u - v;
                cur = cur * wn;
            }
        }
    }
    if (mode == -1) {
        for (int i = 0; i < len; i++) {
            f[i].real(f[i].real() / len);
        }
    }
}

int n, m, len;
comp f[MAXN], g[MAXN], res[MAXN];

int main() {
    fastin >> n >> m;
    len = 1;
    while (len < n * 2 || len < m * 2) len <<= 1;
    for (int i = 0, x; i <= n; i++) {
        fastin >> x;
        f[i] = comp((long double)x);
    }
    for (int i = 0, x; i <= m; i++) {
        fastin >> x;
        g[i] = comp((long double)x);
    }
    fft(f, len, 1);
    fft(g, len, 1);
    for (int i = 0; i <= len; i++) {
        res[i] = f[i] * g[i];
    }
    fft(res, len, -1);
    for (int i = 0; i <= n + m; i++) {
        printf("%lld ", (long long)round(res[i].real()));
    }
    return 0;
}
```

---

另：赠送带 template 的复数模板一只。

```cpp
//Complex.h

template <typename T>
class Complex {
    T a, b;
    public:
    Complex(T new_a = 0., T new_b = 0.): a(new_a), b(new_b) {}
    Complex(const Complex<T> &cur): a(cur.a), b(cur.b) {}
    friend Complex<T> operator - (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a - z2.a, z1.b - z2.b);
    }
    friend Complex<T> operator + (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a + z2.a, z1.b + z2.b);
    }
    friend Complex<T> operator * (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a * z2.a - z1.b * z2.b, z1.b * z2.a + z1.a * z2.b);
    }
    T real() { return a; }
    T imag() { return b; }
    void real(T cur) { a = cur; }
    void imag(T cur) { b = cur; }
    void print() { cout << a << " + " << b << "i"; }
    typedef basic_ostream<char>& type;
    friend type operator << (type out, Complex<T> z) { z.print(); return out; } //cout输出
};
```

记得**四舍五入**
