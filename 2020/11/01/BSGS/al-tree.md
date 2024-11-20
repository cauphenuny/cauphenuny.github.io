---
title: 虚树
tags:
  - dp
categories:
  - oi
  - 学习笔记
mathjax: true
comment: true
date: 2020-11-06 21:08:45
---
先看看 [oi-wiki](https://oi-wiki.org/graph/virtual-tree/)

记录一下比较复杂的插入部分。

<!-- more -->

![](virtual-tree/3.png)

判断 `st[top-1]` 与 `lca(st[top - 1], u)` 的 `dfn` 值， 连边 `st[top], st[top - 1]` 并将 `top--` （表示在 lca 以下的边都可以连边，弹栈）

记得 `dfn[st[top] - 1]` 与 `dfn[lca]` 相等的时候也要连边并弹出栈

![](virtual-tree/1.png)

弹出完以后，判断一下栈顶与 `lca` 是否相等，不相等则连边，（如上图红色边），并把 `lca` 压入栈

然后将 `x` 压入栈，判断结束

```cpp
    void build() {
        int cnt = m;
        sort(a + 1, a + cnt + 1, cmp);
        st[++top] = 1;
        for (int i = 1, u, v, x; i <= cnt; i++) {
            u = st[top];
            v = a[i];
            x = lca(u, v);
            if (x == st[top]) {
                st[++top] = v;
            } else {
                while (top > 1 && dfn[st[top - 1]] >= dfn[x]) {
                    int d = mindist(st[top - 1], st[top]);
                    addEdge(st[top], st[top - 1], d);
                    addEdge(st[top - 1], st[top], d);
                    top--;
                }
                if (st[top] != x) {
                    int d = mindist(st[top], x);
                    addEdge(st[top], x, d);
                    addEdge(x, st[top], d);
                    st[top] = x;
                }
                st[++top] = v;
            }
        }
        while (top > 1) {
            int d = mindist(st[top - 1], st[top]);
            addEdge(st[top], st[top - 1], d);
            addEdge(st[top - 1], st[top], d);
            top--;
        }
        top = 0;
    }
```

