---
layout: post
title: 10道javascript笔试题
category: 技术
tags: javascript
keywords: javascript
description:
---

From: [http://www.cnblogs.com/zichi/p/4359786.html](http://www.cnblogs.com/zichi/p/4359786.html)

### 1.考察this

```
var length = 10;
function fn() {
  console.log(this.length);
}

var obj = {
  length: 5,
  method: function(fn) {
    fn();
    arguments[0]();
  }
};

obj.method(fn, 1);
```

输出：

```
10
2
```

第一次输出10应该没有问题。我们知道取对象属于除了点操作符还可以用中括号，所以第二次执行时相当于arguments调用方法，this指向arguments，而这里传了两个参数，故输出arguments长度为2。


### 2.var和函数的提前声明

```
function fn(a) {
  console.log(a);
  var a = 2;
  function a() {}
  console.log(a);
}

fn(1);
```

输出：

```
function a() {}
2
```

我们知道var和function是会提前声明的，而且function是优先于var声明的（如果同时存在的话），所以提前声明后输出的a是个function，然后代码往下执行a进行重新赋值了，故第二次输出是2。


### 3.局部变量和全局变量

```
var f = true;
if (f === true) {
  var a = 10;
}

function fn() {
  var b = 20;
  c = 30;
}

fn();
console.log(a);
console.log(b);
console.log(c)
```

输出：

```
10
报错
30
```

这是个我犯了很久的错误，很长一段时间我都以为{...}内的新声明的变量是局部变量，后来我才发现function内的新声明的变量才是局部变量，而没有用var声明的变量在哪里都是全局变量。再次提醒切记只有function(){}内新声明的才能是局部变量，while{...}、if{...}、for(..) 之内的都是全局变量（除非本身包含在function内）。


### 4.变量隐式声明

```
if('a' in window) {
  var a = 10;
}

alert(a);
```

答案：`10`

前面我说过function和var会提前声明，而其实{...}内的变量也会提前声明。于是代码还没执行前，a变量已经被声明，于是 'a' in window 返回true，a被赋值。


### 5.给基本类型数据添加属性，不报错，但取值时是undefined

```
var a = 10;
a.pro = 10;
console.log(a.pro + a);

var s = 'hello';
s.pro = 'world';
console.log(s.pro + s);
```

答案：

```
NaN
undefinedhello
```

给基本类型数据加属性不报错，但是引用的话返回undefined，10+undefined返回NaN，而undefined和string相加时转变成了字符串。


### 6.函数声明优于变量声明

```
console.log(typeof fn);
function fn() {};
var fn;
```

答案：`function`

因为函数声明优于变量声明。我们知道在代码逐行执行前，函数声明和变量声明会提前进行，而函数声明又会优于变量声明，这里的优于可以理解为晚于变量声明后，如果函数名和变量名相同，函数声明就能覆盖变量声明。所以以上代码将函数声明和变量声明调换顺序还是一样结果。


### 7.判断一个字符串中出现次数最多的字符，并统计次数

hash table方式：

```
var s = 'aaabbbcccaaabbbaaa';
var obj = {};
var maxn = -1;
var letter;
for(var i = 0; i < s.length; i++) {
  if(obj[s[i]]) {
    obj[s[i]]++;
    if(obj[s[i]] > maxn) {
      maxn = obj[s[i]];
      letter = s[i];
    }
  } else {
    obj[s[i]] = 1;
    if(obj[s[i]] > maxn) {
      maxn = obj[s[i]];
      letter = s[i];
    }
  }
}

alert(letter + ': ' + maxn);
```

正则方式：

```
var s = 'aaabbbcccaaabbbaaabbbbbbbbbb';
var a = s.split('');
a.sort();
s = a.join('');
var pattern = /(\w)\1*/g;
var ans = s.match(pattern);
ans.sort(function(a, b) {
  return a.length < b.length;
});;
console.log(ans[0][0] + ': ' + ans[0].length);
```

### 8.经典闭包

```
<!-- 实现一段脚本，使得点击对应链接alert出相应的编号 -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<body>
  <a href='#'> 第一个链接 </a> </br>
  <a href='#'> 第二个链接 </a> </br>
  <a href='#'> 第三个链接 </a> </br>
  <a href='#'> 第四个链接 </a> </br>
</body>
```

dom污染法：

```
<!-- 实现一段脚本，使得点击对应链接alert出相应的编号 -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<body>
  <a href='#'> 第一个链接 </a> </br>
  <a href='#'> 第二个链接 </a> </br>
  <a href='#'> 第三个链接 </a> </br>
  <a href='#'> 第四个链接 </a> </br>
  <script type="text/javascript">
    var lis = document.links;
    for(var i = 0, length = lis.length; i < length; i++) {
      lis[i].index = i;
      lis[i].onclick = function() {
        alert(this.index);
      };
    }
  </script>
</body>
```

闭包

```
<!-- 实现一段脚本，使得点击对应链接alert出相应的编号 -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<body>
  <a href='#'> 第一个链接 </a> </br>
  <a href='#'> 第二个链接 </a> </br>
  <a href='#'> 第三个链接 </a> </br>
  <a href='#'> 第四个链接 </a> </br>
  <script type="text/javascript">
    var lis = document.links;
    for(var i = 0, length = lis.length; i < length; i++) {
      (function(i) {
        lis[i].onclick = function() {
          alert(i + 1);
        };
      })(i);
    }
  </script>
</body>
```

### 9.this

```
function JSClass() {
  this.m_Text = 'division element';
  this.m_Element = document.createElement('div');
  this.m_Element.innerHTML = this.m_Text;
  this.m_Element.addEventListener('click', this.func);
  // this.m_Element.onclick = this.func;
}

JSClass.prototype.Render = function() {
  document.body.appendChild(this.m_Element);
}

JSClass.prototype.func = function() {
  alert(this.m_Text);
};

var jc = new JSClass();
jc.Render();  // add div
jc.func();  // 输出 division element
//click添加的div元素division element会输出underfined，为什么？
```

答案：

```
division
element
undefined
```

第一次输出很好理解，第二次的话仔细看，this其实已经指向了this.m_Element，因为是this.m_Element调用的addEventListener函数，所以内部的this全指向它了。可以试着加上一行代码this.m_Element.m_Text = 'hello world'，就会alert出hello world了。


### 10.split

请编写一个JavaScript函数 parseQueryString，它的用途是把URL参数解析为一个对象，如： var url = “http://witmax.cn/index.php?key0=0&key1=1&key2=2″

```
function parseQueryString(url) {
  var obj = {};
  var a = url.split('?');
  if(a.length === 1) return obj;
  var b = a[1].split('&');
  for(var i = 0, length = b.length; i < length; i++) {
    var c = b[i].split('=');
    obj[c[0]] = c[1];
  }
  return obj;
}
var url = 'http://witmax.cn/index.php?key0=0&key1=1&key2=2';
var obj = parseQueryString(url);
console.log(obj.key0, obj.key1, obj.key2);  // 0 1 2
```