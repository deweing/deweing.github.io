---
layout: post
title: Iptables用法
category: 技术
tags: linux
keywords: iptables
description:
---

### 1.常用命令

查看filter规则

```
iptables -L -n
```

保存规则

```
iptables-save
iptables-save > /etc/sysconfig/iptables
```

删除规则

```
iptables -D INPUT 3
```

恢复规则

```
iptables-restore /etc/sysconfig/iptables
```

### 2.example

封ip

```
iptables -I INPUT -s 211.1.0.0 -j DROP
iptables -I INPUT -s 211.1.0.0/16 -j DROP
```

针对指定端口，限制ip访问

```
#先要关闭所有的9200端口
iptables -I INPUT -p tcp --dport 9200 -j DROP

#再开启允许访问的ip段
iptables -I INPUT -s 172.17.0.1/24 -p tcp --dport 9200 -j ACCEPT
iptables -I INPUT -s 172.22.4.1 -p tcp --dport 9200 -j ACCEPT
```

