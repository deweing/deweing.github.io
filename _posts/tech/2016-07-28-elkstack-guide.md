---
layout: post
title: Elasticsearch入坑指北
category: 技术
tags: mysql
keywords: elasticsearch,logstash,kibana
description:
---

### 1. 安装

Elasticsearch,Logstash,Kibana 安装其实还挺简单，只需要java7以上的版本支持即可；

### 2. 配置

#### 2.1. Elasticsearch  
- es不能以root用户启动，所以最好为elk创建单独的用户
- 内存分配，有两种方式修改Elasticsearch的堆内存：
    - 第一种比较简单，指定ES_HEAP_SIZE环境变量：export ES_HEAP_SIZE=10g
    - 第二种通过命令行参数的形式，在程序启动的时候把内存大小传递给它：./bin/elasticsearch -Xmx10g -Xms10g
- 调整线程池，修改config/elasticsearch.yml文件  

```yml
threadpool.index.type: fixed
# 池大小：建议2~3倍cpu数
threadpool.index.size: 24
threadpool.index.queue_size: 1000

threadpool.search.type: fixed
# 池大小：建议2~3倍cpu数
threadpool.search.size: 24
threadpool.search.queue_size: 1000
```  

#### 2.2. Logstash  
- 在LOGSTASH_HOME/conf下，创建logstash.conf

```sh
input {
    tcp {
        mode => 'server'
        port  => 8866
        codec => "json"
    }
}

output {
    elasticsearch {
        hosts => ["elasticsearch:9200"]
        index => "truck-%{+yyyy.MM.dd}"
        workers => 1
        flush_size => 20000
        idle_flush_time => 10
        template_overwrite => true
    }
}
```

#### 2.3. Kibana  
- 在config/kibana.yml文件里，修改elasticsearch.url配置

```yml
# The Elasticsearch instance to use for all your queries.
elasticsearch.url: "http://elasticsearch:9200"
```

### 3. 使用

```sh
curl -XDELETE 'http://localhost:9200/truck-*?pretty'

curl -XPUT 'http://localhost:9200/_template/truck?pretty' -d@/opt/elasticsearch/templates/truck.template.json

curl -XGET 'http://localhost:9200/truck-*/_search?pretty' -d '
{   
    "from": 0,
    "size": 10,
    "query" : {
        "match" : {
          "level" : "TRACE"
        }
    },
    "sort": [
        { "totalTime" : "desc" }
    ]
}
```