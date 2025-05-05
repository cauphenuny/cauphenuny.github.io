---
title: 一些有用的小模板
tags: 
  - 模板
categories:
  - oi
  - 模板
mathjax: true
comment: true
date: 2021-02-23 21:54:05
---

**树状数组** bit.h

```cpp
//自定义类型需重载 + - 运算符
template <typename T, int maxn>
class binary_indexed_tree {
    T c[maxn + 10]; public:
    void add(int p, T v) { p++; for (; p <= maxn; p += p & -p) c[p] += v; }
    T query(int p) { p++; T v = 0; for (; p; p -= p & -p) v += c[p]; return v; }
    T range(int l, int r) { return query(r) - query(l - 1); }
};
```

---
**可删堆** deletable\_priority\_queue.h
```cpp
//自定义类型要求同 priority_queue 相同。
template <typename T>
class deletable_priority_queue {
    priority_queue<T> _main, _del;
    int siz;
    void clear() {
        while (_main.size() && _del.size() && (_main.top() == _del.top())) _main.pop(), _del.pop();
    }
    public:
    void push(T x) { _main.push(x), siz++; }
    void del(T x) { _del.push(x), siz--; }
    void pop() { _del.push(_main.top()), siz--; }
    bool empty() { return siz == 0; }
    int size() { return siz; }
    T top() { clear(); return _main.top(); }
};
```

---

**自取模数** module.h

重载了 + - * / ^ inv 运算符，支持 cout 输出。

```cpp
template <typename T, T mod>
class Num {
    public:
    T val;
    void format() { if (val < 0) { val += ((-val) / (mod) + 1) * mod; } val %= mod; }
    Num(T x) { val = x; format(); }
    Num() { val = 0; }
    void operator = (T x)  { val = x; format(); }
    void operator = (Num x) { val = x.val; }
    friend Num operator * (Num a, Num b) { return (a.val * b.val) % mod; }
    friend Num operator + (Num a, Num b) { return (a.val + b.val) % mod; }
    friend Num operator - (Num a, Num b) { return (a.val - b.val + mod) % mod; }
    void operator *= (Num n) { val = ((*this) * n).val; }
    void operator += (Num n) { val = ((*this) + n).val; }
    void operator -= (Num n) { val = ((*this) - n).val; }
    Num operator ^ (T b) {
        if (b < 0) { b += ((-b) / (mod-1) + 1) * (mod-1); } b %= (mod-1);
        Num res(1), a(val);
        while (b) { if (b & 1) { res *= a; } b >>= 1, a *= a; }
        return res;
    }
    void operator ^= (T b) { val = ((*this) ^ b).val; }
    friend Num operator / (Num a, Num b) { return (Num){a * (b ^ -1)}; }
    void operator /= (Num n) { val = ((*this) * (n ^ -1)).val; }
    Num inv() { return (*this) ^ -1; }
    typedef basic_ostream<char>& type;
    friend type operator << (type &out, Num x) { cout << x.val; return out; }
};
```

---

**复数** complex.h

重载了 + - * 运算符，支持 cout 输出
```cpp
template <typename T>
class Complex {
    T a, b;
    public:
    Complex(T new_a = 0., T new_b = 0.): a(new_a), b(new_b) {}
    Complex(const Complex<T> &cur): a(cur.a), b(cur.b) {}
    friend Complex<T> operator - (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a - z2.a, z1.b - z2.b);
    }
    friend Complex<T> operator + (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a + z2.a, z1.b + z2.b);
    }
    friend Complex<T> operator * (Complex<T> z1, Complex<T> z2) {
        return Complex(z1.a * z2.a - z1.b * z2.b, z1.b * z2.a + z1.a * z2.b);
    }
    T real() { return a; }
    T imag() { return b; }
    void real(T cur) { a = cur; }
    void imag(T cur) { b = cur; }
    void print() { cout << a << " + " << b << "i"; }
    typedef basic_ostream<char>& type;
    friend type operator << (type &out, Complex<T> z) { z.print(); return out; }
};
```

**主席树** hjt.h

```cpp
class remainable_segment_tree {
    struct Node {
        size_t siz;
        Node *ls, *rs;
        int id;
        void update() { siz = ls->siz + rs->siz; }
        Node(size_t s, Node *ls, Node *rs, int id): siz(s), ls(ls), rs(rs), id(id) {}
    } *null;
    vector <Node*> root;
    int minv, maxv, p, tot_id;
    size_t v, rk;
    #define mid ((l + r) >> 1)
    Node* refresh(Node *pre, int l, int r) {
        Node *cur = new Node(pre->siz + v, pre->ls, pre->rs, ++tot_id);
        if (l < r) {
            if (p <= mid) cur->ls = refresh(pre->ls, l, mid);
            else          cur->rs = refresh(pre->rs, mid + 1, r);
        }
        return cur;
    }
    int query(Node *pre, Node *cur, int l, int r) {
        if (l == r) { return l; }
        size_t siz = cur->ls->siz - pre->ls->siz;
        if (siz >= rk) { return query(pre->ls, cur->ls, l, mid); }
        else { rk -= siz; return query(pre->rs, cur->rs, mid + 1, r); }
    }
    #undef mid
    public:
    remainable_segment_tree() {
        null = new Node(0, 0, 0, 0);
        null->ls = null->rs = null, null->siz = 0;
        root.push_back(null);
        minv = maxv = tot_id = 0;
    }
    int getpos(size_t pre, size_t cur, size_t rank) {
        rk = rank;
        return query(root[pre], root[cur], minv, maxv);
    }
    void insert(size_t pre, size_t cur, int pos, size_t val) { // create a new version
        if (cur == root.size()) root.push_back(null);
        v = val, p = pos;
        root[cur] = refresh(root[pre], minv, maxv);
    }
    void set_limit(int l, int r) { // remember to set it !!!!!!
        if (root.size() <= 1) minv = l, maxv = r;
    }
    void move(size_t dest, size_t source) {
        root[dest] = root[source];
    }
} tree;
```

