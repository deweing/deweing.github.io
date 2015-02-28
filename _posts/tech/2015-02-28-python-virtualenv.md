---
layout: post
title: 使用Virtualenv搭建独立的Python环境
category: 技术
tags: Python
keywords: Python,Virtualenv
description:
---

## 安装Virtualenv
Virtualenv实际上是一个python包，所以我们可以用easy_install或者pip安装。

```
$ pip install virtualenv
```

## 创建python虚拟环境
使用virtualenv命令创建python虚拟环境：`virtualenv [env1]`

```
[root@localhost ~]# virtualenv env1
New python executable in env1/bin/python
Installing setuptools, pip...done.
```
执行后，在本地会生成一个与虚拟环境同名的文件夹。

如果想依赖系统环境的第三方软件包，可以使用参数--system-site-packages:

```
[root@localhost ~]# virtualenv --system-site-packages env1
New python executable in env1/bin/python
Installing setuptools, pip...done.
```

## 启动虚拟环境
进入虚拟环境目录，启动虚拟环境，

```
[root@localhost ~]# cd env1/
[root@localhost env1]# source bin/activate
(env1)[root@localhost env1]# python -V
Python 2.7.8
```
此时命令行前面会多出一个括号，括号里为虚拟环境的名称。以后easy_install或者pip安装的所有模块都会安装到该虚拟环境目录里。

## 退出虚拟环境
执行命令：`deactivate`

```
(env1)[root@localhost env1]# deactivate
[root@localhost env1]#
```

## 使用virtualenvwrapper
virtualenvwrapper是virtualenv的扩展工具，可以方便的创建、删除、复制、切换不同的虚拟环境。

### 安装virtualenvwrapper

```
$ pip install virtualenvwrapper
```

创建一个文件夹，用于存放所有的虚拟环境：

```
$ mkdir $HOME/.virtualenvs
```

将下面代码添加到`~/.bashrc`里

```
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
```

执行：`source ~/.bashrc`

### 使用virtualenvwrapper
1.创建虚拟环境：`mkvirtualenv [env1]`

```
[root@localhost ~]# mkvirtualenv env1
New python executable in env1/bin/python
Installing setuptools, pip...done.
(env1)[root@localhost ~]# mkvirtualenv env2
New python executable in env2/bin/python
Installing setuptools, pip...done.
(env2)[root@localhost ~]#
```

mkvirtualenv可以使用virtualenv的参数，比如--python来指定python版本。创建虚拟环境后，会自动切换到此虚拟环境里。虚拟环境目录都在WORKON_HOME里。

2.列出虚拟环境：`lsvirtualenv -b`

```
[root@localhost ~]# lsvirtualenv -b
env1
env2
```

3.切换虚拟环境：workon [env1]

```
(env2)[root@localhost ~]# workon env1
(env1)[root@localhost ~]# echo $VIRTUAL_ENV
/root/workspaces/env1
```

4.查看环境里安装了哪些包：`lssitepackages`
5.进入当前环境的目录：cdvirtualenv [子目录名]

```
(env1)[root@localhost ~]# cdvirtualenv
(env1)[root@localhost env1]# pwd
/root/workspaces/env1
(env1)[root@localhost env1]# cdvirtualenv bin
(env1)[root@localhost bin]# pwd
/root/workspaces/env1/bin
```

进入当前环境的site-packages目录：cdsitepackages [子目录名]

```
(env1)[root@localhost env1]# cdsitepackages
(env1)[root@localhost site-packages]# pwd
/root/workspaces/env1/lib/python2.6/site-packages
(env1)[root@localhost site-packages]# cdsitepackages pip
(env1)[root@localhost pip]# pwd
/root/workspaces/env1/lib/python2.6/site-packages/pip
```

6.控制环境是否使用global site-packages：toggleglobalsitepackages
7.复制虚拟环境：`cpvirtualenv [source] [dest]`

```
[root@localhost ~]# cpvirtualenv env1 env3
Copying env1 as env3...
(env3)[root@localhost ~]#
```

8.退出虚拟环境：deactivate
9.删除虚拟环境：rmvirtualenv [虚拟环境名称]

```
[root@localhost ~]# rmvirtualenv env2
Removing env2...
```