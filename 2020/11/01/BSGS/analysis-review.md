---
title: 数分定义定理回顾
date: 2023-11-18 22:05:33
tags: 
  - 数学分析
categories:
  - 课程记录
  - 数学
  - 数学分析
description: 考前复习
---

## 第一章

**规定** 任何实数都可用确定的无限小数表示

**定义 1.1** 给定两个非负实数，$a<=>b$ 定义由按位比较给出。

**定义 1.2** n位不足近似
$$x_n=a_0.a_1\cdots a_n$$

n位过剩近似
$$\bar{x}_n=x_n+\dfrac1{10^n}$$

**命题** $x>y$ 的等价条件是：$\exist n\in\N,x_n>\bar{y}_n$

**实数集的性质**

1. 对四则运算封闭
2. 有序
3. 大小具有传递性
4. 阿基米德性：$\forall a, b\in\mathbb{R},b>a>0,\exist n, \text{ s.t. } na>b$
5. 稠密性

邻域&区间：

$U(a;\delta)=\{x||x-a|<\delta\}=(a-\delta,a+\delta)$

$U\mathring{\space}(a;\delta)=\{x|0<|x-a|<\delta\}$

$U(\infty)=\{x||x|>M\}$

$U(+\infty)=\{x|x>M\}$

$U(-\infty)=\{x|x<-M\}$

**定义 2.1**   
上界/下界：略  
有界集：即有上界又有下界，反之：无界集

**定义 2.2**

上确界 $\eta=\sup S$：上界 $\forall x\in S, x\leq \eta$ + 最小上界 $\forall\alpha<\eta,\exist x_0\in S\text{ s.t. }x_0>\alpha$

下确界 $\xi=\inf S$

**定理 1.1（确界原理）** 

设 $S$ 为非空数集，若 $S$ 有上界，则必有上确界；有下界则必有下确界

证明思路：不断逼近，区间十等份，取 $n_k$ 使得
$$
\forall x\in S, x<n.n_1n_2\cdots n_k+\dfrac1{10^k}\\\exist a_k\in S, a_k >= n.n_1n_2\cdots n_k
$$

得到实数 $\eta=n.n_1n_2\cdots n_k\cdots$

证明

1. $\forall x\in S, x\leq \eta$
2. $\forall \alpha<\eta,\exist\alpha'\in S, \alpha<\alpha'$

随后使用反证法

## 第二章

**定义 1.1** 数列$\{a_n\}$ 收敛于 $a$，$a$ 称为数列 $\{a_n\}$ 的极限：略

**定义 1.1'** 任给 $\varepsilon>0$ 若在 $U(a;\varepsilon)$ 之外数列 $\{a_n} 中的项最多只有有限个，则称数列 $\{a_n} 收敛于极限 $a$.

**定义 1.2** $\{a_n\}$ 为无穷小数列：若 $\lim\limits_{n\to\infty}a_n = 0$

**定义 1.3** $\{a_n\}$ 发散于无穷大，记作 $\lim\limits_{n\to\infty}a_n=\infty$ 或 $a_n\to\infty$，称 $\{a_n\}$ 为无穷大数列或无穷大量：若 $\{a_n\}$ 满足：$\forall M>0,\exists N, \text{s.t.} \forall n>N,|a_n|>M$

注意：无界数列不一定是无穷大量 $\text{e.g. }\{[1+(-1)^n]n\}$

**定义 1.4** $\{a_n\}$ 发散于正（负）无穷大，略

**定理 2.2~2.6（收敛数列的性质）** 

  - 「唯一性」
  - 「有界性」
  - 「保号性」
  - 「保不等式性」
  - 「迫敛性」

**定理 2.7（四则运算法则）** 

描述略. 下面证明关于积和倒数的结论：

积：
  $|a_nb_n-ab|=|(a_n-a)b_n+a(b_n-b)|\leq|a_n-a||b_n|+|a||b_n-b|$
    
  「有界性」$\Rightarrow\exist M>0, \forall n, \text{ s.t. }|b_n|<M$
    
  故 $|a_nb_n-ab|<(M+|a|)\varepsilon$

倒数：

  「保号性」$\Rightarrow\exist N_1, \text{ s.t.} |b_n|>\dfrac12|b|.$
  定义：$\exist N_2, |b_n-b|<\varepsilon, \text{when } n>N_2$ 
  故 $n>\max{N_1,N_2}$ 时 $\left|\dfrac1{b_n}-\dfrac{1}{b}\right|=\dfrac{|b_n-b|}{|b_nb|}<\dfrac{2|b_n-b|}{b^2}<\dfrac{2\varepsilon}{b^2}$

**定义 2.1** 称数列 $\{a_n\}$ 的一个子列 $\{a_{n_k}\}$，当$\{n_k\}$ 为正整数集 $\mathbb{N}_+$ 的无限子集，且 $n_1<n_2<\cdots<n_k<\cdots$

**定理 2.8** $\{a_n\}$ 收敛的充要条件是 $\{a_n\}$ 的任何子列都收敛.

  充分性：$\{a_n\}$ 也是自身的一个子列.  
  必要性：略

**定理 2.9** （单调有界定理）在实数系中，有界的单调数列必有极限.

**定理 2.10** 任何数列都存在单调字列

  分两种情况讨论：
  1. 若对任意正整数 $k$ 数列 $\{a_{k+n}\}$ 有最大项，设