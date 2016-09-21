ManagedONS
===========
阿里云帮助文档请查看 [.NET SDK 环境准备](https://help.aliyun.com/document_detail/29532.html?spm=5176.doc29561.6.102.Bjyn1T".NET SDK 环境准备")。

阿里云提供的.NET SDK是对C++的封装，有32位和64位之分。而.NET开发中一般会选择AnyCPU，这个项目的目的就是不用手动设置CPU目标平台，编译器根据目标平台选择相应的dll文件。

### 使用方法

打开程序包管理器控制台输入命令安装 `ManagedONS`
```
Install-Package ManagedONS 
```

### 注意事项

1. 需要安装 [Visual C++ Redistributable Packages for Visual Studio 2013](https://www.microsoft.com/zh-CN/download/details.aspx?id=40784 "Visual C++ Redistributable Packages for Visual Studio 2013")
2. Web 项目需要在 `Global.asax` 的 `Application_Start` 方法中添加如下代码

    ```
	var path = string.Concat(Environment.GetEnvironmentVariable("PATH"), ";", AssemblyUtil.GetBinDirectory());
	Environment.SetEnvironmentVariable("PATH", path, EnvironmentVariableTarget.Process);
    ```
    
### 博客地址

[在C#中使用阿里云消息队列(ONS/MQ)](http://www.darrenfang.com/2016/09/using-aliyun-message-queue-ons-mq-in-c-sharp/ "在C#中使用阿里云消息队列(ONS/MQ)")