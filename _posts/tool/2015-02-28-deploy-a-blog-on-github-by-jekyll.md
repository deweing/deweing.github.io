---
layout: post
title: 在Github上搭建Jekyll博客
category: 工具
tags: Jekyll
keywords: Jekyll,Github
description:
---

## 创建库
在Github中创建一个名为`username.github.io`的库

## 安装Jekyll
```
$ gem install jekyll
$ jekyll new username.github.io
$ cd username.github.io
```

###目录结构图

```
├── CNAME
├── README.md
├── _config.yml
├── _includes
│   ├── disqus.html
│   ├── footer.html
│   ├── googleanalytics.html
│   ├── header.html
│   └── navside.html
├── _layouts
│   ├── base.html
│   ├── book.html
│   ├── page.html
│   └── post.html
├── _posts
│   ├── Book
│   ├── Life
│   ├── Resource
│   ├── Technology
│   └── Tool
├── index.html
├── pages
│   ├── about.html
│   ├── archive.html
│   └── atom.xml
├── public
│   ├── css
│   ├── fonts
│   ├── img
│   ├── js
│   └── upload
└── sitemap.txt

```

### 配置文件
`_config.yml`里面设置站点主要配置信息

```
permalink: /:year/:month/:day/:title.html   #博文的固定链接
paginate: 10                                #分页时每页博文数量
author:                                     #自定义常亮
  name: username
  email: username@example.com
  link: http://username.org
title: XX的博客                             #自定义常量
locals:                                     #自定义常量
  tags: 标签
  about: 关于
active: 技术                                #自定义常量
subscribe_rss: /pages/atom.xml              #订阅地址
markdown: redcarpet                         #markdown解释器
```

### 域名配置
`CNAME`这个文件写明了这个站点的域名，如果不喜欢`username.github.io`的话，可以改掉

### 博客存放
`_posts`下的所有目录中的所有博客，都会被Jekyll处理成为静态的html文件，然后放在`_site`下。

所以要把以下目录添加到`.gitignore`文件。

```
_site/
_drafts/
.DS_Store
```

在`_posts`下的符合`YYYY-MM-DD-xxxxxx.md`的文件，都会被Jekyll认定为博客内容。我在`_posts`下又新建了一些文件夹，主要是方便自己本地管理博客。

在上述这些文件中，必须先定义一些配置项，例如这篇博客的md文件中，开头是这样的：

```

layout: post                                   #这个博客的布局文件
title: 在Github上搭建自己的Jekyll博客          #博客标题
category: 工具                                 #博客分类
tags: Jekyll                                   #博客标签
keywords: Jekyll,Github                        #自定义常量
description:                                   #自定义常量

```

除了自定义常量外的必须包含进去，自定义变量在这个布局中可以访问。

### 模版文件
剩余的目录，基本都属于模板文件了，我解释一下各自的作用：

- `_includes` 可以在模板中随时包含的文件
- `_layouts` 布局文件，在博客头配置中可以选择
- `pages` 站内固定的页面
- `public` 公共资源，包括`js`,`css`,`img`等，还有我博客中调用的图片，我都放这里
- `index.html` 站点的首页，整个站的入口文件
- `sitemap.txt` 给搜索引擎看的，如何爬取这个站

## 本地预览及提交
本地预览自己的修改很容易，只要进入`username.github.io`目录，执行

```
$ jekyll serve
```

然后访问`http://localhost:4000`就OK了

自己预览过没有问题以后，就提交到服务端吧，Git三步走

```
git add xxx
git commit -m "xxx"
git push
```

参考
1. [在Github上搭建Jekyll博客和创建主题][1]

[1]: http://yansu.org/2014/02/12/how-to-deploy-a-blog-on-github-by-jekyll.html