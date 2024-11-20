---
title: CF372C Watching Fireworks is Fun
tags:
  - dp
  - 单调队列
categories:
  - oi
  - 总结
  - dp
mathjax: true
comment: true
date: 2021-02-06 14:33:07
---
[CF372C Watching Fireworks is Fun](https://www.luogu.com.cn/problem/CF372C)

**单调队列优化区间 dp**

设 $f(i,j)$ 表示放到第 $i$ 个烟花，当前在 $j$ 的位置，设可以在两次烟花之间的移动距离为 $s$ 可以发现
$$
f(i,j)=\min\limits_{j-s\le k\le j +s}(f(i,k))+b_i-\vert a_i-j\vert
$$
用单调队列维护，加滚动数组，时间复杂度 $O(nm)$ ，空间复杂度 $O(n)$
