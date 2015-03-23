---
layout: post
title: 原生JS实现AJAX
category: 技术
tags: JavaScript,Ajax
keywords: JavaScript,Ajax
description:
---

## 1. 原生Ajax
ajax的技术核心是 XMLHttpRequest 对象；
ajax 请求过程：创建 XMLHttpRequest 对象、连接服务器、发送请求、接收响应数据；

```
ajax({
    url: "./test_xhr.php", //请求地址
    type: "POST", //请求方式
    data: {
        name: "super",
        age: 20
    }, //请求参数
    dataType: "json",
    success: function(response, xml) {
        // 此处放成功后执行的代码
    },
    fail: function(status) {
        // 此处放失败后执行的代码
    }
});

function ajax(options) {
    options = options || {};
    options.type = (options.type || "GET").toUpperCase();
    options.dataType = options.dataType || "json";
    var params = formatParams(options.data);

    //创建 - 非IE6 - 第一步
    if (window.XMLHttpRequest) {
        var xhr = new XMLHttpRequest();
    } else { //IE6及其以下版本浏览器
        var xhr = new ActiveXObject('Microsoft.XMLHTTP');
    }

    //接收 - 第三步
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4) {
            var status = xhr.status;
            if (status >= 200 && status < 300) {
                options.success && options.success(xhr.responseText, xhr.responseXML);
            } else {
                options.fail && options.fail(status);
            }
        }
    }

    //连接 和 发送 - 第二步
    if (options.type == "GET") {
        xhr.open("GET", options.url + "?" + params, true);
        xhr.send(null);
    } else if (options.type == "POST") {
        xhr.open("POST", options.url, true);
        //设置表单提交时的内容类型
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send(params);
    }
}

//格式化参数
function formatParams(data) {
    var arr = [];
    for (var name in data) {
        arr.push(encodeURIComponent(name) + "=" + encodeURIComponent(data[name]));
    }
    arr.push(("v=" + Math.random()).replace("."));
    return arr.join("&");
}
```


参考
1. [原生JS实现AJAX、JSONP及DOM加载完成事件][1]

[1]: http://www.html-js.com/article/1882