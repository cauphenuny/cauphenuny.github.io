---
title: 换根dp
date: 2020-10-09 20:02:11
tags: [dp]
mathjax: true
categories: [oi,学习笔记,dp]
---

----

先看一个题目 [CF161D Distance in Tree](https://www.luogu.com.cn/problem/CF161D)

考虑 dp（当然点分治也可以做），先求出 $f(u,k)$ 表示将树中的 $u$ 作为根节点后，深度为 $k$ 的节点数量，则答案为 $\dfrac{\sum_{u\in G}f(u,k)}{2}$。

<!-- more -->

可以暴力求 $f$ 数组，复杂度 $O(n^2k)$。

优化一下，先以 $1$ 为根节点，求出从每个点 $u$ 开始，向下走 $k$ 的路径条数 $g(u,k)$

设节点 $u$ 的一个儿子是 $v$ 。观察到如果求出了 $f(u,k)$ 那么求 $f(v,k)$ 可以利用一下信息。

![](change-root-dp/01.png)

红色部分显然是 $g(v,k)$ ，蓝色部分是 $f(u,k-1)$，但是这样有一部分会多计算，就是那些以 $u$ 为端点，长度为 $k-1$ ，经过了红色部分的路径。减去 $g(v,k-2)$ 即可。

$$f(v,k)=g(v,k)+f(u,k-1)-g(v,k-2)$$

复杂度 $O(nk)$

----


