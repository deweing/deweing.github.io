---
layout: post
title: Linux系统中增加Swap分区大小
category: 技术
tags: [linux]
keywords: linux
description:
---

1.检查当前的分区情况:

```
[root@localhost]#free -m
```

2.增加交换分区文件及大小，如果要增加2G大小的交换分区，则命令写法如下，其中的 count 等于想要的块大小。

```
[root@localhost]# dd if=/dev/zero of=/home/swap bs=1024 count=2048000
```

3.设置交换文件：

```
[root@localhost]# mkswap /home/swap
```

4.立即启用交换分区文件

```
[root@localhost]# swapon /home/swap
```

5.如果要在引导时自动启用，则编辑 /etc/fstab 文件，添加行：

```
/home/swap swap swap defaults 0 0
```

系统下次引导时，它就会启用新建的交换文件，再查看SWAP分区大小发现增加了2G。