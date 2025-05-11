---
title: 线性代数复习
date: 2024-01-11 23:08:36
tags:
  - 数学
  - 线性代数
  - 抽象代数
categories:
  - 课程记录
  - 数学
  - 线性代数
description: 考前复习
---

# 线性代数 I

## 引入

### 线性方程组 4

### 集合与映射 16

### 置换

### 基础数论 29

## 矩阵

### 行和列的向量空间 32

### 线性映射与矩阵运算 43

秩等式/不等式汇总

- $\mathrm{rank} A+\dim\ker\varphi_A=n$

  高斯消元后，主元个数为 $\mathrm{rank}A$ 其他变量个数为 $\dim\ker\varphi_A$。

- $\mathrm{rank}(AB)<= \min(\mathrm{rank}(A),\mathrm{rank}(B))$

- $C=\begin{pmatrix}A&0\\0&B\end{pmatrix}$ 则 $\mathrm{rank}(C)=\mathrm{rank}(A)+\mathrm{rank}(B)$

- $M=\begin{pmatrix}A&C\\0&B\end{pmatrix}$ 则 $\mathrm{rank}(M) \geq \mathrm{rank}(A) + \mathrm{rank}(B)$

  证明：
  
  令 $\mathrm{rank}(A)=a, \mathrm{rank}(B)=b$
  
  则 $A$ 存在 $a$ 阶满秩子矩阵 $A_1$ ，$B$ 存在 $b$ 阶满秩子矩阵 $B_1$
  
  $M$ 存在一个 $a+b$ 阶子式 $\left|\begin{array}{}A_1&C_1\\0&B_1\end{array}\right|=|A_1||B_1|\neq0$
  
  所以 $\mathrm{rank}\begin{pmatrix}A_1&C_1\\0&B_1\end{pmatrix}=a+b$
  
  $\mathrm{rank}(M)\geq\mathrm{rank}\begin{pmatrix}A_1&C_1\\0&B_1\end{pmatrix}=a+b$


- $\mathrm{rank} AB \geq \mathrm{rank}A+\mathrm{rank}B-n$

  证明：
  
  $\begin{pmatrix}AB&0\\0&I\end{pmatrix}\to\begin{pmatrix}AB&0\\B&I\end{pmatrix}\to\begin{pmatrix}0&-A\\B&I\end{pmatrix}\to\begin{pmatrix}A&I\\0&B\end{pmatrix}$

- $n$ 阶方阵 $A$ 是幂等矩阵（$A^2=A$）的充要条件是：$\mathrm{rank}(A)+\mathrm{rank}(I-A)=n$

  证明：

$$A^2=A\Leftrightarrow\mathrm{rank}(A^2-A)=0$$

$$\begin{pmatrix}A&0\\0&I-A\end{pmatrix}\to\begin{pmatrix}A&0\\A&I-A\end{pmatrix}\to\begin{pmatrix}A&A\\A&I\end{pmatrix}\\\to\begin{pmatrix}A-A^2&0\\A&I\end{pmatrix}\to\begin{pmatrix}A-A^2&0\\0&I\end{pmatrix}$$

- $n$ 阶方阵 $A$ 是对合矩阵 $A^2=I$ 的充要条件是 $\mathrm{rank}(I+A)+\mathrm{rank}(I-A)=n$

$$
\begin{pmatrix}I+A&0\\0&I-A\end{pmatrix}\to\begin{pmatrix}I+A&I-A\\0&I-A\end{pmatrix}\to\begin{pmatrix}2I&I-A\\I-A&I-A\end{pmatrix}\\\to\begin{pmatrix}2I&I-A\\-(A+I)&0\end{pmatrix}\to\begin{pmatrix}2I&0\\-(A+I)&-\dfrac{(A-I)(A+I)}{2}\end{pmatrix}
$$

- $\mathrm{rank}(ABC)+\mathrm{rank}(B)\geq\mathrm{rank}(AB)+\mathrm{rank}(BC)$

