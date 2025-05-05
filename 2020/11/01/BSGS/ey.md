---
title: vim key
tags:
  - vim
categories:
  - 技术
mathjax: true
comment: true
date: 2020-12-04 08:43:19
---
**normal mode:**

`Ctrl-a` 数字+1
`Ctrl-x` 数字-1

<!--more-->
`Ctrl-o`：跳转到上一次光标所在位置
`0`：行首
`^`：行首非空字符
`$`：行末
`g_`：行末非空字符
`gh`：选择
`%`：跳转到匹配括号
`[]`：上一个在行首的`}`
`][`：下一个在行首的`{`
`{`：上一个代码块末尾
`}`： 下一个代码块末尾
`[[`： 文件开头行
`]]`： 文件末尾行

`c` 删除并插入

`[verb]i[char]`： `[char]`可为 `()[]{}` ，表示范围在 `[char]` 所在的匹配括号内容
> 例：
> `memset(a, 0, sizeof(0));`
> 光标在第 1 个 0 的位置，输入 `di(`：删除`a, 0, sizeof(0)`。

---
**insert mode:**

`Ctrl-w`：删除单词
`Ctrl-u`：删除行，保留缩进
`Ctrl-t`：缩进++
`Ctrl-d`：缩进--
`Ctrl-n/p`：补全

---
**visual mode:**

`>`：缩进++
`<`：缩进--
