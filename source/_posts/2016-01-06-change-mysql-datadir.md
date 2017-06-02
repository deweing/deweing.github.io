---
layout: post
title: 修改mysql的datadir目录
category: 技术
tags: mysql
keywords: mysql
description:
---

### 1.停止mysql

```
sudo /etc/init.d/mysql stop
```

### 2.复制/var/lib/mysql目录到指定的路径

```
sudo cp -R -p /var/lib/mysql /data/mysql
```

### 3.修改mysql配置文件my.cnf:

```
datadir=/data/mysql
socket=/data/mysql/mysql.sock
```

### 4.修改apparmor

```
sudo vim /etc/apparmor.d/usr.sbin.mysqld
```

将/var/lib/mysql路径替换为/data/mysql

```
#/var/lib/mysql/ r,
#/var/lib/mysql/** rwk,
/data/mysql/ r,
/data/mysql/** rwk,
```

### 5.重启

```
sudo /etc/init.d/apparmor restart
sudo /etc/init.d/mysql restart
```

from:
1.[How to change MySQL data directory?](http://stackoverflow.com/questions/1795176/how-to-change-mysql-data-directory)
2.[Linux Ubuntu change datadir / database location dir in 5 minutes Move mysql database to other path](http://article.my-addr.com/?show=linux_ubuntu_change_datadir-move_mysql_database_to_other_path)