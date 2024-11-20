---
title: 树形背包优化
date: 2020-10-10 20:53:58
tags: [dp,背包]
categories: [oi,学习笔记]
---

转：[link](https://www.luogu.com.cn/blog/rhdeng/post-chang-jian-shu-shang-bei-bao-you-hua-ji-qiao)

题意:给你一颗树,每个点有一个权值,每条边可以留下或删除,问有多少种方案使得1所在的连通块中所有点的权值和恰好为 $K$.

<!-- more -->

   暴力 $n^3$:

```cpp
int dfs(int u, int fa) {
    sum[u] = val[u];
    dp[u][val[u]] = 1;
    for (int i = head[u]; i; i = edges[i].nex) {
        int v = edges[i].to;
        if (v == fa) continue;
        dfs(v, u);
        sum[u] += sum[v];
        for (int j = min(sum[u], K); j >= val[u]; --j) {
            dp[u][j] = 1ll * dp[u][j] * (1 + dp[v][0]) % mod;
            for (int k = max(1, val[v]); k <= min(sum[v], j - val[u]); ++k)
                (dp[u][j] += 1ll * dp[u][j - k] * dp[v][k] % mod) %= mod;
        }
    }
}
```

   "常见"优化技巧: $dp[u][i]$ 不再是在 $u$ 子树中的答案, 而是递归到 $u$ 时所形成的连通块的答案.更重要的是,在递归儿子 $v$ 时, 把当前 $u$的所有答案先传给 $v$, 回溯时直接加回来就好了.

```cpp
void dfs(int u, int fa) {
    siz[v] = 1;
    dp[u][val[u]] = 1;
    for (int i = head[u]; i; i = edges[i].nex) {
        int v = edges[i].to;
        if (v == fa) continue;
        for (int j = 0; j + val[i] <= K; ++j)
            dp[v][j + val[i]] = dp[u][j];
        dfs(v, u);
        siz[u] += siz[v];
        for (int j = 0; j <= K; ++j)
            dp[u][j] = (1ll * dp[u][j] * p[siz[v] - 1] % mod + dp[v][j]) % mod;
    }
}
```
