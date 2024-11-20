---
title: 拉格朗日插值
tags:
  - 数学
  - 多项式
categories:
  - oi
  - 学习笔记
  - 数学
  - 多项式
mathjax: true
date: 2020-10-23 19:29:56
---
[oi-wiki](https://oi-wiki.org/math/poly/lagrange/)

----

给出 $n$ 个点 $P_i(x_i,y_i)$，将过这 $n$ 个点的最多 $n-1$ 次（为什么是 $n-1$ 次：因为可以构造出 $n$ 个线性方程，只能解出从常数项系数到 $n-1$ 次项的系数）的多项式记为 $f(x)$ ，求 $f(k)$ 的值。

 <!-- more -->

----

![](lagrange/lagrange-interpolation.png)

如图所示，将每一个点在 $x$ 轴上的投影 $(x_i,y_i)$ 记为 $H_i$ 。对每一个 $i$ ，我们选择一个点集 $\{P_i\}\cup\{H_j|1\le i\le n,i\neq j\}$ ，作过这 $n$ 个点的至多 $n-1$ 次的线 $g_i(x)$ 。图中 $f(x)$ 用黑线表示，$g_i(x)$ 用彩色线表示。

这样得到的 $g_i(x)$ 在各自对应的 $x_i$ 处取得 $y_i$ 的值，在 $x_j(j\neq i)$ 处取得 $0$。

构造出 $g_i(x)$ 表达式：
$$
g_i(x)=y_i\prod\limits_{j\neq i}\dfrac{x-x_j}{x_i-x_j}
$$
代入 $x_i$ 可得 $g_i(x)=y_i\prod_{j\neq i}\dfrac{x_i-x_j}{x_i-x_j}=y_i$

代入 $x_j(j\neq i)$ ，$g_i(x)=y_i\prod_{k\neq i}\dfrac{x_j-x_k}{x_i-x_k}=y_i\times0=0$

将所有的 $g_i(x)$ 求和即可得到 $f(x)$ ，即
$$
f(x)=\sum_{i=1}^ny_i\prod_{j\neq i}\dfrac{x-x_j}{x_i-x_j}
$$
求出 $f(k)$ 
$$
f(k)=\sum_{i=1}^ny_i\prod_{j\neq i}\dfrac{k-x_j}{x_i-x_j}
$$
可以把分子分母都计算出来，再计算一遍逆元，复杂度 $O(n^2)$

----
