---
layout: post
title: 一道经典的JavaScript试题
category: 技术
tags: Javascript
keywords: js
description:
---


```
var add = function (m) {

    var temp = function (n) {
        return add(m + n);
    }

    temp.toString = function () {
        return m;
    }

    return temp;
};


add(3)(4)(5); // 12
add(3)(6)(9)(25); // 43
```

这个add函数可以无限次调用循环调用，并且把所有传进去的值相加，最后返回相加总数。这道题咋一看有点特别，但代码量极其少而精，重点技术在于：作用域、交替、匿名函数、toString的巧妙。
让我们来解释这个过程：add(3)(4)(5)

1. 先执行add(3)，此时m=3，并且返回temp函数
2. 执行temp(4)，这个函数内执行add(m+n)，n是此次传进来的数值4，m值还是上一步中的3，所以add(m+n)=add(3+4)=add(7)，此时m=7，并且返回temp函数
3. 执行temp(5)，这个函数内执行add(m+n)，n是此次传进来的数值5，m值还是上一步中的7，所以add(m+n)=add(7+5)=add(12)，此时m=12，并且返回temp函数
4. 串的方法，因此代码中temp函数的toString函数return m值，而m值是最后一步执行函数时的值m=12，所以返回值是12。

看到这其实就很明白了，代码中temp.toString的重写只是为了函数不执行时能够返回最后运算的结果值，所以这个地方是可以任意修改的，你让它返回什么它就返回什么，比如改写：

```
temp.toString = function () {
    return "total : " + m;
}
```

执行结果：

```
>>> add(3)(4)(5);
total : 12
```