$$
\begin{pmatrix}ABC&0\\0&B\end{pmatrix}
\to
\begin{pmatrix}ABC&0\\BC&B\end{pmatrix}
\to
\begin{pmatrix}0&-AB\\BC&B\end{pmatrix}
$$

  reference: [矩阵的秩的不等式汇总及其部分证明](https://zhuanlan.zhihu.com/p/341263037)[EB/OL]. 2021-04-15

## 行列式

### 构造和刻画 65

$\det: (\mathbb{R}^n)^n\to\mathbb{R}$
满足如下性质：
- 多重线性
- 斜对称
- $\det I_n=1$

### 行列展开 70

- $\det A=\det {^tA}$

  证明：利用 $\varepsilon_\sigma=\varepsilon_{\sigma^{-1}}$，$\det A=\sum\limits_{\sigma\in S_n}\varepsilon_\sigma a_{1\sigma(1)}a_{2\sigma(2)}\cdots a_{n\sigma(n)}$

- 代数余子式：$A_{ij}=(-1)^{i+j}M_{ij}$，其中 $A\binom{i}{j}$ 为从 $A$ 中划去第 $i$ 行和第 $j$ 列所剩下的 $(n-1)\times(n-1)$ 矩阵, 而 $M_{ij}=\left|A\binom{i}{j}\right|$ 称为矩阵 $A$ 对应于元素 $a_{ij}$ 的子式。

- 按行展开：
$$
\begin{aligned}
\det A=&\det(\vec a_{(1)},\vec a_{(2)},\ldots,\vec a_{(n)})\\
=&\det(\sum\limits_{j=1}^na_{1j}\vec{e_j},\vec{a_{(2)}},\ldots,\vec{a_{(n)}})\\
=&\sum\limits_{j=1}^n\det(a_{1j}\vec{e_j},\vec{a_{(2)}},\ldots,\vec{a_{(n)}})\\
=&\sum\limits_{j=1}^na_{1j}A_{1j}
\end{aligned}
$$

$$
\begin{aligned}
\det A=&\det(\vec a_{(1)},\vec a_{(2)},\ldots,\vec a_{(i)},\ldots,\vec a_{(n)})\qquad(2\leq i\leq n)\\
=&(-1)^{i-1}\det(\vec{a_{(i)}},\vec{a_{(2)}},\ldots,\vec{a_{(i-1)}},\vec{a_{(i+1)}},\ldots,\vec{a_{(n)}})\\
=&(-1)^{i-1}\sum\limits_{j=1}^n(-1)^{1+j}a_{ij}M_{ij}\\
=&\sum\limits_{j=1}^n(-1)^{i+j}a_{ij}M_{ij}\\
=&\sum\limits_{j=1}^na_{ij}A_{ij}
\end{aligned}
$$

- **范德蒙行列式**

$$
\begin{aligned}
\Delta(x_1,x_2,x_3,\ldots,x_n)=&\left|\begin{array}{c}
1&1&1&\cdots&1\\
x_1&x_2&x_3&\cdots&x_n\\
{x_1}^2&{x_2}^2&{x_3}^2&\cdots&{x_n}^2\\
\vdots&\vdots&\vdots&\vdots&\vdots\\
{x_1}^{n-1}&{x_2}^{n-1}&{x_3}^{n-1}&\cdots&{x_n}^{n-1}\\
\end{array}{}\right|\\
=&(x_2-x_1)(x_3-x_1)\cdots(x_n-1)\Delta(x_2,x_3,\ldots,x_n)\qquad(\mathrm{row}_i\mapsto \mathrm{row_i}-x_1\times\mathrm{row_{i-1}})\\
=&\prod\limits_{1\leq i< j\leq n}(x_j-x_i)
\end{aligned}
$$

### 特性 76

- $\det\begin{pmatrix}A&C\\0&B\end{pmatrix}=\left|\begin{array}{c}A&C\\0&I_m\end{array}\right|\cdot\det B=\det A\cdot\det B$

- $\det A\cdot \det B=\det AB,\det{^tA}=\det A$

- 设 $1\leq r\leq\min(m, n)$，对 $1\leq i_1<i_2<\cdots<i_r\leq n$ 和 $1\leq j_1<j_2<\cdots<j_r\leq n$ ，$A\begin{pmatrix}i_1&i_2&\cdots&i_r\\j_1&j_2&\cdots&j_r\end{pmatrix}$ 表示 $A$ 中处于第 $i_1,i_2,\ldots,i_r$ 行和 $j_1,j_2,\ldots,j_r$ 列交叉处元素构成的 $r\times r$方阵。

  行列式 $A\left\{\begin{matrix}i_1&i_2&\cdots&i_r\\j_1&j_2&\cdots&j_r\end{matrix}\right\}=\left|A\left(\begin{matrix}i_1&i_2&\cdots&i_r\\j_1&j_2&\cdots&j_r\end{matrix}\right)\right|$ 称为 $A$ 的一个 $r$ 阶子式。

- 矩阵 $A$ 的秩等于其非零子式的极大阶。
  
  hint:

  设极大阶非零子式为 $M=A\left\{\begin{matrix}i_1&i_2&\cdots&i_r\\j_1&j_2&\cdots&j_r\end{matrix}\right\}$

  $\forall i, j$ 构造行列式
  $$
  |\widetilde M|=\left|\begin{matrix}
  a_{ij}&a_{ij_1}&a_{ij_2}&\cdots&a_{ij_r}\\
  a_{i_1j}&a_{i_1j_1}&a_{ij_2}&\cdots&a_{ij_r}\\
  a_{i_2j}&a_{i_2j_1}&a_{i_2j_2}&\cdots&a_{i_2j_r}\\
  \vdots&\vdots&\vdots&\ddots&\vdots\\
  a_{i_rj}&a_{i_rj_1}&a_{i_rj_2}&\cdots&a_{i_rj_r}\\
  \end{matrix}\right|
  $$

  若 $i\in\{i_1,i_2,\ldots,i_r\}$ 或 $j\in\{j_1,j_2,\ldots,j_r\}$ 则 $\widetilde M$ 中有两行或两列相同 $\Rightarrow |\widetilde{M}|=0$
  
  否则，因为 $\widetilde{M}$ 阶大于 $r$ ，所以 $|\widetilde{M}|=0$

  然后对 $\widetilde{M}$ 按第一列展开。

### 伴随矩阵 80

- $\sum\limits_{r=1}^na_{jr}A_{ir}$ 表示把 $|A|$ 中第 $i$ 行用第 $j$ 行替代所得的行列式。
  
  因此，$\sum\limits_{r=1}^na_{jr}A_{ir}=0\qquad(i\neq j)$

- **伴随矩阵：**

  $$
  A^{\vee}=\begin{pmatrix}
  A_{11}&A_{21}&\cdots&A_{n1}\\
  A_{12}&A_{22}&\cdots&A_{n2}\\
  A_{1n}&A_{2n}&\cdots&A_{nn}\\
  \end{pmatrix}
  $$

  **注意：行列交换**

  于是 $\{AA^\vee\}_{ji}=\sum\limits_{r=1}^na_{ji}A_{ir}=\left\{\begin{aligned}|&A|\quad &j=i\\&0\quad &j\neq i\end{aligned}\right.$

  所以 $AA^\vee=|A|\cdot I_n$

- **克拉默公式**

  对于非退化矩阵 $A$，$A\vec{x}=\vec{b}$ 有唯一解

  $$
  x_1=\dfrac{|A_1|}{|A|},x_2=\dfrac{|A_2|}{|A|},\cdots x_n=\dfrac{|A_n|}{|A|}
  $$

  其中 $A_i=\sum\limits_{r=1}^n b_rA_{ri}$

### Laplace 展开 & Binet-Cauchy 公式 83

- 记 $A\left[\begin{matrix}i_1&i_2&\cdots&i_r\\j_1&j_2&\cdots&j_r\end{matrix}\right]$ 为 $A$ 划去 $i_1,i_r,...,i_r$ 行和 $j_1,j_2,...,j_r$ 列剩下的 $(n-r)\times(n-r)$ 方阵的行列式。

- **(Laplace)** 对于 $n$ 阶方阵 $A$ 和固定的行指标 $1\leq i_1<i_2<\cdots<i_r\leq n$

  $$
  |A|=\sum\limits_{1\leq j_1<j_2<\cdots<j_r\leq n}(-1)^{\sum\limits_{p=1}^r i_p+\sum\limits_{p=1}^rj_p}A\left\{\begin{matrix}i_1&i_2&\cdots&i_r\\j_1&j_2&\cdots&j_r\end{matrix}\right\}A\left[\begin{matrix}i_1&i_2&\cdots&i_r\\j_1&j_2&\cdots&j_r\end{matrix}\right]
  $$

- **(Binet-Cauchy)** 
  设 $m\leq n, A=(a_{ij})_{m\times n},B=(b_{ji})_{n\times m}$ 则
  $$
  |AB|=\sum\limits_{1\leq i_1<i_2<\cdots<i_m\leq n}A\left\{\begin{matrix}1&2&\cdots&m\\i_1&i_2&\cdots&i_m\end{matrix}\right\}B\left\{\begin{matrix}i_1&i_2&\cdots&i_m\\1&2&\cdots&m\end{matrix}\right\}
  $$

  $m=2$ 时，有 **Cauchy 恒等式**

  $$
  (\sum\limits_{r=1}^na_{1r}b_{r1})(\sum\limits_{r=1}^na_{2r}b_{r2})-(\sum\limits_{r=1}^na_{1r}b_{r2})(\sum\limits_{r=1}^na_{2r}b_{r1})=\sum\limits_{1\leq r<s\leq n}(a_{1r}a_{2s}-a_{1s}b_{2r})(b_{r1}b_{s2}-b_{r2}b_{s1})
  $$

## 群环域

### 群的基本定义 86

- **半群**：集合 $X$ 关于运算 $*:X\times X\to X$ 构成一个半群：$\forall a,b,c\in X$ 结合律 $a*(b*c)=(a*b)*c$ 成立。

  含单位元的半群称为**幺半群**。

  每个元素都可逆的幺半群称为**群**。

  任意两个元素可交换的群称为**交换群/阿贝尔群**。

  如果存在最小正整数 $k$ 使得 $a^k=e$ 则 $a$ 具有有限阶 $k$.

- 群 $G$ 的一个非空子集 $H$ 称为子群，如果 $\forall a,b\in H, ab^{-1}\in H$（充要条件：关于取逆映射和群乘积封闭）

- 一般线性群 $GL_n(\mathbb{R})=\{A\in M_{n\times n}(\mathbb{R})|\det A\neq 0\}$
  
  特殊线性群 $SL_n(\mathbb{R})=\{A\in M_{n\times n}(\mathbb{R})|\det A=1\}$，其元素对应线性变换保持 $^n\mathbb{R}$中平行多面体的体积。

- 正交群 $O_n(\mathbb{R})=\{A\in M_{n\times n}(\mathbb{R})|^tA\cdot A=I_n\}$ 构成 $GL_n(\mathbb R)$ 的子群。其元素对应线性变换保持$^n\mathbb R$ 的欧几里得内积。

  e.g. $O_2(\mathbb R)=\left\{\begin{pmatrix}\cos\theta&\sin\theta\\-\sin\theta&\cos\theta\end{pmatrix},\begin{pmatrix}-\cos\theta&-\sin\theta\\-\sin\theta&\cos\theta\end{pmatrix}|\theta\in\mathbb R\right\}$

  $O_n(\mathbb{R})$ 的子群 $SO_n(\mathbb{R})=O_n(\mathbb R)\cap SL_n(\mathbb R)$ 是 $^n \mathbb R$ 中旋转变换全体对应的群。

  dihedral 群：（$\Phi_n$ 是平面上重心在原点且有一条对称轴在 $y$ 轴上的正 $n$ 边形）
  $$
  \begin{aligned}
  D_{2n}=&\left\{A\in O_2(\mathbb R)|A(\Psi_n)=\Psi_n\right\}\\
  =&\{R^i,\sigma R^i\mid i=0,1,...,n-1\},\sigma^2=I_2,R^n=I_2,\sigma R\sigma^{-1}=R^{-1}
  \end{aligned}
  $$

  交错群：置换群 $S_n$ 中偶置换全体 $A_n$。

  模群 $SL_2(\mathbb Z)=\left\{\begin{pmatrix}a&b\\c&d\end{pmatrix}|a,b,c,d\in\mathbb Z, ad-bc=1\right\}=\left\langle\begin{pmatrix}1&1\\0&1\end{pmatrix},\begin{pmatrix}0&-1\\1&0\end{pmatrix}\right\rangle$

### 群同态 91

- 设 $H$ 为子群
  
  左陪集 $dH=\{dh|h\in H\}$ 是等价关系 $a\thicksim_H b\Leftrightarrow\exists h\in H, \mathrm{s.t.} a=h$ 的等价类。

  $G/\thicksim_H=\{aH|a\in G\}$ 记为 $G/H$ 称为 $G$ 子群的左商空间。

- 群阶：元素个数 $|G|$

- $H$ 在 $G$ 中的指标 $[G:H]$：不同陪集的个数 $|G/H|$

- **(Lagrange)** 对群 $G$ 及它的子群 $H$ 有 $|G|=[G:H]\cdot |H|$
  
  特别地，一个有限群元素的阶整除群的阶。

- $H$ 是 $G$ 的**正规子群**，记为 $H\unlhd G$，如果 $\forall a\in G,h\in H$ 有 $aha^{-1}\in H$，即 $aHa^{-1}\in H$。等价定义：左右陪集相等。

  可推出 $G/H$ 上有群乘积 $aH\cdot bH=abH$。
  单位元：$eH$

  $G/H$ 称为 $G$ 模 $H$ 的商群。

  一个交换群的任意子群是正规子群。

- 群同态 $\varphi:G\to G'$ 是满足 $\varphi(a\cdot b)=\varphi(a)\cdot\varphi(b)$ 的映射。
  
  $\Rightarrow\varphi(e)=e',\varphi(a)^{-1}=\varphi(a^{-1}),\varphi(a)\varphi(b)=\varphi(ab)$

  $\Rightarrow\varphi(G)$ 是 $G'$ 的子群。

- 令 $\ker_\varphi=\{a\in G\mid\varphi(a)=e'\}$
  
  由定义可证得 $\ker_\varphi$ 是 $G$ 的正规子群。

  $\ker_\varphi=\{e\}\Leftrightarrow\varphi$ 是单射。

- 若 $\varphi$ 是双射，称 $\varphi$ 是从 $G$ 到 $G'$ 的同构，记为 $G\overset{\varphi}{\cong} G'$

- 若 $\varphi(G)=G'$ 则 $\bar\varphi:a(\ker_\varphi)\mapsto\varphi(a)$ 是从商群 $G/\ker_\varphi$ 到 $G'$ 的同构。
  
  即：$G/\ker_\varphi\overset{\bar\varphi}\cong\varphi(G)$

- 设 $H\unlhd G$，$a\mapsto aH$ 是从 $G$ 到 $G/H$ 的自然同态。

- 设 $G$ 是一个有限群，$a,b\in G$ 是两个不交换的二阶元，则 $\langle a,b\rangle\cong$ 一个 dihedral 群。（proof: 95）

  hint:

  1. $n\geq3$ (反证 $n\neq2$)

  2. $asa=s^{-1}\Rightarrow as^i=(asa)^i=s^{-i}\quad(s=ab)$

  3. $\langle a,b\rangle=H=\{a^rs^i\mid r=0,1;i=0,1,...,n-1\}$ 

      $\forall i,as^i\neq e\Rightarrow|H|=2n$
  
  4. $D_{2n}=\{R^i,\sigma R^i\mid i=0,1,...,n-1\},\sigma^2=I_2,R^n=I_2,\sigma R\sigma^{-1}=R^{-1}$
  5. $\varphi:H\to D_{2n}:a^rs^i\mapsto\sigma^rR^i$

- 群 $G$ 到自身的同构称为**自同构**。
  
  e.g. 内自同构：$\mathcal{I}_g(a)=gag^{-1}$

  自同构全体 $\mathrm{Aut}(G)$ 关于映射乘积构成一个群，称为自同构群。

- 设 $G$ 是有限群，若 $G$ 有 2 阶自同构 $\varphi$ 满足 $\varphi(a)=a\Rightarrow a=e$ 则 $G$ 是交换群。
  
  hint:

  1. 证明 $\varphi(a)a^{-1}=\varphi(b)b^{-1}\Rightarrow a=b$
  
      于是有 $|\{\varphi(a)a^{-1}|a\in G\}|=|G|\Rightarrow G=\{\varphi(a)a^{-1}|a\in G\}$
  
  2. $g=\varphi(a)a^{-1}$ 则 $\varphi(g)=\varphi(\varphi(a)a^{-1})=g^{-1}$ （利用 2 阶自同构 $\varphi^2(a)=a$）

  3. $g_1g_2=(g_2^{-1}g_1^{-1})^{-1}=g_2g_1$

### 群作用 97

- 群 $G$ 在 $X$ 上的一个作用是 $G\times X\to X$ 的一个映射 $(g,x)\mapsto g(x)$，满足：
  
  1. $e(x)=x$
  2. $(g_1g_2)(x)=g_1(g_2(x))$

  给定 $g\in G$，定义 $X$ 上的变换 $\varphi(g)$：$\varphi(g)(x)=g(x)$ 则有：$\varphi(e)=e_X,\varphi(g_1g_2)=\varphi(g_1)\varphi(g_2)$
  
  可推出 $\varphi:G\to S_X$ 是群同态。反之，给定群同态 $\varphi:G\to S_X$ 映射 $(g,x)\mapsto\varphi(g)(x)$ 给出了 $G$ 在 $X$ 上的一个作用。

- 设 $G$ 是有限群，$n=|G|$ 定义左乘变换 $L_g(a)=ga\quad a\in G$ 则映射 $g\mapsto L_g$ 是 $G$ 到 $S_G\cong S_n$ 的单同态。
  
  $\Rightarrow$ 任意 $n$ 阶群同构于 $S_n$ 的某个子群。（某个：用于构造满射）

- $\forall x\in X,\mathcal{O}_x=\{g(x)\mid g\in G\}$ 是 $x$ 在 $G$ 作用下的轨道。称为 $x$ 的 $G$-轨道。

  定义 $X$ 上一个关系 $\sim_G:x\sim_Gy,\text{if }\exists g\in G, y=g(x)$ 可推出 $\sim_G$ 是一个等价关系，其等价类为 $\mathcal O_x$。

  $G_x=\{g\in G\mid g(x)=x\}$ 是 $x$ 的稳定化子，易得其为子群。

  映射 $gG_x\mapsto g(x)$ 给出了商空间 $G/G_x$ 到 $\mathcal O_x$ 的1-1对应。若 $\mathcal O_x$ 有限，则 $|\mathcal O_x|=[G:G_x]$

  $G$-轨道集合给出了 $X$ 的一个不交并。

- 若 $p$ 是一个素数，$|G|=p^n,n>0$ 则称 $G$ 为 $p$ 群。

- $G$ 的中心：$\mathscr C(G)=\{c\in G\mid \forall g\in G, cg=gc\}$

- 若 $G$ 是一个 $p$ 群，则 $p$ 整除 $|\mathscr C(G)|$

  证明：取共轭作用 $g(x)=gxg^{-1},\quad g\in G,x\in X$ 则有

  $x\in \mathscr{C}(G)\Leftrightarrow G_x=G\Leftrightarrow |\mathcal O_x|=1$ 反之 $|\mathcal{O}_x|=[G:G_x]=p^{r_x}, r_x>0$

  设 $\{\mathcal{O}_{x_1},\mathcal{O}_{x_2},...,\mathcal{O}_{x_s}\}$ 是大于 1 的不同 G-轨道全体，那么

  $$
  G=\mathscr{C}\cup\bigcup\limits_{i=1}^s\mathcal{O}_{x_i}\Rightarrow|G|=|\mathscr{C}|+\sum\limits_ip^{r_{x_i}}
  $$

  故 $p$ 整除 $\mathscr{C}(G)$


- 设 $n=mp^r$，其中 $m,r\in \N,\gcd(m,p)=1$。设 $s\in\N,s\leq r$，下面证明 $p^{r-s}|\binom{n}{p^s},p^{r-s+1}\nmid\binom n{p^s}$。
  
  $\forall 1\leq i\leq p^s-1$，设 $i=j_ip^{t_i}\quad (j_i\in\N,t_i<s,\gcd(j_i,p)=1)$

  $n-i=p^{t_i}(mp^{r-t_i}-j_i),\quad p^s-i=p^{t_i}(p^{s-t_i}-j_i)$

  故
  $$
  \binom{n}{p^s}=\dfrac{n\prod_{i=1}^{p^s-1}(n-i)}{p^s\prod_{i=1}^{p^s-1}(p^s-i)}=mp^{r-s}\dfrac{\prod_{i=1}^{p^s-1}(mp^{r-t_i}-j_i)}{\prod_{i=1}^{p^s-1}(p^{s-t_i}-j_i)}
  $$

- **(Sylow I)**
  
  设 $G$ 是阶为 $n=mp^r$ 的有限群，其中 $m,r\in\N,\gcd(m,p)=1$ 对任意 $s\in\N,s\leq r$，$G$ 含有阶为 $p^s$ 的子群。

  证：令 $X=\{S\subset G\mid |S|=p^s\}$，则 $|X|=\binom{n}{p^s}$

  有 $G$ 在 $X$ 上的作用 $g(s)=\{ga\mid g\in S\}$，故 $X=\bigcup_{i=1}^k\mathcal{O}_{S_i}$ 是 G-轨道的不交并。
  $$
  \binom n{p^s}=|X|=\sum\limits_{i=1}^k[G:G_{S_i}]
  $$

  由上述定理 $\exist i\leq k,p^{r-s+1}\nmid[G:G_{S_{i}}]$ 故 $[G:G_{S_i}]$ 中含 $p$ 的幂次不超过 $r-s$ 又 $mp^r=|G|=[G:G_{S_i}]\cdot|G_{S_i}|$ 所以 $p^s\mid |G_{S_i}|$。

  取定 $a\in S_i$ 则 $\forall g\in G_{S_i},g(S_i)=S_i\Rightarrow ga\in S_i$ 

  所以 $p^s\leq |G_{S_i}|=|G_{S_i}(a)|\leq |S_i|=p^s$

  所以 $G_{s_i}$ 是阶为 $p^s$ 的子群

  特别地，$p^r$ 阶子群称为 Sylow p 子群。

- **(Cauchy)** 如果 $p\in\mathrm{prime}$ 整除 $|G|$，则 $G$ 含阶为 $p$ 的元素。(在 **Sylow I** 中取 $s=1$)

- **(Sylow II)** 设 $|G|=n=mp^r,\gcd(m,p)=1$，$P$ 是 $G$ 的一个 Sylow p子群，$H$ 是 $G$ 的 $p^s$ 阶子群，则 $\exist p\in G, gHg^{-1}\subset P$ 特别地，$s=r$ 时 $gHg^{-1}=P$ 即 任意两个 Sylow p子群共轭。
  
  证： 在商空间 $G/P$ 上有群 $H$ 的作用：$h(aP)=(ha)P\quad(a\in G,h\in H)$

  $G/P=\bigcup_{i}\mathcal O_{a_iP}$ 是 H-轨道的不交并。$|\mathcal{O}_{a_iP}|=[H:H_{a_iP}]=p^{s_i}$

  $m=|G/P|=\sum\limits_i|\mathcal{O}_{a_iP}|=\sum\limits_ip^{s_i}$

  $\gcd(m,p)=1$ 故 $\exists i_0,\text{s.t. }s_{i_0}=0\Rightarrow H_{a_{i_0}P}=H$

  令 $g=a_{i_0}^{-1}$ 则。$\forall h\in H, \exist b\in P, \text{s.t. } ha_{i_0}=a_{i_0}b$ (proof. $\forall h\in H, ha_iP=a_iP\Rightarrow ha_{i_0}e=a_{i_0}b$) $\Leftrightarrow a_{i_0}^{-1}ha_{i_0}=b\Leftrightarrow ghg^{-1}=b\in P$

  所以 $gHg^{-1}\subset P$


- **(Sylow III)** 设 $|G|=n=mp^r,\gcd(m,p)=1$，$P$ 为 $G$ 的一个 Sylow p子群，记 $k$ 为 $G$ 中 $Sylow p$ 子群的个数。则 $k|m,p|(k-1)$ 特别地 $k=1\Leftrightarrow$ P 是正规子群。
  
  记 $X$ 为 $G$ 中 Sylow p子群集合，$G$ 在 $X$ 上的共轭作用：$g(P_1)=gP_1g^{-1}\in X$ . 有上文定理 $X$ 只有一个 G-轨道，所以 $P$ 是正规子群的充要条件是 $k=1$ 

  $X=G(P)\Rightarrow k=|X|=\mathcal{O}_P=[G:G_P]$

  $P\subset G_P$ 是 $G_P$ 的子群，$m=[G:P]=[G:G_P][G_P:P]$ 所以 $k|m$

  若对于某个 $P_1\in X$，其 P-轨道只有一个元素（$\forall b\in P, bP_1b^{-1}=P_1$）。

  根据 Sylow 第二定理，$\exists g \in G, \text{s.t. } P_1=gPg^{-1}$ 代入上式 $\Rightarrow \forall b\in P, bgPg^{-1}b^{-1}=gPg^{-1}\Leftrightarrow (g^{-1}bg)P(g^{-1}bg)^{-1}=P$

  故 $\forall b\in P, g^{-1}bg\in G_P\Rightarrow g^{-1}Pg\in G_P$

  因此，$P$ 和 $g^{-1}Pg$ 都是 $G_P$ 的 Sylow p 子群（注意此处 $g$ 非任意），根据 Sylow 第二定理，$\exists g_1\in G_P, \text{s.t. }g^{-1}Pg=g_1Pg_1^{-1}$

  又由稳定化子定义，$g_1Pg_1^{-1}=P$。由假设 $g^{-1}Pg=P\Rightarrow P=gPg^{-1}=P_1$。

### 有限群的结构* 101

- 直积：在 $G\times G'$ 上定义乘积 
  $$
  (a,a')\cdot(b,b')=(a\cdot b,a'\cdot b')\quad a,b\in G,a'b'\in G'
  $$
  则 $(G\times G',\cdot,(e,e'))$ 构成群 $(G,\cdot,e)$ 和 $(G',\cdot,e')$ 的直积。

- 设 $p\in\mathrm{prime}$, $G$ 为 $p^2$ 群，则 $G\cong \Z_{p^2}$ 或 $\Z_p\times\Z_p$

- 给定群 $H$ $K$ 和群同态 $\varphi:H\to \text{Aut }K$ 在 $K\times H$ 上定义运算
  
  $$
  (a_1,b_1)\cdot(a_2,b_2)=(a_1\cdot \varphi(b_1)(a_2),b_1\cdot b_2)\quad a_1,a_2\in K,b_1,b_2\in H
  $$

  则 $K\times H$ 关于上述运算构成群，称为半直积 $K\rtimes H$，单位元 $(e_1,e_2)$ 逆元 $(\varphi(b_1^{-1})(a_1^{-1}))\cdot(a_1,b_1)$

  若 K 和 H 都是交换群，则 $K\rtimes H$ 是交换群的充要条件是 $\varphi(H)=\{e_K\}$ （hint：考虑 $(e_1,b)(a,e_2)(e_1,b)^{-1}$）

### 环和域 108

## 多项式

### 单变元多项式环 113

### 因式分解 118





对于线性映射 $\varphi :{^n\R}\to {^m\R}$ 存在线性映射 $\psi:{^m\R}\to{^n\R}$ 使得 $\varphi\circ\psi\circ\varphi=\varphi$ 以及 $\psi\circ\varphi\circ\psi=\psi$

### 多项式的根

#### 结式

设 $f(x)=a_nx^n+a_{n-1}x^{n-1}+\cdots+a_0,\quad g(x)=b_mx^m+b_{m-1}x^{m-1}+\cdots+b_0$

则 $\gcd(f(x),g(x))\ne 1\Leftrightarrow \exists h_1(x),h_2(x)\in \mathbb F[x],\text{s.t. }h_1(x)f(x)+h_2(x)g(x)=0,\deg h_1(x)<m,\deg h_2(x)<n$

证明：充分性显然。必要性：若右式成立且 $\gcd = 1$ 则 $f(x) \mid -h_2(x)g(x)$，又 $\gcd(f(x),g(x))=1$ 则 $f(x)\mid h_2(x)$，与次数假设矛盾。

下面求出 $h_1,h_2$。

设 $h_1(x)=c_{m-1}x^{m-1}+c_{m-2}x^{m-2}+\cdots+c_0,h_2(x)=d_{n-1}x^{n-1}+c_{n-2}x^{n-2}+\cdots+d_0$

代入方程 $h_1(x)f(x)+h_2(x)g(x)=0$ 得到关于 $c_i,d_i$ 的方程组

系数行列式为 

$$
R(f,g)=
\left|\begin{matrix}
a_n& & & &b_m & & &\\
a_{n-1}&a_n&&&b_{m-1}&b_m
\end{matrix}\right|
$$


