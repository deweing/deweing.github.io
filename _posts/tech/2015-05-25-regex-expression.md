---
layout: post
title: 常用正则表达式
category: 技术
tags: regex
keywords: regex
description:
---

说明：正则表达式通常用于两种任务：1.验证，2.搜索/替换。用于验证时，通常需要在前后分别加上^和$，以匹配整个待验证字符串；搜索/替换时是否加上此限定则根据搜索的要求而定，此外，也有可能要在前后加上\b而不是^和$。此表所列的常用正则表达式，除个别外均未在前后加上任何限定，请根据需要，自行处理。

<table>
    <thead>
        <tr>
            <th>说明</th>
            <th>正则表达式</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>网址（URL）</td>
            <td><span class="regex">[a-zA-z]+://[^\s]*</span></td>
        </tr>
        <tr>
            <td>IP地址(IP Address)</td>
            <td><span class="regex">((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)</span></td>
        </tr>
        <tr>
            <td>电子邮件(Email)</td>
            <td><span class="regex">\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*</span></td>
        </tr>
        <tr>
            <td>QQ号码</td>
            <td><span class="regex">[1-9]\d{4,}</span></td>
        </tr>
        <tr>
            <td>HTML标记(包含内容或自闭合)</td>
            <td><span class="regex">&lt;(.*)(.*)&gt;.*&lt;\/\1&gt;|&lt;(.*) \/&gt;</span></td>
        </tr>
        <tr>
            <td>密码(由数字/大写字母/小写字母/标点符号组成，四种都必有，8位以上)</td>
            <td><span class="regex">(?=^.{8,}$)(?=.*\d)(?=.*\W+)(?=.*[A-Z])(?=.*[a-z])(?!.*\n).*$</span></td>
        </tr>
        <tr>
            <td>日期(年-月-日)</td>
            <td><span class="regex">(\d{4}|\d{2})-((1[0-2])|(0?[1-9]))-(([12][0-9])|(3[01])|(0?[1-9]))</span></td>
        </tr>
        <tr>
            <td>日期(月/日/年)</td>
            <td><span class="regex">((1[0-2])|(0?[1-9]))/(([12][0-9])|(3[01])|(0?[1-9]))/(\d{4}|\d{2})</span></td>
        </tr>
        <tr>
            <td>时间(小时:分钟, 24小时制)</td>
            <td><span class="regex">((1|0?)[0-9]|2[0-3]):([0-5][0-9])</span></td>
        </tr>
        <tr>
            <td>汉字(字符)</td>
            <td><span class="regex">[\u4e00-\u9fa5]</span></td>
        </tr>
        <tr>
            <td>中文及全角标点符号(字符)</td>
            <td><span class="regex">[\u3000-\u301e\ufe10-\ufe19\ufe30-\ufe44\ufe50-\ufe6b\uff01-\uffee]</span></td>
        </tr>
        <tr>
            <td>中国大陆固定电话号码</td>
            <td><span class="regex">(\d{4}-|\d{3}-)?(\d{8}|\d{7})</span></td>
        </tr>
        <tr>
            <td>中国大陆手机号码</td>
            <td><span class="regex">1\d{10}</span></td>
        </tr>
        <tr>
            <td>中国大陆邮政编码</td>
            <td><span class="regex">[1-9]\d{5}</span></td>
        </tr>
        <tr>
            <td>中国大陆身份证号(15位或18位)</td>
            <td><span class="regex">\d{15}(\d\d[0-9xX])?</span></td>
        </tr>
        <tr>
            <td>非负整数(正整数或零)</td>
            <td><span class="regex">\d+</span></td>
        </tr>
        <tr>
            <td>正整数</td>
            <td><span class="regex">[0-9]*[1-9][0-9]*</span></td>
        </tr>
        <tr>
            <td>负整数</td>
            <td><span class="regex">-[0-9]*[1-9][0-9]*</span></td>
        </tr>
        <tr>
            <td>整数</td>
            <td><span class="regex">-?\d+</span></td>
        </tr>
        <tr>
            <td>小数</td>
            <td><span class="regex">(-?\d+)(\.\d+)?</span></td>
        </tr>
        <tr>
            <td>不包含abc的单词</td>
            <td><span class="regex">\b((?!abc)\w)+\b</span></td>
        </tr>
    </tbody>
</table>