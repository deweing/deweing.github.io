---
layout: post
title: 判断服务器是否支持断点续传
category: 技术
tags: Linux
keywords: Linux
description:
---

通常情况下，Web服务器(如Apache)会默认开启对断点续传的支持。因此，如果直接通过Web服务器来提供文件的下载，可以不必做特别的配置，即可享受到断点续传的好处。断点续传是在发起HTTP请求的时候加入RANGE头来告诉服务器客户端已经下载了多少字节。等所有这些请求都返回之后，再把得到的内容一块一块的拼接起来得到完整的资源。

1.判断服务器是否支持断点续传

```
wget -S http://www.example.com/test.zip 2>&1 | grep 'Accept-Ranges'
 Accept-Ranges: bytes
```
输出结果 Accept-Ranges: bytes ，说明服务器支持按字节下载。

2.curl 命令发送字节范围下载

```
curl -–range 0-99 http://www.example.com/test.zip > t.zip
```

