---
title: 莫比乌斯反演
tags:
  - 学习笔记
  - 莫比乌斯反演
  - 积性函数
categories:
  - oi
  - 数学
  - 数论
mathjax: true
comment: true
date: 2021-05-29 09:44:13
---

本来是考试的，但是数论忘了，只好滚去学数论。

### 性质

若 $f(x)$ 和 $g(x)$ 均为积性函数，则以下函数也为积性函数：

$$
\begin{aligned}
h(x)&=f(x^p)\\
h(x)&=f^p(x)\\
h(x)&=f(x)g(x)\\
h(x)&=\sum_{d\mid x}f(d)g(\frac{x}{d})
\end{aligned}
$$

设 $x=\prod p_i^{k_i}$ 

若 $F(x)$ 为积性函数，则有 $F(x)=\prod F(p_i^{k_i})$ 。

若 $F(x)$ 为完全积性函数，则有 $F(X)=\prod F(p_i)^{k_i}$ 。

### 例子

- 单位函数： $\epsilon(n)=[n=1]$ （完全积性）
- 恒等函数： $\operatorname{id}_k(n)=n^k$  $\operatorname{id}_{1}(n)$ 通常简记作 $\operatorname{id}(n)$ 。（完全积性）
- 常数函数： $1(n)=1$ （完全积性）
- 除数函数： $\sigma_{k}(n)=\sum_{d\mid n}d^{k}$  $\sigma_{0}(n)$ 通常简记作 $\operatorname{d}(n)$ 或 $\tau(n)$ ， $\sigma_{1}(n)$ 通常简记作 $\sigma(n)$ 。
- 欧拉函数： $\varphi(n)=\sum_{i=1}^n [\gcd(i,n)=1]$ 
- 莫比乌斯函数： $\mu(n) = \begin{cases}1 & n=1 \\ 0 & \exists d>1:d^{2} \mid n \\ (-1)^{\omega(n)} & otherwise\end{cases}$ ，其中 $\omega(n)$ 表示 $n$ 的本质不同质因子个数，它是一个加性函数。
