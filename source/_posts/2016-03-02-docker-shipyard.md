---
layout: post
title: Docker管理工具Shipyard
category: 工具
tags: linux
keywords: docker,shipyard
description:
---

### 1.Shipyard介绍
[Shipyard](http://shipyard-project.com/)是一个基于Web的Docker管理工具，基于Docker Swarm，支持多主机，可以把多个Docker主机上的容器统一管理；可以查看镜像，下拉镜像；可以管理私有镜像仓库；并提供 RESTful API 等。

- **Datastore**: 首先启动的就是RethinkDB容器，shipyard采用RethinkDB作为数据库来保存账户，引擎，服务键值以及元信息等信息。
- **Discovery**: 为了使用Swarm的选举机制，我们需要一个外部的密钥值存储容器，shipyard默认采用了etcd。
- **Proxy**: 默认情况下，Docker引擎只监听Socket，我们可以重新配置引擎使用TLS或者使用一个代理容器，转发请求从TCP到Docker监听的UNIX Socket。
- **Swarm Manager**: Swarm管理器
- **Swarm Agent**: Swarm代理，运行在每个节点上。
- **Controller**: Shipyard控制器，Remote API的实现和web的实现。

### 2.实例

准备两台服务器，关闭防火墙；

- 主节点 IP:192.168.0.2
- 从节点 IP:192.168.0.11

#### 1) 安装主节点(192.168.0.2)
安装官方文档依次安装环境

**Datastore**

```sh
$> sudo docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-rethinkdb \
    rethinkdb
```

**Discovery**

```sh
$> sudo docker run \
    -ti \
    -d \
    -p 4001:4001 \
    -p 7001:7001 \
    --restart=always \
    --name shipyard-discovery \
    microbox/etcd -name discovery
```

**Proxy**

```sh
$> sudo docker run \
    -ti \
    -d \
    -p 2375:2375 \
    --hostname=$HOSTNAME \
    --restart=always \
    --name shipyard-proxy \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e PORT=2375 \
    shipyard/docker-proxy:latest
```

**Swarm Manager**

```sh
$> sudo docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-swarm-manager \
    swarm:latest \
    manage --host tcp://0.0.0.0:3375 etcd://192.168.0.2:4001
```

**Swarm Agent**

```sh
$> sudo docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-swarm-agent \
    swarm:latest \
    join --addr 192.168.0.2:2375 etcd://192.168.0.2:4001
```

**Controller**

```sh
$> docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-controller \
    --link shipyard-rethinkdb:rethinkdb \
    --link shipyard-swarm-manager:swarm \
    -p 8080:8080 \
    shipyard/shipyard:latest \
    server \
    -d tcp://swarm:3375
```

#### 2) 添加从节点(192.168.0.11)

**Proxy**

```sh
$> sudo docker run \
    -ti \
    -d \
    -p 2375:2375 \
    --hostname=$HOSTNAME \
    --restart=always \
    --name shipyard-proxy \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e PORT=2375 \
    shipyard/docker-proxy:latest
```

**Swarm Manager**

```sh
$> sudo docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-swarm-manager \
    swarm:latest \
    manage --replication --addr 192.168.0.11:3375<从节点> --host tcp://0.0.0.0:3375 etcd://192.168.0.2:4001<主节点>
```

**Swarm Agent**

```sh
$> sudo docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-swarm-agent \
    swarm:latest \
    join --addr 192.168.0.11:2375<从节点> etcd://192.168.0.2:4001<主节点>
```

#### 3) 访问Web页面
访问http://192.168.0.2:8080，输入默认用户名和密码：admin/shipyard
![login](/images/tool/shipyard/login.jpg)
![dashboard](/images/tool/shipyard/dashboard.jpg)


参考：
1.[https://shipyard-project.com/docs/deploy/manual/](https://shipyard-project.com/docs/deploy/manual/)
2.[https://docs.docker.com/swarm/multi-manager-setup/](https://docs.docker.com/swarm/multi-manager-setup/)
3.[http://blog.yaodataking.com/2016/01/docker-shipyard.html](http://blog.yaodataking.com/2016/01/docker-shipyard.html)