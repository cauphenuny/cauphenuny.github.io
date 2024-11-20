---
title: 欧拉函数习题
tags:
  - 数学
  - 数论
categories:
  - oi
  - 学习笔记
  - 数学
  - 数论
mathjax: true
date: 2020-10-25 18:23:37
---
[acwing202. 最幸运的数字](https://www.acwing.com/problem/content/204/)

---
[P2398 GCD SUM](https://www.luogu.com.cn/problem/solution/P2398)

> 给定 $n$ ，求 $\sum\limits_{i=1}^{n}\sum\limits_{j=1}^{n}\gcd(i,j)$     数据范围：$n\leq10^5$

<!-- more -->
不需要反演也能做！

挨个枚举 $i,j$ 复杂度太高，考虑枚举 $\gcd(i,j)$ 的值。

对于所有 $\gcd(x,y)=1$，有 $\gcd(xk,yk)=k\quad(xk\leq n,yk\le n)$

所以 $\gcd(i,j)=k$ 的 $i,j$ 的个数为：$2\sum\limits_{i=1}^{\lfloor n/k\rfloor}\varphi(i)-1$

为什么要减一呢？因为 $(1,1)$ 算了两遍。

预处理 $\varphi(i)$ ，再计算前缀和即可。

$O(n)$

Tips: 记住筛 $\varphi$ 的时候别写锅了↓

```cpp
void init(int n) {
    phi[0] = 0;
    phi[1] = 1;
    for (int i = 2; i <= n; i++) {
        if (!vis[i]) {
            pri[++tot] = i;
            phi[i] = i - 1;//就是这里，之前忘记写了，还过了样例
        }
        for (int j = 1; j <= tot; j++) {
            if (pri[j] * i > n) break;
            vis[pri[j] * i] = 1;
            if (i % pri[j]) {
                phi[pri[j] * i] = phi[i] * (pri[j] - 1);
            } else {
                phi[pri[j] * i] = phi[i] * (pri[j]);
                break;
            }
        }
    }
}
```

----

[UVA10179 Irreducable Basic Fractions](https://www.luogu.com.cn/problem/UVA10179)

单点求 $\varphi$ 板子题

```cpp
int phi(int x) {
    int res = x;
    for (int i = 2; i * i <= x; i++) {
        if (x % i == 0) {
            res = res / i * (i - 1);
            while (x % i == 0) x /= i;
        }
    }
    if (x > 1) res = res / x * (x - 1); //记得是 if(x > 1)，不是 if(x)
    return res;
}
```

---

[UVA11426 拿行李（极限版） GCD - Extreme (II)](https://www.luogu.com.cn/problem/UVA11426)

> 给定 $n$ ，求 $\sum\limits_{i=1}^{n}\sum\limits_{j=i+1}^{n}\gcd(i,j)$

$ans=\sum\limits_{i=1}^{n}\left(i\left(\sum\limits_{j=1}^{\lfloor n/i\rfloor}\varphi(j)-1\right)\right)$

~~七倍经验题~~

----

[CF906D Power Tower](https://www.luogu.com.cn/problem/CF906D)

> 给定 $w_{1\ldots n}$  和 $p$ ，有 $m$ 个询问区间 $[l,r]$ ，求$w_l^{w_{l+1}^{w_{l+2}...^{w_r}}}\bmod p$ 的值

欧拉函数降幂

记住，不能这么写↓

```cpp
int dfs(int l, int r, int p) {
    if (p <= 1) return 0;
    if (l == r) return w[l] % p;
    return power(w[l], (dfs(l + 1, r, getphi(p)))+ getphi(p), p); //你不知道 dfs(l + 1, r) 是不是大于 $\varphi(p)$
}
```

求 $a^b\bmod p$ 的时候要注意：

```cpp
int power(int a, int b, int p) {
    int res = 1;
    while (b) {
        if (b & 1) {
            res = res * a;
            if (res >= p)
                res = res % p + p; //由于要做下一级的幂指数，所以要加上上一级的 $\varphi(p)$ ，即这一级 p 的值
        }
        b >>= 1;
        a *= a;
        if (a >= p) 
            a = a % p + p;
    }
    return res;
}
```

----

[P3934 (Ynoi2016)炸脖龙I](https://www.luogu.com.cn/problem/P3934)

就是上面这个题，套一个树状数组区间修改单点插询

注意：

```cpp
int power(int a, int b, int p) {
    int res = 1;
    if (a >= p) 
        a = a % p + p;//取模，防止爆long long
    while (b) {
        if (b & 1) {
            res = res * a;
            if (res >= p)
                res = res % p + p;
        }
        b >>= 1;
        a *= a;
        if (a >= p) 
            a = a % p + p;
    }
    return res;
}
```

---

