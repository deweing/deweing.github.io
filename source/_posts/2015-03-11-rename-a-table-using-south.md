---
layout: post
title: 用South重命名数据表名
category: 技术
tags: python
keywords: python,south
description:
---

执行以下命令：

```
python manage.py schemamigration yourapp rename_foo_to_bar --empty
```

再生成的文件里面修改代码:

```
class Migration(SchemaMigration):

    def forwards(self, orm):
        db.rename_table('yourapp_foo', 'yourapp_bar')

    def backwards(self, orm):
        db.rename_table('yourapp_bar','yourapp_foo')   
```