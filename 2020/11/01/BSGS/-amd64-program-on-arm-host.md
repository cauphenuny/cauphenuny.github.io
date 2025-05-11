---
title: 在 arm host 上使用 gdb 调试 amd64 程序
date: 2025-04-08 21:54:41
tags:
  - gdb
  - arm
  - env
---

> 非原创

[解决方案来源](https://github.com/docker/for-mac/issues/6921#issuecomment-2409324575)

在 Docker run 中加入 `--cap-add=SYS_PTRACE --security-opt seccomp=unconfined`

创建一个`/usr/local/bin/gdb`，因为`PATH`中`/usr/local/bin`比较靠前，会比`/usr/bin/gdb`先被找到

```bash
#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "$#" != "1" ]; then
 echo "Usage: $0 <path/to/program to debug>" >&2
 exit 1
fi

prog="$1"

# Start program in background
ROSETTA_DEBUGSERVER_PORT=1234 "$prog" &

# Run real gdb and tell it to attach
/usr/bin/gdb \
 -iex "set architecture i386:x86-64" \
 -iex "file $prog" \
 -iex "target remote localhost:1234" \
 -iex "set history save on"
```

然后就能正常的使用`gdb ./program`了

大受震撼.jpg
