---
layout: post
title: Mycat自增主键设置
category: 技术
tags: mysql,mycat
keywords: mycat
description:
---

1.在server.xml中，将sequnceHandlerType设置为1  

```xml
<property name="sequnceHandlerType">1</property>
```

2.在schema.xml中，table中增加属性autoIncrement值为true，添加mycat_sequence表

```xml
<schema name="TESTDB" checkSQLschema="false" sqlMaxLimit="100">
    <!-- random sharding using mod sharind rule -->
    <!-- autoIncrement="true" 属性-->
    <table name="tt2" primaryKey="id" autoIncrement="true" dataNode="dn1,dn2,dn3,dn4,dn5" rule="mod-long" />
    <table name="mycat_sequence" primaryKey="name" dataNode="dn1" />
</schema>
```

3.在sequence_db_conf.properties中，依赖全局序列，增加序列，与table名称相同全大写  

```
TT2=dn1
```

4.创建mycat_sequence表  

```sql
DROP TABLE IF EXISTS MYCAT_SEQUENCE;   
CREATE TABLE MYCAT_SEQUENCE(   
    name VARCHAR(50) NOT NULL,  
    current_value INT NOT NULL,  
    increment INT NOT NULL DEFAULT 100,  
    PRIMARY KEY(name)  
) ENGINE=InnoDB;  
```

- name：sequence名称  
- currenct_value：当前value  
- increment：增长步长  
注：MYCAT_SEQUENCE必须大写  

5.插入sequence记录  

```sql
INSERT INTO MYCAT_SEQUENCE(name, current_value, increment) VALUES ('TT2', 1, 100);
```

6.创建存储函数，必须在同一个数据库中创建  

```sql
-- 获取当前sequence的值 (返回当前值,增量)  
DROP FUNCTION IF EXISTS mycat_seq_currval;  
DELIMITER $  
CREATE FUNCTION mycat_seq_currval(seq_name VARCHAR(50)) RETURNS varchar(64) CHARSET utf8  
DETERMINISTIC  
BEGIN  
DECLARE retval VARCHAR(64);  
SET retval="-999999999,null";  
SELECT concat(CAST(current_value AS CHAR),",",CAST(increment AS CHAR)) INTO retval FROM MYCAT_SEQUENCE WHERE name = seq_name;  
RETURN retval;  
END $  
DELIMITER ;  
      
-- 设置sequence值  
DROP FUNCTION IF EXISTS mycat_seq_setval;  
DELIMITER $  
CREATE FUNCTION mycat_seq_setval(seq_name VARCHAR(50),value INTEGER) RETURNS varchar(64) CHARSET utf8  
DETERMINISTIC  
BEGIN  
UPDATE MYCAT_SEQUENCE  
SET current_value = value  
WHERE name = seq_name;  
RETURN mycat_seq_currval(seq_name);  
END $  
DELIMITER ;  
    
-- 获取下一个sequence值  
DROP FUNCTION IF EXISTS mycat_seq_nextval;  
DELIMITER $  
CREATE FUNCTION mycat_seq_nextval(seq_name VARCHAR(50)) RETURNS varchar(64 CHARSET utf8  
DETERMINISTIC  
BEGIN  
UPDATE MYCAT_SEQUENCE  
SET current_value = current_value + increment WHERE name = seq_name;  
RETURN mycat_seq_currval(seq_name);  
END $  
DELIMITER ;  
```

7.在mysql中定义自增主键  

```sql
CREATE TABLE `tt2` (  
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,  
  `nm` INT(10) UNSIGNED NOT NULL,  
  PRIMARY KEY (`id`)  
) ENGINE=MYISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;  
```

8.插入记录  

```sql
insert into tt2(nm) values (99);
```

FROM:  
1.[MyCAT自增字段和返回生成的主键ID的经验分享](https://github.com/MyCATApache/Mycat-doc/blob/master/MyCAT%E8%87%AA%E5%A2%9E%E5%AD%97%E6%AE%B5%E5%92%8C%E8%BF%94%E5%9B%9E%E7%94%9F%E6%88%90%E7%9A%84%E4%B8%BB%E9%94%AEID%E7%9A%84%E7%BB%8F%E9%AA%8C%E5%88%86%E4%BA%AB)  
2.[MyCAT 性能测试](http://valleylord.github.io/post/201603-mycat-perf-test/)  
3.[mycat分布式mysql中间件（自增主键）](http://www.songwie.com/articlelist/68)  
4.[MyCAT全局序列号](http://www.cnblogs.com/ivictor/p/5235147.html)  