---
title: Bézout定理
tags:
  - Bézout定理
categories:
  - oi
  - 学习笔记
  - 数学
  - 数论
KaTeX: true
date: 2020-10-26 19:26:34
---
### 定理

----

**存在整数 $x$，$y$ 使得 $ax+by=\gcd(a,b)$**

证明：

考虑求 $\gcd(a,b)$ 的过程，
$$
\gcd(a,b)\to\gcd(b,r_1)\to\gcd(r_1,r_2)\to\cdots\to\gcd(r_{n-1},r_n)=1
$$

<!-- more -->

拆开取模成带余除法
$$
\begin{aligned}
a&=bx_1+r_1\\
b_1&=r_1x_2+r_2\\
r_1&=r_2x_3+r_3\\
&\cdots\\
r_{n-3}&=r_{n-2}x_{n-1}+r_{n-1}&\quad(1)\\
r_{n-2}&=r_{n-1}x_{n}+r_n&(2)\\
r_{n-1}&=r_{n}x_{n+1}\\
\end{aligned}
$$
辗转相除到 $r_n=1$ 时退出，由 $(2)$ 式 $r_{n-2}=x_nr_{n-1}+r_n$ 得：
$$
1=r_{n-2}-x_nr_{n-1}\quad(3)
$$
将 $(1)$ 式 $r_{n-1}=r_{n-3}-r_{n-2}x_{n-1}$ 代入 $(3)$ 式，得 $1=(1+x_nx_{n-1})r_{n-2}-x_nr_{n-3}$ 成功消去 $r_{n-1}$ ，再一步步递归，就能消去 $r_{n-2},r_{n-3},\cdots,r_1$ 然后就能得到关于 $a$ 和 $b$ 的式子了。

----

### 一道题目

[CF510D Fox And Jumping](https://www.luogu.com.cn/problem/CF510D)

> 给出 $n$ 张卡片，分别有 $l_i$ 和 $c_i$。在一条无限长的纸带上，你可以选择花 $c_i$ 的钱来购买卡片 $i$，从此以后可以向左或向右跳 $l_i$ 个单位。问你至少花多少元钱才能够跳到纸带上全部位置。若不行，输出 $-1$。

就是求在 $n$ 个数中选出若干个 $\gcd=1$ 的数的最小代价。

抽象一点，设当前到达的位置为 $x$  ，代价为 $d$ ，可以枚举 $1...n$ ，用 $d+c_i$ 更新 $\gcd(x,l_i)$ 的值，相当于从 $x$ 节点到 $\gcd(x,l_i)$ 连一条长为 $c_i$ 的边，跑一遍从 $0$ 到 $1$ 的最短路，求出 $d_1$ 即可。

节点编号是原始数据 $l$ 的值域，发现区间较大，可以用 `unordered_map` 代替标记数组。

注意细节：

```cpp
typedef long long ll;
typedef pair<ll, int> pii;

unordered_map <int, bool> vis;
unordered_map <int, ll> dis;
priority_queue <pii, vector<pii>, greater<pii>> q;

void calc() {
    dis[0] = 0;
    q.push(make_pair(0, 0));
    memset(&inf, 0x3f, sizeof(decltype(inf)));
    while (q.size()) {
        int u = q.top().second;
        q.pop();
        if (vis.find(u) != vis.end()) continue;
        vis[u] = true;
        if (u == 1) break;
        for (int i = 1, v; i <= n; i++) {
            v = gcd(u, l[i]);
            if (dis.find(v) == dis.end()) {//记住不是 vis.find(v) != vis.end()，因为有可能 dis 有值而还没有遍历到
                dis[v] = inf;
            }
            if (dis[v] > dis[u] + c[i]) {  
                dis[v] = dis[u] + c[i];
                q.push(make_pair(dis[v], v));
            }
        }
    }
    if (vis.find(1) == vis.end()) {
        cout << -1 << endl;
    } else {
        cout << dis[1] << endl;
    }
}
```
