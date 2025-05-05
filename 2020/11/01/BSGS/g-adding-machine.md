---
title: 图灵加法器
date: 2024-04-12 20:09:50
tags:
  - CS
categories:
  - CS
  - 计科导
---

题目：[loj6572](https://loj.ac/p/6572), [loj6573](https://loj.ac/p/6573), [loj6574](https://loj.ac/p/6574)

主要写一下 t3

一开始本人的思路是先把一个数前后颠倒地放到等号后面，再加上另一个数，最后把求得的和正过来，写了约 90 行。

小组讨论一会后发现这个取反操作挺没必要的，直接把第二个数加到第一个数上就行。

如何处理进位问题？

每次从第二个数那里取一位加至第一个数的时候将一个 0/1 转换为 a/b，相当于打上 “计算完毕” 的标记，而进位时递归地加更高位，但不新增标记。

```
q0,0,0,R,q0
q0,1,1,R,q0
q0,a,a,R,q0
q0,b,b,R,q0
q0,+,+,R,q0
q0,=,=,L,read
read,0,=,L,r0
read,1,=,L,r1
read,+,=,L,back
r0,0,0,L,r0
r0,1,1,L,r0
r1,0,0,L,r1
r1,1,1,L,r1
r0,+,+,L,w0
r1,+,+,L,w1
w0,a,a,L,w0
w0,b,b,L,w0
w1,a,a,L,w1
w1,b,b,L,w1
w0,0,a,R,q0
w0,1,b,R,q0
w0,B,a,R,q0
w1,0,b,R,q0
w1,1,a,L,W1
w1,B,b,R,q0
W1,1,0,L,W1
W1,0,1,R,q0
W1,B,1,R,q0
back,0,0,L,back
back,1,1,L,back
back,=,=,L,back
back,a,0,L,back
back,b,1,L,back
back,B,B,R,copy
copy,0,B,R,c0
copy,1,B,R,c1
copy,=,=,L,qa
c0,0,0,R,c0
c0,1,1,R,c0
c0,=,=,R,c0
c0,B,0,L,back
c1,0,0,R,c1
c1,1,1,R,c1
c1,=,=,R,c1
c1,B,1,L,back
```

共 45 行, `b` 改成 `+` 可以进一步优化到 44 行。

时间复杂度 $O(n)$

评测时放宽限制到 $10^6$ 步，此时数据范围允许 $O(2^n)$ 的做法。

不断地进行第二个数减一，第一个数加一的操作，非常简单。

```
q0,0,0,R,q0
q0,1,1,R,q0
q0,+,+,R,q0
q0,=,=,L,minus
add,0,1,R,q0
add,B,1,R,q0
add,1,0,L,add
minus,1,0,L,skip
skip,0,0,L,skip
skip,1,1,L,skip
skip,+,+,L,add
minus,0,1,L,minus
minus,+,=,L,back
back,0,0,L,back
back,1,1,L,back
back,=,=,L,back
back,B,B,R,copy
copy,0,B,R,c0
copy,1,B,R,c1
copy,=,=,L,qa
c0,0,0,R,c0
c0,1,1,R,c0
c0,=,=,R,c0
c0,B,0,L,back
c1,0,0,R,c1
c1,1,1,R,c1
c1,=,=,R,c1
c1,B,1,L,back
```

共 28 行。

附赠生成及测试代码

```cpp
// author: cauphenuny <https://cauphenuny.github.io/>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
#include <map>
#include <stack>
#include <string>
#include <vector>
#include <sstream>
#define debug(x) cerr << #x << " = " << (x) << " "
#define debugln(x) cerr << #x << " = " << (x) << endl
#define debugf(...) fprintf(stderr, __VA_ARGS__)
#define debugv(fmt, ...) \
    fprintf(stderr, "<%s:%d> " fmt "\n", __func__, __LINE__, ## __VA_ARGS__)
using namespace std;

struct Edge {
    string from, to;
    char read, write;
    char next;
    void print() {
        printf("%s,%c,%c,%c,%s\n", from.c_str(), read, write, next, to.c_str());
    }
    bool operator<(const Edge e2) const {
        if (from != e2.from) return from < e2.from;
        if (to != e2.to) return to < e2.to;
        if (read != e2.read) return read < e2.read;
        if (next != e2.next) return next < e2.next;
        return 0;
    }
};

#define L false
#define R true

vector<Edge> edge;

void add(const string& from, char r, bool mov) {
    edge.push_back((Edge){from, from, r, r, mov ? 'R' : 'L'});
}
void add(const string& from, char r, bool mov, const string& to) {
    edge.push_back((Edge){from, to, r, r, mov ? 'R' : 'L'});
}
void add(const string& from, char r, char w, bool mov, const string& to) {
    edge.push_back((Edge){from, to, r, w, mov ? 'R' : 'L'});
}

void add(const string& node, initializer_list<char> ch, bool mov) {
    for (auto c : ch) {
        add(node, c, mov);
    }
}

void print() {
#ifndef LOCAL
    puts("---");
#else
    puts("print(\"\"\"---");
#endif
    for (auto e : edge) {
        e.print();
    }
#ifndef LOCAL
    puts("===");
#else
    puts("===\"\"\")");
#endif
}

void compress() {
    map<string, char> dict;
    char ch = 'a' - 1;
    auto trans = [&dict, &ch](string& str){
        if (str == "q0" || str == "qa") return;
        if (dict.count(str)) str = dict[str];
        else dict[str] = ++ch, str = ch;
    };
    for (auto& e : edge) {
        trans(e.from), trans(e.to);
    }
    sort(edge.begin(), edge.end());
}

void run(const string& str) {
    map<int, char> tape;
    stack<Edge> path;
    for (int i = 0, l = str.length(); i < l; i++) {
        tape[i] = str[i];
    }
    int p = 0, minp = 0, maxp = str.length() - 1;
    string cur = "q0";
    auto print = [&cur, &tape, &minp, &maxp, &p]() {
        for (int i = minp; i <= maxp; i++) {
            putchar(tape[i]);
        }
        printf("\t[%s]\n", cur.c_str());
        for (int i = minp; i < p; i++) {
            putchar(' ');
        }
        puts("^");
        return 0;
    };
    auto error = [&]() {
        printf("Error: read %c at %s\n", tape[p], cur.c_str());
    };
    auto prev = [&]() {
        if (path.empty()) return;
        auto e = path.top();
        cur = e.from, p += e.next == 'R' ? -1 : 1, tape[p] = e.read;
        path.pop();
    };
    auto next = [&](){
        if (cur == "qa") return 1;
        bool flag = 0;
        if (tape[p] == 0) tape[p] = 'B';
        for (auto e : edge) {
            if (e.from == cur && e.read == tape[p]) {
                cur = e.to;
                tape[p] = e.write;
                p += (e.next == 'R') ? 1 : -1;
                flag = 1;
                path.push(e);
                break;
            }
        }
        if (!flag) {
            error();
            print();
            return 1;
        }
        minp = min(p, minp);
        maxp = max(p, maxp);
        return 0;
    };
    auto autonext = [&]() {
        while (!next());
        if (cur == "qa") {
            printf("\nSuccess, %zu step.\n", path.size());
            print();
        }
    };
    while (cur != "qa") {
        char ch = getchar();
        switch (ch) {
            case 'n': !next() && print(); break;
            case 'p': prev(), print(); break;
            case 'a': autonext(); break;
        }
    }
}

void import_machine(string mac) {
    string filter;
    for (char c : mac) {
        if (c != ' ') filter += c;
    }
    istringstream istr(filter);
    string str, from, to, read, write, next;
    while (getline(istr, str)) {
        if (!str.length()) continue;
        istringstream s(str);
        getline(s, from, ',');
        getline(s, read, ',');
        getline(s, write, ',');
        getline(s, next, ',');
        getline(s, to);
        add(from, read[0], write[0], next[0] == 'R', to);
    }
}

void create_machine() {
    edge.clear();
    add("q0", {'0', '1', 'a', 'b', '+'}, R);
    add("q0", '=', L, "read");

    add("read", '0', '=', L, "r0");
    add("read", '1', '=', L, "r1");
    add("read", '+', '=', L, "back");

    add("r0", {'0', '1'}, L);
    add("r1", {'0', '1'}, L);
    add("r0", '+', L, "w0");
    add("r1", '+', L, "w1");

    add("w0", {'a', 'b'}, L);
    add("w1", {'a', 'b'}, L);

    add("w0", '0', 'a', R, "q0");
    add("w0", '1', 'b', R, "q0");
    add("w0", 'B', 'a', R, "q0");
    add("w1", '0', 'b', R, "q0");
    add("w1", '1', 'a', L, "W1");
    add("w1", 'B', 'b', R, "q0");
    add("W1", '1', '0', L, "W1");
    add("W1", '0', '1', R, "q0");
    add("W1", 'B', '1', R, "q0");

    add("back", {'0', '1', '='}, L);
    add("back", 'a', '0', L, "back");
    add("back", 'b', '1', L, "back");
    add("back", 'B', R, "copy");
    add("copy", '0', 'B', R, "c0");
    add("copy", '1', 'B', R, "c1");
    add("copy", '=', L, "qa");
    add("c0", {'0', '1', '='}, R);
    add("c0", 'B', '0', L, "back");
    add("c1", {'0', '1', '='}, R);
    add("c1", 'B', '1', L, "back");
}

void create_machine_2n() {
    edge.clear();
    add("q0", {'0', '1', '+'}, R);
    add("q0", '=', L, "minus");
    add("add", '0', '1', R, "q0");
    add("add", 'B', '1', R, "q0");
    add("add", '1', '0', L, "add");
    add("minus", '1', '0', L, "skip");
    add("skip", {'0', '1'}, L);
    add("skip", '+', '+', L, "add");
    add("minus", '0', '1', L, "minus");
    add("minus", '+', '=', L, "back");
    add("back", {'0', '1', '='}, L);
    add("back", 'B', 'B', R, "copy");
    add("copy", '0', 'B', R, "c0");
    add("copy", '1', 'B', R, "c1");
    add("copy", '=', L, "qa");
    add("c0", {'0', '1', '='}, R);
    add("c0", 'B', '0', L, "back");
    add("c1", {'0', '1', '='}, R);
    add("c1", 'B', '1', L, "back");
}

int main() {
    //create_machine_2n();
    //compress();
    create_machine_2n(), print();

    while (1) {
        string str;
        cin >> str;
        create_machine();
        run(str);
        create_machine_2n();
        run(str);
    }

    return 0;
}
```
