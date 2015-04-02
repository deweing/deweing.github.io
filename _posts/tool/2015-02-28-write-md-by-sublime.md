---
layout: post
title: 将Sublime打造成Markdown编辑器
category: 工具
tags: sublime
keywords: sublime,markdown
description:
---

## 安装Package Control
打开Sublime Text，按下组合键 Ctrl+` ，出现控制台，输入：

```
import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())
```

## 安装Markdown Preview
按下`Ctrl+Shift+p`调出命令面板，找到`Package Control: Install Pakage`这一项。搜索 markdown preview，点击安装。

### 使用
Markdown Preview常用的功能是`preview in browser`和`Export HTML in Sublime Text`，前者可以在浏览器中看到效果，后者可将markdown保持为html文件。

### 快捷键
在`Preferences -> Key Bindings User`打开的文件中添加以下代码：

```
{ "keys": ["alt+m"], "command": "markdown_preview", "args": { "target": "browser"} }
```

### 设置语法高亮和mathjax支持
在`Preferences -> Package Settings -> Markdown Preview -> Setting User`中，将下面设置项改为true即可

```
{
	"enable_mathjax": true,
	"enable_highlight": true
}
```

## 安装Smart Markdown
按下`Ctrl+Shift+p`调出命令面板，找到`Package Control: Install Pakage`这一项。搜索 smart markdown，点击安装。
