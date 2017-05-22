---
layout: post
title: Docker中的CMD和ENTRYPOINT区别
category: 技术
tags: docker
keywords: docker
description:
---

### 1.CMD

```
The main purpose of a CMD is to provide defaults for an executing container.
CMD在容器运行的时候提供一些命令及参数，用法如下：

1.CMD ["executable","param1","param2"] (exec form, this is the preferred form)
2.CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
3.CMD command param1 param2 (shell form)
```

如：`CMD ["/bin/echo", "this is a echo test"]`, docker run: `docker run imagename`后输出: `this is a echo test`   

docker run命令如果指定了参数会把CMD里的参数覆盖   
如：`docker run imagename /bin/bash`, 就不会输出：this is a echo test，因为CMD命令被”/bin/bash”覆盖了   

### 2.ENTRYPOINT

```
An ENTRYPOINT allows you to configure a container that will run as an executable.
它可以让你的容器功能表现得像一个可执行程序一样。

1.ENTRYPOINT ["executable", "param1", "param2"] (exec form, preferred)
2.ENTRYPOINT command param1 param2 (shell form)
```

如：`ENTRYPOINT ["/bin/echo"]`，那么build出来的镜像以后的容器功能就像一个/bin/echo程序
`docker run -it imagename "this is a test" `就等于`/bin/echo "this is a test"`

注：
1.ENTRYPOINT有两种写法，第二种(shell form)会屏蔽掉docker run时后面加的命令和CMD里的参数。
2.Dockerfile中同时有ENTRYPOINT和CMD，是将CMD当参数传入ENTRYPOINT

### 3.Demo
Dockefile
```
FROM debian:latest

ADD entypoint.sh /entypoint.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

ENTRYPOINT ["/entypoint.sh"]
CMD [/run.sh]
```

run.sh
```
#!/bin/bash

echo "=> do run.sh!"
```

entypoint.sh
```
#!/bin/bash

echo "=> do entypoint.sh!"
echo "=> Quoted Values: $*"
```

Biuld && Run
```
sudo docker build -t debian:test .
sudo docker run --rm debian:test
```

1.当`ENTRYPOINT ["/entypoint.sh"]`和`CMD ["/run.sh"]`，输出结果：
```
=> do entypoint.sh!
=> Quoted Values: /run.sh
```

2.当`ENTRYPOINT /entypoint.sh`和`CMD ["/run.sh"]`，输出结果：
```
=> do entypoint.sh!
=> Quoted Values: 
```

3.当`ENTRYPOINT ["/entypoint.sh"]`和`CMD /run.sh`，输出结果：
```
=> do entypoint.sh!
=> Quoted Values: /bin/sh -c /run.sh
```