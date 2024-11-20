---
title: 快速沃尔什变换 
tags:
  - FWT
categories:
  - oi
  - 学习笔记
  - 数学
  - 多项式
mathjax: true
comment: true
date: 2021-03-22 19:55:34
---

快速沃尔什变换也许是快速地求位运算卷积的一种方法。

给定序列 $A$ 和 $B$ ，求 $C$，满足 $c_i=\sum\limits_{i=j\oplus k}a_jb_k$，其中 $\oplus$ 是某种运算。

与 FFT 一样， FWT 有几个流程，先将 $A,B$ 变换为 $\operatorname{FWT}(A),\operatorname{FWT}(B)$，再计算 $\operatorname{FWT}(C)_i=\operatorname{FWT}(A)_i\times\operatorname{FWT}(B)_i$，最后将 $\operatorname{FWT}(C)$ 转换回 $C$。

总之，是 $O(n\log n)$ — $O(n)$ — $O(n\log n)$ 的三步。

$\operatorname{FWT}$ 是根据不同的运算构造的。

## or

即 $C_i=\sum\limits_{i=j|k}a_jb_k$

构造 $\operatorname{FWT}(A)_i=\sum\limits_{j|i=i}a_j$

这样有 
$$
\begin{aligned}
\operatorname{FWT}(A)_i\times\operatorname{FWT}(B)_i
&=\sum\limits_{j|i=i}a_j\times\sum\limits_{k|i=i}b_k\\
&=\sum\limits_{j|i=i,k|i=i}a_jb_k\\
&=\sum\limits_{(j|i)=i}a_jb_k\\
&=\operatorname{FWT}(C)_i
\end{aligned}
$$

求 $\operatorname{FWT}(A)$ 的过程可以考虑递归。

设 $A_0,A_1$ 是$A$ 的前半和后半部分，则 $A_0$ 与 $A_1$ 只有最高位的区别，$A_1$ 的子集一定包括 $A_0$ 的子集。

$\operatorname{FWT}(A)=\operatorname{merge}(\operatorname{FWT}(A_0), \operatorname{FWT}(A_0)+\operatorname{FWT}(A_1))$ ，其中 $\operatorname{merge}$ 是将两个序列拼接。

逆变换 $\operatorname{IFWT}(A)=\operatorname{merge}(\operatorname{IFWT}(A_0), \operatorname{IFWT}(A_1)-\operatorname{IFWT}(A_0))$

代码

咕咕咕

## and

类似地，构造 $\operatorname{FWT}(A)=\sum\limits_{i\operatorname{and}j=i}a_i$。

有 $\operatorname{FWT}(A)=\operatorname{merge}(\operatorname{FWT}(A_0)+\operatorname{FWT}(A_1),\operatorname{FWT}(A_1))$。  

$\operatorname{IFWT}(A)=\operatorname{merge}(\operatorname{IFWT}(A_0)-\operatorname{IFWT}(A_1), \operatorname{IFWT}(A_1))$

## xor

重载运算符 $x\otimes y=(\operatorname{popcount}(x\operatorname{xor} y))\bmod 2$ 。

可以发现性质  ~~没有性质我还要这运算符有何用~~ $(x\otimes y)\operatorname{xor}(x\otimes z)=x\otimes (y\operatorname{xor}z)$

定义 $\operatorname{FWT}(A)_i=\sum\limits_{i\otimes j=0}a_j-\sum\limits_{i\otimes j=1}a_j$

然后推一推
$$
\begin{aligned}
\operatorname{FWT}(A)_i\times \operatorname{FWT}(B)_i=&(\sum\limits_{i\otimes j=0}a_j-\sum\limits_{i\otimes j=1}a_j)(\sum\limits_{i\otimes k=0}b_k-\sum\limits_{i\otimes k=1}b_k)\\
=&\sum\limits_{i\otimes j=0}a_j\sum\limits_{i\otimes k=0}b_k-\sum\limits_{i\otimes j=1}a_j\sum\limits_{i\otimes k=0}b_k-\sum\limits_{i\otimes j=0}a_j\sum\limits_{i\otimes k=0}b_k+\sum\limits_{i\otimes j=1}a_j\sum\limits_{i\otimes k=1}b_k\\
=&\sum\limits_{i\otimes (j\operatorname{xor}k)=0}a_jb_k-\sum\limits_{i\otimes (j\operatorname{xor}k)=1}a_jb_k\\
=&\operatorname{FWT}(C)_i
\end{aligned}
$$
理解一下

考虑自底向上合并计算 $\operatorname{FWT}$ 的过程，每次考虑的是当前长度为 $2^x$ 的序列里的低 $x$ 位，左边的部分最高位是 $0$, 右边部分最高位是 $1$，则有公式 $\operatorname{FWT}(A)=\operatorname{merge}(\operatorname{FWT}(A_0)+\operatorname{FWT}(A_1),\operatorname{FWT}(A_0)-\operatorname{FWT}(A_1))$

