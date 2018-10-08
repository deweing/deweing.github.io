---
layout: post
title: 修改Docker存储位置
category: docker
tags: docker
keywords: docker
description:
---

在默认情况下，Docker镜像和容器的默认存放位置为:/var/lib/docker

# 方法一：挂载新分区到/ var/lib/docker目录下

### 1.创建新分区
```
fdisk -l
fdisk /dev/sdc
mkfs -t ext4 /dev/sdc1
#临时挂载新分区
mkdir /mnt/docker
mount /dev/sdc1 /mnt/docker
```

### 2.停止docker服务，cp目录
```
service docker stop
cp -r /var/lib/docker/* /mnt/docker
```

### 3.挂载新分区到/var/lib/docker
```
#备份原目录
mv /var/lib/docker{,.bak}
#创建新目录
mkdir /var/lib/docker

mount /dev/sdc1 /var/lib/docker
unmout /mnt/docker
```

设置开机自动挂载
```
vim /etc/fstab

#添加以下命令
---
/dev/sdc1 /var/lib/docker ext4 defaults 1 1
```

### 4.启动docker，验证
```
service docker start
docker images
docker ps -a
```

# 方法二：修改容器和镜像的存储位置

在Docker服务配置文件/etc/sysconfig/docker中修改镜像和容器存放路径的参数， 在配置文件中加入：

```
other_args="--graph=/data/docker"。
```