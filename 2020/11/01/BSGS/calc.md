---
title: 多项式部分运算
tags:
  - 学习笔记
  - poly
categories:
  - oi
  - 学习笔记
  - 数学
  - 多项式
mathjax: true
comment: true
date: 2021-03-23 19:38:40
---

## 乘法

NTT

构造模意义单位根。

发现 $\delta_pg^k=\dfrac{(p-1)}{\gcd(k, p -1)}$，当 $n|(p-1)$ 时， $\delta_pg^{(p-1)/n}=\dfrac{(p-1)}{\gcd(\frac{p-1}{n}, p-1)}=n$ 

令 $\omega_n=g^{(p-1)/n}$ ，则 $\omega_n^0,\omega_n^1,\cdots,\omega_n^{n-1}$ 互不相同，且有：

- $\omega_{2n}^{2k}=(g^{(p-1)/2n})^{2k}=(g^{(p-1)/n})^{k}=\omega_n^k$。
- $w_n^n=g^{p-1}=1$
- $\omega_n^{n/2}=g^{(p-1)/2}=-1$（任何数 $a$ 满足 $a^{\varphi(p)/2}\equiv \pm1\pmod p$，显然 $g^{\varphi(p)/2}\neq1$）
- $\omega_n^{k+n/2}=-\omega_n^k$

一些实现上的细节：

- 使用 `unsigned long long` ，避开部分取模
- 关于代码中的 `std::reverse(f + 1, f + n)`：

（咕）

