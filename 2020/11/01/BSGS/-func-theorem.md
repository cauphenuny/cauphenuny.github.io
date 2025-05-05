---
title: 欧拉函数结论
mathjax: true
date: 2020-10-25 12:50:52
tags: [数学,数论]
categories: [oi,学习笔记,数学,数论]
comment: true
---

- **$\forall n>1$ ，$1$ ~ $n$中与 $n$ 互质的数的和为 $\dfrac{1}{2}n\times\varphi(n)$**

  证明：$gcd(n,x)=gcd(n,n-x)$，所以与 $n$ 互质的数成对出现，平均数为 $n/2$ 。 
  
- **若 p 为素数， $\varphi(p^k)=p^k(1-\dfrac{1}{p})=p^{k-1}(p-1)$**


- $\varphi(n)=n(1-\dfrac{1}{p_1})(1-\dfrac{1}{p_2})\ldots(1-\dfrac{1}{p_k})$

  证明：容斥


<!-- more -->


-  **若 $a$， $b$ 互质，则 $\varphi(a)\varphi(b)=\varphi(ab)$**

  代入上式可证
  
  
  
- **若 $a$，$n$ 互质，则$a^{\varphi(n)}\equiv1$**

  证明：

  设 $n$ 简化剩余系为 $\{a_1,a_2\cdots a_n\}$ 

  当 $a_i,a_j$ 代表不同同余类，则 $aa_i,aa_j$ 代表不同剩余类，证明略。

  因为简化剩余系关于乘法封闭，所以 $aa_i$ 也在集合中，所以 $\{aa_1,aa_2\cdots aa_n\}$ 也能表示模 $n$ 的简化剩余系。

  $a^{\varphi(n)}a_1a_2\cdots a_{\varphi(n)}\equiv(aa_1)(aa_2)\cdots(aa_{\varphi(n)})\equiv a_1a_2\cdots a_n$

  

- **p 是质数且 $p\mid n$ ，若 $p^2\mid n$ 则 $\varphi(n)=\varphi(n/p)\times p$**

  证明：写出 $\varphi(n)$ 和 $\varphi(n/p)$ 的计算式，只有 $p$ 项质数相差 $1$ ，即 $\varphi(n)=\varphi(n/p)\times p$ 

  

- **p 是质数且 $p\mid n$ ，若 $p^2\nmid n$ 则 $\varphi(n)=\varphi(n/p)\times (p-1)$**

  证明：$p$ 与 $n/p$ 互质，则 $\varphi(n)=\varphi(n/p)\varphi(p)=\varphi(n/p)\times(p-1)$

  

- $\sum_{d|n}\varphi(d)=n$

  证明：

  ​    设 $f(n)=\sum_{d|n}\varphi(d)$ 

  ​    若 $n$，$m$ 互质，则 $f(nm)=\sum_{d|nm}\varphi(d)=(\sum_{d_1|n}\varphi(d_1))\times(\sum_{d_2|m}\varphi(d_2))=f(n)f(m)$（理解：对于每一个 $d_1$， $d_2$都有一个唯一的 $d=d_1d_2$ ，与 $nm$ 的因数一一对应）

  ​    所以 $\sum_{d|n}\varphi(d)$ 是积性函数。

  ​    对于 $f(p^m)$ ，有 $f(p^m)=\sum_{d|p^m}\varphi(d)=\varphi(1)+\varphi(p)+\varphi(p^2)+\cdots+\varphi(p^m)=1+(p-1)+p(p-1)+p^2(p-1)+\cdots+p^{m-1}(p-1)$

  ​    用一下等比数列求和公式，容易得到后面的东西就是 $p^m$

  ​    设 $f(n)=\prod\limits_{i=1}^{k}p_i^{c_i}$，则 $f(n)=\prod\limits_{i=1}^kf(p_i^{c_i})=\prod\limits_{i=1}^kp_i^{c_i}=n$

  

- **若 a，n 互质，则满足 $a^x\equiv1\pmod n$ 的最小正整数 $x_0$ 是 $\varphi(n)$ 的约数**

  证明：

  反证，若 $x_0\nmid\varphi(n)$ ，设 $\varphi(n)=qx_0+r\quad(0<r<x_0)$ ，因为 $a^{x_0}\equiv1$，所以 $a^{qx_0}\equiv1$ 。

  又有 $a^{\varphi(n)}\equiv1$ ，所以 $a^r\equiv1$ ，与 $x_0$ 最小矛盾。

  [例题：最幸运的数字（acwing202）](https://www.acwing.com/problem/content/204/)


