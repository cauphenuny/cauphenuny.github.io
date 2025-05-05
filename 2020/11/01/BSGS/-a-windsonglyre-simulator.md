---
title: 从零开始打造一个原琴模拟器
date: 2024-06-14 14:02:30
tags:
  - CS
  - HTML
  - JavaScript
categories:
  - CS
  - 计科导
---

计科导大作业

试玩链接: [原琴模拟器](/deploy/piano-simulator)

---

6.14

音色库来源：[@Colalala_冰阔落落落](https://space.bilibili.com/243664595)

试了半天，发现没法正常播放这个风物之诗琴的音源，决定先用 smplr 默认的钢琴音源把别的写了。

写好了键盘演奏函数、谱子 parser 以及自动播放功能。

version 0.1.0

---

6.15

加入 `[]` `{}` 表示时值变化。

添加临时升降记号 `-/+` 以及临时高/低八度记号。

重写了教程

version 0.3.0

---

6.16

添加了固定调转调方式，更适合对着五线谱演奏。

version 0.4.0

---

6.17

优化了调号显示。

version 0.4.4

加了个键盘，可以看到哪些音被按下了。

version 0.5.4

把自动演奏和按键动画连接了起来。

version 0.6.0

加了个加载时的提示悬浮窗

version 0.6.1

---

6.18

重构了代码

version 0.7.0

给按钮加了点阴影，感谢[Box-Shadow CSS Generator](https://html-css-js.com/css/generator/box-shadow/)以及[用filter: drop-shadow()给透明图片添加阴影](https://www.cnblogs.com/kangxinzhi/p/16442217.html)

version 0.7.1

遇到了个 bug 就是说在 mac 上同时按下 command 和某个键，这个时候这个键的 keyup 事件就直接没有了

[stackoverflow question](https://stackoverflow.com/questions/11818637/why-does-javascript-drop-keyup-events-when-the-metakey-is-pressed-on-mac-browser)

好像还挺难解决，选择在 ctrl/alt/meta 按下时忽略别的键的 keydown 事件。

[检测是否按下ctrl](https://segmentfault.com/q/1010000013680244)

version 0.7.2

加上了音游模式，判定还没写

（似乎跑题写成音游了）

version 0.8.0

---

6.19

重构了代码

version 0.9.0

加上了判定

总代码行数 1000 行纪念（仅计算 js 文件、不含预设谱子）

version 0.10.1

---

6.20

加了个分数评级

version 0.10.5

完善了 perfect/good/bad UI

version 0.10.7

加上了其他难度

解释一下不同难度的选音标准：

- 简单：仅重拍上的音

- 较简单/普通：仅整数拍上的音

- 较困难：整数拍和半拍上的音

- 困难：所有音

同时按下的音数量限制：简单 1 ，较简单/普通/较困难 2，困难 6

version 0.11.0

---

6.21

添加了副音轨

version 0.11.1

调整主页UI

version 0.11.7

加上演示模式

version 0.12.0

给音游界面写了个炫酷的UI

version 0.13.0

写好了计分板

version 0.14.0

修了下判定延迟失效的bug

version 0.14.3

---

6.22

修了个移调的bug

1.0.0发布！

```shell
$ wc -l *.js
      38 constants.js
     871 game.js
     307 index.js
      20 keyboard.js
     170 player.js
     428 songs.js
    1834 total
```

加了存储谱子功能

version 1.1.0

修了简单模式强弱拍计算在一个小节内节拍变化时出错的问题（改成按小节线对齐了）

version 1.2.0

把曲名单独分了个框出来

version 1.3.0

---

6.25

键盘抬起时制音，从而支持断奏

version 1.4.0

加上了延音踏板按钮，重构了制音部分代码

version 1.5.0

写好了临时变调功能，曲库加入《使一颗心免于哀伤》。

version 1.6.0

加入连击和当前等级提示。

version 1.7.0

加了个随机背景

version 1.8.0

曲库加入《卡农》

version 1.8.3

终于发现为什么 for 循环给不同的东西设置 handler 里面写跟 i 相关的代码会出问题了，原来这个 `var` tm 是全局的，这也太反直觉了

[ES6 let/const](https://www.zmln1021.cn/pages/c1edd70a6b7c7872/#%E5%9F%BA%E6%9C%AC%E7%94%A8%E6%B3%95)

找到了个好教程

[JavaScript 教程](https://wangdoc.com/javascript/)

[git笔记](https://www.zmln1021.cn/note/git/)

发现拿 vim 默认的 bash 的高亮写谱子有奇效（不是

---

6.27

加了几首曲子

version 1.9.0

添加音量滑动条

version 1.10.0
