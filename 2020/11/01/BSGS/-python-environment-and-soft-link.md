---
title: Xcode CLT 一个有意思的机制
date: 2024-07-05 17:49:27
tags:
  - CS
  - Linux
  - Mac
  - 软链接
  - Xcode
  - 环境
  - clang
  - llvm
categories:
  - CS
  - env
---

最近觉得终端里面输 `python` 出来的竟然是 python2 很不爽，然后就想用个软链接把 `/usr/local/bin/python` 指到 `/usr/local/bin/python3`。

```bash
$ sudo ln -s /usr/local/bin/python3 /usr/local/bin/python
```

完事，然后：

![01.png](xcode-python-environment-and-soft-link/01.png)

好怪哦

弄了半天不知道怎么回事，最后群里问了问，有大佬解释是这个 Xcode CommandLine Tools 提供的 python 会根据传入的程序名称决定行为，argv[0] 是 python 就当 python2 执行

软链接没问题，文件确实是一样的

![python crc](xcode-python-environment-and-soft-link/python-crc.png)

换个名字就执行不了了

![asd.png](xcode-python-environment-and-soft-link/asd.png)

其实我应该自己早点发现这个问题的，之前刷知乎刷到过 clang/clang++ 也是一样的原理，共用一个执行文件，根据传入的 argv[0] 决定是否链接 libc++ 库等

![apple clang](xcode-python-environment-and-soft-link/clang-crc.png)

![brew clang](xcode-python-environment-and-soft-link/brew-clang-crc.png)

还是没想到这里去

---

~~最后用了个 alias ，不折腾软链接了~~

最后还是用上了 conda 管理环境，删掉了 `/usr/local/bin` 里面的python/pip等。

等等……

![crc对比](xcode-python-environment-and-soft-link/both-crc.png)

啊？

所以 Xcode CLT 是把所有的命令链接到同一个二进制文件，然后再根据调用时的名字决定执行具体哪个程序？

---

利用类似的原理，写了个 brew-clang 启动器

```bash
#!/usr/bin/env zsh

prefix="/opt/homebrew/Cellar/llvm"
ver=($(ls -vr --color=never $prefix))
dir="$prefix/${ver[1]}/bin/"
# 运行 llvm/(version)/bin/ 目录下的同名程序
$dir/$(basename $0) $argv
```

将这个脚本随便保存个名字，再创建一些链接命名为想要导出的命令即可

使用效果：

![使用效果](xcode-python-environment-and-soft-link/brew-llvm.png)

---

upd: 发现可以直接`export PATH="/opt/homebrew/opt/llvm/bin:$PATH"`

