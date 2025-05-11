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
        let g:stored_input = split(system('input_selector current'))[0]
        if g:stored_input != "com.apple.keylayout.ABC"
            exec system('input_selector select com.apple.keylayout.ABC')
        endif
    endfunction
    set ttimeoutlen=100
    call SwitchInput()
    autocmd InsertLeave * call SwitchInput()
    autocmd InsertEnter * {
        if !exists("g:stored_input")
            g:stored_input = split(system('input_selector current'))[0]
        endif
        if split(system('input_selector current'))[0] != g:stored_input
            exec system("input_selector select " .. g:stored_input)
        endif
    }
endif
```

```lua
if vim.fn.has("mac") == 1 then
  local function switch_input()
    vim.g.stored_input = vim.fn.split(vim.fn.system("input_selector current"))[1]
    if vim.g.stored_input ~= "com.apple.keylayout.ABC" then
      vim.fn.system("input_selector select com.apple.keylayout.ABC")
    end
  end

  switch_input()

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      switch_input()
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      if vim.g.stored_input == nil then
        vim.g.stored_input = vim.fn.split(vim.fn.system("input_selector current"))[1]
      end
      if vim.fn.split(vim.fn.system("input_selector current"))[1] ~= vim.g.stored_input then
        vim.fn.system("input_selector select " .. vim.g.stored_input)
      end
    end,
  })
end
```
