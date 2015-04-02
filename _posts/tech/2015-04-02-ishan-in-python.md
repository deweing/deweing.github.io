---
layout: post
title: Python 判断汉字
category: 技术
tags: python
keywords: python
description:
---

使用 unicode 范围 \u4e00 - \u9fff 来判别汉字

unicode 分配给汉字（中日韩越统一表意文字）的范围为 4E00-9FFF 

```
def ishan(text):
    # for python 2.x, 3.3+
    # sample: ishan(u'一') == True, ishan(u'我&&你') == False
    return all(u'\u4e00' <= char <= u'\u9fff' for char in text)
```