---
layout: post
title: MySQL分表分区
category: 技术
tags: mysql
keywords: mysql
description:
---

**垂直分表**

垂直分表就是一个包含有很多列的表拆分成多个表，比如表A包含20个字段，现在拆分成表A1和A2，两个表各十个字段（具体如何拆根据业务来选择）。

优势：在高并发的情境下，可以减少表锁和行锁的次数。

劣势：在数据记录非常大的情况下，读写速度还是会遇到瓶颈。

**水平分表**

假如某个网站，它的数据库的某个表已经达到了上亿条记录，那么此时如果通过select去查询，在没有索引的情况下，他的查询会非常慢，那么就可以通过hash算法将这个表分成10个子表（此时每个表的 的数据量只有1000万条了）。同时生成一个总表，记录各个子表的信息，假如查询一条id=100的记录，它不再需要全表扫描，而是通过总表找到该记录在哪个对应的子表上，然后再去相应的表做检索，这样就降低了IO压力。

劣势：会给前端程序应用程序的SQL代码的维护带来很大的麻烦，这时候可以使用MySQL的Merge存储引擎实现分表。

用Merge存储引擎分表，对应用程序的SQL语句来说是透明的，不需要修改任何代码。

```
CREATE TABLE t1 (  a INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  message CHAR(20));
CREATE TABLE t2 (  a INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  message CHAR(20));

INSERT INTO t1 (message) VALUES ('Testing'),('table'),('t1');
INSERT INTO t2 (message) VALUES ('Testing'),('table'),('t2');

CREATE TABLE total (a INT NOT NULL AUTO_INCREMENT PRIMARY KEY, message CHAR(20)) ENGINE=MERGE  UNION=(t1,t2) INSERT_METHOD=LAST;
```

实际上merge存储引擎是一个虚拟的表，对应的实际表必须是myisam类型的表，如果你的mysql是5.1以上版本，默认数据库使用的事InnoDB存储引擎的，所以在创建total时，t1和t2表必须是myisam存储引擎的。

如果需要定期增加分表，只需要修改merge表的union即可。

```
CREATE TABLE t3(  a INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  message CHAR(20));
ALTER TABLE total  UNION=(t1,t2,t3)
```

**横向分区**

举例说明：假如有100W条数据，分成十份，前10W条数据放到第一个分区，第二个10W条数据放到第二个分区，依此类推。取出一条数据的时候，这条数据包含了表结构中的所有字段，横向分区并没有改变表的结构。

分区表分为RANGE,LIST,HASH,KEY四种类型,并且分区表的索引是可以局部针对分区表建立的
创建分区表

```
CREATE TABLE sales (   
    id INT AUTO_INCREMENT,   
    amount DOUBLE NOT NULL,   
    order_day DATETIME NOT NULL,   
    PRIMARY KEY(id, order_day)   
) ENGINE=Innodb PARTITION BY RANGE(YEAR(order_day)) (   
    PARTITION p_2010 VALUES LESS THAN (2010),   
    PARTITION p_2011 VALUES LESS THAN (2011),   
    PARTITION p_2012 VALUES LESS THAN (2012),   
    PARTITION p_catchall VALUES LESS THAN MAXVALUE);   
```

**纵向分区**

举例说明：在设计用户表的时候，开始的时候没有考虑好，而把个人的所有信息都放到了一张表里面去，这个表里面就会有比较大的字段，如个人简介，而这些简介呢，也许不会有好多人去看，所以等到有人要看的时候，再去查找，分表的时候，可以把这样的大字段，分开来

完整的一张表，都对应三个文件，一个.MYD数据文件，.MYI索引文件，.frm表结构文件。