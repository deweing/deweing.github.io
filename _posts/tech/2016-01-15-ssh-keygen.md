---
layout: post
title: ssh-keygen使用
category: 技术
tags: linux
keywords: ssh
description:
---

假设 A （192.168.0.10）为客户机器，B（192.168.0.11）为目标机；

1、登录A
2、ssh-keygen -t rsa，生成密钥文件和私钥文件 id_rsa, id_rsa.pub
3、将 .pub 文件复制到B机器的 .ssh 目录，并 cat id_dsa.pub >> ~/.ssh/authorized_keys
4、ssh 192.168.0.11

问题：

1、设置文件和目录权限：
设置.ssh目录权限
$ chmod 700 -R .ssh
设置authorized_keys权限
$ chmod 600 authorized_keys
