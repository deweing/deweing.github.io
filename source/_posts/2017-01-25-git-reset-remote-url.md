---
layout: post
title: Git切换远程仓库地址
category: 工具
tags: git
keywords: git
description:
---

使用git时，免不了要修改远程仓库地址，下面有3钟方法可以修改：

### 1.修改命令

```
git remote set-url origin [url]
```

### 2.先删后加

```
git remote rm origin
git remote add origin [url]
git push -u origin --all
git push -u origin --tags
```

### 3.修改config文件

在.git文件夹下找到config文件，修改remote.origin.url
