---
layout: post
title: Mycat安装配置记录
category: 技术
tags: [mysql,mycat]
keywords: mycat
description:
---

### 1.安装JDK
注：JDK7或者更高版本

### 2.安装MySQL
MYCAT支持多种数据库，如：MySQL、SQLServer、Oracle、MongoDB
**注意**：Linux下部署安装MySQL，默认不忽略表名大小写，需要修改my.cnf配置：`lower_case_table_names=1` 忽略表名大小写，否则MyCat会提示找不到表的错误！

### 3.安装MyCat
下载地址：[https://github.com/MyCATApache/Mycat-download](https://github.com/MyCATApache/Mycat-download)
将Mycat-server-xxxxx.linux.tar.gz解压到指定的目录下，目录不能有空格，linux下，建议放在usr/local/Mycat目录下

```sh
useradd Mycat
chown -R Mycat:Mycat /usr/local/Mycat
```

### 4.配置与启动
  - 在linux环境变量中配置MYCAT_HOME
    - `vi /etc/profile`，在系统环境变量中添加`MYCAT_HOME=/usr/loca/Mycat`
    - 执行生效：`source /etc/profile`
  - mycat配置文件:
    - MYCAT_HOME/conf/schema.xml；定义逻辑库、表、分片节点等内容
    - MYCAT_HOME/conf/server.xml：定义用户及系统相关变量，如端口等
    - MYCAT_HOME/conf/rule.xml：定义分片规则
  - 在/usr/local/Mycat/bin目录下执行：`./mycat start`

  即可启动mycat服务
