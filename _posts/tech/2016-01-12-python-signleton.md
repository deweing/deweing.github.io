---
layout: post
title: Python创建单例模式的三种方式
category: 技术
tags: python
keywords: python
description:
---

### 1.使用装饰器

装饰器维护一个字典对象instances，缓存了所有单例类，只要单例不存在则创建，已经存在直接返回该实例对象。

```
def singleton(cls):
    instances = {}
    def warpper(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]
    return warpper

@singleton
class Foo(object):
    pass

foo1 = Foo()
foo2 = Foo()

print foo1 is foo2  # True
```

### 2.使用基类

__new__是真正创建实例对象的方法，所以重写基类的__new__方法，以此来保证创建对象的时候只生成一个实例

```
class Singleton(object):
    def __new__(cls, *args, **kwargs):
        if not hasattr(cls, '_instance'):
            cls._instance = super(Singleton, cls).__new__(cls, *args, **kwargs)
        return cls._instance

class Foo(Singleton):
    pass

foo1 = Foo()
foo2 = Foo()

print foo1 is foo2  # True
```

### 3.使用元类

元类（参考：[深刻理解Python中的元类](http://blog.jobbole.com/21351/)）是用于创建类对象的类，类对象创建实例对象时需要一定会调用__call__方法，因此在调用__call__时候保证始终只创建一个实例即可，type是python中的一个元类。

```
class Singleton(type):
    def __call__(cls, *args, **kwargs):
        if not hasattr(cls, '_instance'):
            cls._instance = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instance

class Foo(object):
    __metaclass__ = Singleton


foo1 = Foo()
foo2 = Foo()

print foo1 is foo2  # True
```