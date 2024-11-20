---
title: 在 mac 终端中使用废纸篓功能
date: 2023-12-26 22:24:00
tags: 脚本
---

众所周知终端中删掉文件之后无法恢复。

解决方案

1. [trash-cli](https://github.com/andreafrancia/trash-cli/) 但这样虽然能够恢复文件，却无法跟 Finder 共用同一个废纸篓。

2. 使用 applescript 传消息给 Finder

```python
#!/usr/bin/env python3
import os
import sys
import subprocess

if len(sys.argv) > 1:
    files = []
    for arg in sys.argv[1:]:
        if os.path.exists(arg):
            p = os.path.abspath(arg).replace('\\', '\\\\').replace('"', '\\"')
            files.append('the POSIX file "' + p + '"')
        else:
            sys.stderr.write(
                "%s: %s: No such file or directory\n" % (sys.argv[0], arg))
    if len(files) > 0:
        cmd = ['osascript', '-e',
               'tell app "Finder" to move {' + ', '.join(files) + '} to trash']
        r = subprocess.call(cmd, stdout=open(os.devnull, 'w'))
        sys.exit(r if len(files) == len(sys.argv[1:]) else 1)
else:
    sys.stderr.write(
        'usage: %s file(s)\n'
        '       move file(s) to Trash\n' % os.path.basename(sys.argv[0]))
    sys.exit(64) # matches what rm does on my system
```

reference:

https://apple.stackexchange.com/questions/50844/how-to-move-files-to-trash-from-command-line
