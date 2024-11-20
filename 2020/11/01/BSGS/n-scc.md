---
title: tarjan缩点
tags:
  - 学习笔记
  - tarjan
categories:
  - oi
  - 学习笔记
  - 图论
mathjax: true
comment: true
date: 2020-10-09 20:16:25
---

强连通定义：在有向图 $G\{V,E\}$ 中，对于点集 $V'\in V$ , 点集中的任意两点都可达，则称 $V'$ 为强连通。

<!--more-->

----

考虑建出图的 dfs 树，则原图上的边可以转换为三种边：

![](https://cdn.luogu.com.cn/upload/image_hosting/c57nin2c.png)



-----

坑：

1. 要写两个连边函数，把第二个函数的  `siz` 写成了 `tot` ，调了我一个晚上...

   ```cpp
   void addline(int u, int v) {
       tot++;
       l[tot].from = u;
       l[tot].to = v;
       l[tot].next = hl[u];
       hl[u] = tot;
   }
   
   void addedge(int u, int v) {
       siz++;
       e[siz].from = u;
       e[siz].to = v;
       e[siz].next = he[u];
       he[u] = siz;          //就是这里！
   }
   ```

2. 由于存边的时候只存了一个点的后继节点，所以要根据节点 $u$ 更新节点 $v\ (\exist e\in E_u,e.to=v)$ 

   ![](https://cdn.luogu.com.cn/upload/image_hosting/t2m9g8yl.png)

   如图，灰色的节点都已经更新完了，现在是操作 $u$ 节点，使得 $v_1$ 、$v_2$、$v_3$ 的答案更新。

   ```cpp
void sort() {
    std::queue <int> q;
    for (int i = 1; i <= n; i++) {
        if (idx[i] == i) {
            if (!deg[i]) {
                q.push(i);
                ans[i] = scc[i];
            }
        }
    }
    while (q.size()) {
        int u = q.front(); q.pop();
        for (int i = he[u]; i; i = e[i].next) {
            int v = e[i].to;
            ans[v] = std::max(ans[v], scc[v] + ans[u]);
            deg[v]--;
            if (deg[v] == 0) q.push(v);
        }
    }
}
   ```

3. 把 `idx[v]` 写成了 `idx[i]` (`i` 是边，`v` 是点)

4. 把 `idx[v]` 写成了 `v` 

   ```cpp
   void init() {
       for (int i = 1, u, v; i <= tot; i++) {
           u = l[i].from;
           v = l[i].to;
           if (idx[u] != idx[v]) {
               addedge(idx[u], idx[v]);
               deg[idx[v]]++;//就是这里
           }
       }
   }
   ```

   

---

**总结：一定要清楚每个变量和数组代表的意义是什么！**
