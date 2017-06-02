---
layout: post
title: 判断服务器是否支持断点续传
category: 技术
tags: linux
keywords: linux
description:
---

通常情况下，Web服务器(如Apache)会默认开启对断点续传的支持。因此，如果直接通过Web服务器来提供文件的下载，可以不必做特别的配置，即可享受到断点续传的好处。断点续传是在发起HTTP请求的时候加入RANGE头来告诉服务器客户端已经下载了多少字节。等所有这些请求都返回之后，再把得到的内容一块一块的拼接起来得到完整的资源。

1.判断服务器是否支持断点续传

```
wget -S http://www.example.com/test.zip 2>&1 | grep 'Accept-Ranges'
 Accept-Ranges: bytes
```
输出结果 Accept-Ranges: bytes ，说明服务器支持按字节下载。

2.curl 命令发送字节范围下载

```
curl -–range 0-99 http://www.example.com/test.zip > t.zip
```

3.FileDownload.class.php

```
<?php  

class FileDownload{ 
  
    private $_speed = 512;  
  
  
    /** 下载 
    * @param String  $file   要下载的文件路径 
    * @param String  $name   文件名称,为空则与下载的文件名称一样 
    * @param boolean $reload 是否开启断点续传 
    */  
    public function download($file, $name='', $reload=false)
    {  
        if(file_exists($file))
        {  
            if($name=='')
            {  
                $name = basename($file);  
            }  
  
            $fp = fopen($file, 'rb');  
            $file_size = filesize($file);  
            $ranges = $this->getRange($file_size);  
  
            header('cache-control:public');  
            header('content-type:application/octet-stream');  
            header('content-disposition:attachment; filename='.$name);  
  
            if($reload && $ranges!=null)
            { // 使用续传  
                header('HTTP/1.1 206 Partial Content');  
                header('Accept-Ranges:bytes');  
      
                // 剩余长度  
                header(sprintf('content-length:%u',$ranges['end']-$ranges['start']));  
      
                // range信息  
                header(sprintf('content-range:bytes %s-%s/%s', $ranges['start'], $ranges['end'], $file_size));  
      
                // fp指针跳到断点位置  
                fseek($fp, sprintf('%u', $ranges['start']));  
            }else{  
                header('HTTP/1.1 200 OK');  
                header('content-length:'.$file_size);  
            }  
  
            while(!feof($fp))
            {  
                echo fread($fp, round($this->_speed*1024,0));  
                ob_flush();  
                //sleep(1); // 用于测试,减慢下载速度  
            }  
      
            ($fp!=null) && fclose($fp);  
      
        }else{  
            return '';  
        }  
    }  
  
  
    /** 设置下载速度 
    * @param int $speed 
    */  
    public function setSpeed($speed)
    {  
        if(is_numeric($speed) && $speed>16 && $speed<4096)
        {  
            $this->_speed = $speed;  
        }  
    }  
  
  
    /** 获取header range信息 
    * @param  int   $file_size 文件大小 
    * @return Array 
    */  
    private function getRange($file_size)
    {  
        if(isset($_SERVER['HTTP_RANGE']) && !empty($_SERVER['HTTP_RANGE']))
        {  
            $range = $_SERVER['HTTP_RANGE'];  
            $range = preg_replace('/[\s|,].*/', '', $range);  
            $range = explode('-', substr($range, 6));  
            if(count($range)<2)
            {  
                $range[1] = $file_size;  
            }  
            $range = array_combine(array('start','end'), $range);  
            if(empty($range['start']))
            {  
                $range['start'] = 0;  
            }  
            if(empty($range['end']))
            {  
                $range['end'] = $file_size;  
            }  
            return $range;  
        }  
        return null;  
    }  
  
} // class end  
  
?> 
```
 
demo

```
<?php  
    require('FileDownload.class.php');  
    $file = 'book.zip';  
    $name = time().'.zip';  
    $obj = new FileDownload();  
    $flag = $obj->download($file, $name);  
    //$flag = $obj->download($file, $name, true); // 断点续传  
      
    if(!$flag){  
        echo 'file not exists';  
    }  
?>
```

4.Discuz!论坛软件的attachment.php

```
<?php
$range = 0; 
if($readmod == 4) 
{ 
    dheader('Accept-Ranges: bytes'); 
    if(!emptyempty($_SERVER['HTTP_RANGE'])) 
    { 
        list($range) = explode('-',(str_replace('bytes=', '', $_SERVER['HTTP_RANGE']))); 
        $rangesize = ($filesize - $range) > 0 ? ($filesize - $range) : 0; 
        dheader('Content-Length: '.$rangesize); 
        dheader('HTTP/1.1 206 Partial Content'); 
        dheader('Content-Range: bytes='.$range.'-'.($filesize-1).'/'.($filesize)); 
    } 
}  
?>
```