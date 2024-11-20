---
title: vim 切换模式之后自动切换输入法
date: 2024-01-06 16:00:03
tags:
  - vim
categories:
  - 技术
---

由于 vim 在 Normal 模式并不能识别中文输入法打出的命令，所以可以考虑在退出插入模式时自动切换输入法为英文。

使用 [InputSourceSelector](https://github.com/minoki/InputSourceSelector)

```vim
if has('mac')
    function SwitchInput()
        let w:stored_input = split(system('input_selector current'))[0]
        if w:stored_input != "com.apple.keylayout.ABC"
            exec system('input_selector select com.apple.keylayout.ABC')
        endif
    endfunction
    set ttimeoutlen=100
    call SwitchInput()
    autocmd InsertLeave * call SwitchInput()
    autocmd InsertEnter * {
        if !exists("w:stored_input")
            w:stored_input = split(system('input_selector current'))[0]
        endif
        if split(system('input_selector current'))[0] != w:stored_input
            exec system("input_selector select " .. w:stored_input)
        endif
    }
endif
```

