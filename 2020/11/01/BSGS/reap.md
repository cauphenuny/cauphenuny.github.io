---
title: 无旋Treap
tags:
  - 数据结构
  - treap
  - 平衡树
categories:
  - oi
  - 学习笔记
  - 数据结构
mathjax: true
comment: true
date: 2020-09-17 19:40:20
---

参考：[blog1](https://www.luogu.com.cn/blog/Chanis/fhq-treap)  | [blog2](https://blog.csdn.net/pengwill97/article/details/82891241)

<!--more-->

---
定义一下变量：
```cpp
struct Node {
    int ls;//每个点的左儿子
    int rs;//每个点的右儿子
    int val;//每个点的权值
    int rnd;//每个点的随机权值
    int siz;//以每个点为根的树的大小
} tree[MAXN];
int root;//根节点编号
int tot;//节点总数
```
----
主要有两个核心操作：`split(int rt, int &a, int &b, int k)` 和 `merge(int a, int b, int &rt)` ，分别表示将一颗 $\mathsf{treap(rt)}$ 按权值分裂成两颗 $\mathsf{treap(a)}$  和  $\mathsf{treap(b)}$ 以及将两颗 $\mathsf{treap}$ 合并。

---
## 基本操作

#### 分裂 

`split(int rt, int &a, int &b, int val)`

递归处理，设当前节点为 $rt$，要按值 $val$ 分裂成两颗树 $a$ 和 $b$。
![](https://cdn.luogu.com.cn/upload/image_hosting/l44ndlat.png)

若 $rt <= val$ ，则 $rt$ 以及它的左子树都可以并入 $a$ 节点，下一步要将 $rt.rs$ 分裂，如下图。
![](https://cdn.luogu.com.cn/upload/image_hosting/rfr4183x.png)

若 $rt > val$ ，则 $rt$ 以及它的右子树都可以并入 $b$ 节点，下一步要将 $rt.ls$ 分裂，如下图。
![](https://cdn.luogu.com.cn/upload/image_hosting/87zvlaib.png)

如果 $rt=0$ 即达到了递归边界，这时候要怎么办呢？

赋值 `a = b = 0;` 表示当前 $a$， $b$ 均为空节点，即上图的绿色和蓝色节点都为空。因为调用函数时是引用的变量，因此 $a$， $b$ 的改变也会影响到上级的节点的左儿子或者右儿子。

代码：
```cpp
void split_by_val(int rt, int &a, int &b, int val) {
    if (rt == 0) {
        a = b = 0;
        return;
    }
    if (p[rt].val <= val) {
        a = rt;
        split_by_val(p[rt].rs, p[a].rs, b, val);
    } else {
        b = rt;
        split_by_val(p[rt].ls, a, p[b].ls, val);
    }
    pushup(rt);
}
```

排名分裂是类似的

```cpp
void split_by_rank(int rt, int &a, int &b, int rank) {
    if (rt == 0) {
        a = b = 0;
        return;
    }
    int ls = p[rt].ls, rs = p[rt].rs;
    if (p[ls].siz + 1 <= rank) {
        a = rt;
        split_by_rank(rs, p[a].rs, b, rank - p[ls].siz - 1);
    } else {
        b = rt;
        split_by_rank(ls, a, p[b].ls, rank);
    }
    pushup(rt);
}
```
---
#### 合并

操作：`merge(a, b, rt)`：将 $a$，$b$ 合并至 $rt$ ，（$\forall x\in treap(a),y\in treap(b)$ 有 $val(x)<val(y)$）。

![](https://cdn.luogu.com.cn/upload/image_hosting/1k56rly9.png)

由于要满足堆性质，所以要分情况考虑。

若 $rnd(a) \le rnd(b)$ 则将 $a$ 和它的左子树复制到 $rt$ 上，赋值 `rt = a` ，继续递归 `merge(a.rs, b, rt.rs)`。

![](https://cdn.luogu.com.cn/upload/image_hosting/mo1z10h7.png)

反之，则将 $b$ 和它的右子树复制到 $rt$ 上，赋值 `rt = b` ，继续递归 `merge(a, b.ls, rt.ls)`。

![](https://cdn.luogu.com.cn/upload/image_hosting/yzz2gj2t.png)

代码
```cpp
void merge(int a, int b, int &rt) {
    if (a == 0 || b == 0) {
        rt = a + b;
        return;
    }
    if (p[a].rnd <= p[b].rnd) {
        rt = a;
        merge(p[a].rs, b, p[rt].rs);
        pushup(a);
    } else {
        rt = b;
        merge(a, p[b].ls, p[rt].ls);
        pushup(b);
    }
    pushup(rt);
}
```

---
## 其他操作

**插入** `insert(a)`

将树按权值 $a$ 分裂成两颗树 $x$ 和 $y$，然后新建一个节点 $z$ 合并 $x$ 与 $z$ 至 $u$，合并 $u$ 和 $y$ 至 $root$

代码
```cpp
void insert(int &rt, int val) {
    int x, y, z, u;
    split_by_val(rt, x, y, val);
    z = newnode(val);
    merge(x, z, u);
    merge(u, y, rt);
}
```

---

**删除一个权值为 $v$ 的节点** `del(v)`

将树 $root$ 按权值 $v$ 分裂为 $a$ 和 $b$ 。
![](https://cdn.luogu.com.cn/upload/image_hosting/2w9udfx7.png)

再将 $a$ 按权值 $v - 1$ 分裂成 $x$ 和 $y$。
![](https://cdn.luogu.com.cn/upload/image_hosting/wfp7j2lj.png)

接着，`merge(y.ls, y.rs, y)` ，表示去掉一个 $y$ 树中的节点，形成的新的树的根节点仍然是 $y$ ，再 `merge(x, y, a)`，`merge(a, b, root)`，重新把几颗树合并到根节点。

代码
```cpp
void del(int &rt, int val) {
    int x, y, a, b;
    split_by_val(rt, a, b, val);
    split_by_val(a, x, y, val - 1);
    merge(p[y].ls, p[y].rs, y);
    merge(x, y, a);
    merge(a, b, rt);
}
```

---
**删除所有权值为 $v$ 的节点** `multidel(v)`


与上面类似，最后一步直接 `merge(x, b, root)` 。

代码
```cpp
void multidel(int &rt, int val) {
    int x, y, a, b;
    split_by_val(rt, a, b, val);
    split_by_val(a, x, y, val - 1);
    merge(x, b, rt);
}
```

---
**排名** `getrank(rt, v)`

直接按照 $v-1$ 的权值把树 $rt$ 分开为 $x$ 和 $y$，那么 $x$ 树中最大的应该小于等于 $a-1$ ，那么 $a$ 的排名就是$size[x]+1$。

代码：
```cpp
int getrank(int &rt, int val) {
    int x, y, res;
    split_by_val(rt, x, y, val - 1);
    //puts("x:");printtree(x);puts("");
    //puts("y:");printtree(y);puts("");
    res = p[x].siz + 1;
    merge(x, y, rt);
    return res;
}
```

---
**查询 $k$ 小值** `getval(rt, k)`

记当前节点的左子树大小为 $siz$ 。  
$siz=k-1$，那么 $tree[rt].val$ 就是答案。  
$siz>k-1$，递归查找左子树的 $k$ 小值  
$siz<k-1$，递归查找右子树的 $k-siz-1$小值  

代码
```cpp
int getval(int rt, int k) {
    if (p[p[rt].ls].siz < k - 1) {
        return getval(p[rt].rs, k - p[p[rt].ls].siz - 1);
    } else if (p[p[rt].ls].siz > k - 1) {
        return getval(p[rt].ls, k);
    } else {
        return p[rt].val;
    }
}
```

---
**前驱** `getprev(v)`

因为要小于 $v$ ，所以我们还是按照 $v-1$ 的权值划分 $x$ ，现在 $x$ 中最大的数一定小于等于 $a-1$，所以我们直接输出$x$ 中最大的数就好

代码
```cpp
int getprev(int &rt, int val) {
    int x, y, res;
    split_by_val(rt, x, y, val - 1);
    //printtree(x);puts("");
    //printtree(y);puts("");
    res = getval(x, p[x].siz);
    merge(x, y, rt);
    return res;
}
```

---
**后继** `getnext(v)`

按照 $v$ 的权值划分 $x$ 和 $y$，现在 $y$ 中最小的数一定大于 $a$ 输出 $y$ 中最小的数。

代码
```cpp
int getnext(int &rt, int val) {
    int x, y, res;
    split_by_val(rt, x, y, val);
    res = getval(y, 1);
    merge(x, y, rt);
    return res;
}
```

----
## 扩展内容

**持久化**：[link](/2020/10/03/review-p3835/)

**水掉splay**：[link](https://ycp.blog.luogu.org/p3391-review)

---
几道习题：  
[P1486 (NOI2004)郁闷的出纳员](/2020/10/18/ds-list/#P1486-NOI2004-%E9%83%81%E9%97%B7%E7%9A%84%E5%87%BA%E7%BA%B3%E5%91%98)  
[P2596 (ZJOI2006)书架 总结](/2020/10/19/review-p2596/)
