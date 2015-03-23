---
layout: post
title: Mysql复制表+主键(表结构、索引和主键、数据)
category: 技术
tags: MySQL
keywords: MySQL
description:
---

mysql> create table test_users like users;
复制表结构和索引到test_users (新表:test_users 原表:users)

mysql> insert into test_users (select * from users);
复制数据,两步加起来才能创建一个和users完全一样(表结构、索引和主键、数据)的表。

mysql> create table test_users select * from users;
(只复制表数据，以及表结构)

mysql> create table test_users select names from users;
复制users表里的names数据、结构到新表 test_users