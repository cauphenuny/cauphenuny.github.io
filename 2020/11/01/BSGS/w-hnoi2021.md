---
title: HNOI2021总结
tags:
  - 学习笔记
  - HNOI2021
categories:
  - oi
  - 考试总结
mathjax: true
comment: true
date: 2021-04-17 08:24:40
---

## 总结

### Day1

开考先看看三个题，发现 T2 是个构造，T3 不像是会做的题目，然后就开始想第一题。

正好昨天看了一眼 wqs 二分，这个题目也有一个只能选 $k$ 个的限制，于是思路逐渐跑偏，也把模型转换了一下，大概就花了一两个小时的时间，然后发现我不太会做没有限制 $k$ 个的情况，但是我还是觉得只是自己最后一步思考得不够深入，画了一堆图，就一直想，甚至把手推 wqs 二分，把昨天没看懂的部分想明白了，最后还是放弃了这个思路，然后很快就想出了一个二分加双指针的做法，也没有什么细节，很快就码完了，但是调了一小会儿，过了几个样例然后就已经十一点半还是十二点了​。

接着赶紧看第二题，没有什么思路，再加上把题目想的复杂了一点，觉得这种限制很难跑，就先写了高斯消元，但是我已经半年没写过高斯消元了，调了一个小时，然后发现这个做法假掉了，赶紧上了一个随机化，在 12:58 的时候过了样例，第三题就没有看。

最终分数：$90+0+0$ ，T1 被卡常了，T2 没搞到分

总结一下 Day1 的失误主要是 T1 花掉时间太多，在错误的思路上十分纠结，然后写题的时间就拉的很长，我左边的人已经拍上 T1 的时候，我才开始写我的错误做法，然后剩下的时间不多，心态也不是很好，就想着哎呀我不搞一点分数就完了，不能静下心想题，就只会乱搞玄学得分:sweat_smile:，但是 T2 $m=1$ 的 30 部分分还是很好想的，但是我根本就没想。

### Day2

看看题，T2 是计数题，T3 `dominator` 支配树 ~~我手机里还存了一个支配树的博客页面，可惜没看~~ 。

至少这次的 T1 看上去十分可做，但是我看到  “$p_i$ 互不相同” 的条件是没有什么想法，没有想到重编号，然后就看到数据范围 2e5 ，想想两个 $\log$ 的做法，首先树剖占一个，然后考虑在一个 $\log$ 的时间内求答案，不会…… 

去看部分分，$m=300$ 的貌似可以子序列自动机跑一跑，但是细节很多，我也不太会实现从 lca 往下跑的部分，然后是链的 $20$ 分，这个部分我用分块很容易就做出来了。

然后摆在我面前的就是一个大问题：我现在有把握写链的部分分，但是可以预见的是我需要至少一个多小时的时间把它码出来，但是我只能搞到 $20$ 分，效率不是很高。

于是我就看 T2 和 T3 去了，先码了 T2 的 $O(n!)$ 的做法，结果发现看错题了，是求可能的排名数量，然后修修补补（包括给排名哈希存桶之类）搞出来一个 $O\left((n!)^2\right)$ 的渣渣做法，然后发现样例死活过不了，正奇怪于为什么排名 $1,2,3$ 不行的时候，时间已经到了十一点多了，这时候赶紧弃掉 T2 ，去码 T1 的链部分分，到十二点多的时候拍上了 T1，然后这个时候做了一个错误决定：我写了一个子序列自动机，而不是想想正解，结果还没写完就下考了，但是正解只需要我这个链的做法加上一个树剖就可以了，十分可惜。

而且 T3 我是知道这是一颗树的，没准认真搞搞就有 75pts

总结：

思维不大行，链上想得出没想到正解做法；眼睛不太好，样例调不对没发现看错了题。

## 努力方向

思维不好，想送分题都想不出来，多打打 CF 练一下思维，然后也要训练自己的调题速度