**KD-tree** kdt.h
```cpp
/* 区间加减修改，单点查询 K-D tree，维护了历史最小值
 * usage:
 * kdt::kd_tree<2> tree;
 * kdt::kd_tree<2>::kd_val x[MAXN];
 * for (int i = 1; i <= n; i++) x[i].pos = {%d, %d}, x[i].val = %d;
 * tree.init(x + 1, x + n + 1);
 */

namespace kdt {

constexpr int inf = 0x3f3f3f3f;

using array = initializer_list<int>;

template<class T> bool chkmax(T &a, const T b) { return b > a ? (a = b, 1) : 0; }
template<class T> bool chkmin(T &a, const T b) { return b < a ? (a = b, 1) : 0; }

template <const int d_size>
struct kd_tree {

    struct kd_pos {
        int pos[d_size];
        int  operator [] (const int x) const { return pos[x]; }
        int &operator [] (const int x) { return pos[x]; }
        inline bool operator == (const kd_pos &v) const {
            for (int i = 0; i < d_size; i++) if (v.pos[i] != pos[i]) return 0;
            return 1;
        }
        inline bool operator <= (const kd_pos &v) const {
            for (int i = 0; i < d_size; i++) if (pos[i] > v.pos[i]) return 0;
            return 1;
        }
        kd_pos(array a) { int j = 0; for (auto i : a) { pos[j++] = i; } }
        kd_pos(int x) { for (int i = 0; i < d_size; i++) pos[i] = x; }
        kd_pos() : kd_pos(0) {}
        void print() { debugf("{%lld, %lld}", pos[0], pos[1]); }
    };
    struct kd_val {
        kd_pos pos;
        int val;
        int &operator [] (const int x) { return pos[x]; }
        kd_val() : pos(), val(0) {}
        kd_val(array pos, int val) : pos(pos), val(val) {}
    };
    int tot_id; // for debug
    struct kd_node {
        int id; // for debug
        kd_pos min, max, pos;
        int tag, val;
        int mintag, minv;
        kd_node *ls, *rs;
        kd_node() : min(inf), max(-inf), tag(0) {}
    } empty, *null;
    void info(kd_node* p) {
        debugf("node #%lld (%lld, %lld) {\n"
                "    range (%lld, %lld) ==> (%lld, %lld)\n"
                "    son: #%lld, #%lld\n"
                "    minv = %lld, mintag = %lld\n"
                "    curval = %lld, curtag = %lld\n"
                "}\n",
                p->id, p->pos[0], p->pos[1],
                p->min[0], p->min[1], p->max[0], p->max[1],
                p->ls->id, p->rs->id,
                p->minv, p->mintag, p->val, p->tag
        );
    }
    inline kd_node* new_node() {
        kd_node* cur = new kd_node;
        cur->ls = cur->rs = null;
        cur->id = ++tot_id;
        return cur;
    }
    inline void add(kd_node *p, int tag, int mintag) {
        if (p == null) return;
        chkmin(p->minv, p->val + mintag);
        chkmin(p->mintag, p->tag + mintag);
        p->tag += tag;
        p->val += tag;
    }
    inline void pushup(kd_node *p) {
        for (int i = 0; i < d_size; i++) {
            chkmin(p->min[i], min(p->ls->min[i], p->rs->min[i]));
            chkmax(p->max[i], max(p->ls->max[i], p->rs->max[i]));
        }
    }
    inline void pushdown(kd_node *p) {
        add(p->ls, p->tag, p->mintag), add(p->rs, p->tag, p->mintag);
        p->mintag = p->tag = 0;
    }
    kd_node* build(kd_val a[], int l, int r, int d) {
        int mid = (l + r) >> 1;
        nth_element(a + l, a + mid, a + r + 1, [d] (kd_val a, kd_val b) {return a[d] < b[d];});
        kd_node* cur = new_node();
        cur->pos = cur->min = cur->max = a[mid].pos;
        cur->val = cur->minv = a[mid].val;
        if (l < mid) cur->ls = build(a, l, mid - 1, (d + 1) % d_size);
        if (mid < r) cur->rs = build(a, mid + 1, r, (d + 1) % d_size);
        pushup(cur);
        return cur;
    }
    void modify(kd_node *p, const kd_pos &min, const kd_pos &max, int v) {
        if (((int)(p->min <= max) + (int)(min <= p->max)) != 2) return;
        if (min <= p->min && p->max <= max) { add(p, v, v); return; }
        pushdown(p);
        if (min <= p->pos && p->pos <= max) { p->val += v, chkmin(p->minv, p->val);}
        modify(p->ls, min, max, v), modify(p->rs, min, max, v);
    }
    int query(kd_node *p, const kd_pos &pos, int d = 0) {
        if ((p->min <= pos || pos <= p->max) == 0) return 0;
        if (p->pos == pos) return p->minv;
        pushdown(p);
        int res = 0;
        if (pos <= p->ls->max && pos[d] <= p->pos[d])
            res = query(p->ls, pos, (d + 1) % d_size);
        if (res == 0)
            res = query(p->rs, pos, (d + 1) % d_size);
        return res;
    }
    void print(kd_node* p, int depth = 0) {
        info(p);
        if (p->ls != null) print(p->ls);
        if (p->rs != null) print(p->rs);
    }
    kd_node* init(kd_val* st, kd_val* ed) {
        return build(st, 0, ed - st - 1, 0);
    }
    kd_tree() { null = &empty; null->ls = null->rs = null; }
};

}

```
