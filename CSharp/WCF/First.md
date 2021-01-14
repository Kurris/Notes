### C# WCF框架---初认识
>**前言**： 是.net的分布式技术的总体封装
>
>* webservice  基于http协议的soap模式（信封+正文）
* remoting 常用于tcp模式的二进制传输
* MSMQ 离线分布式的技术，常用于业务解耦

* 另外一种wcf的rest模式是单独剥离的webapi模式

---
>**概念**：`ABC`
* **A**： **address**
         就像是访问web的一个地址 
* **B**： **Binding**
就像是client和server之间的一个通道/协议。

WCF目前支持BasiceHttpBinding【wsHttpBinding】，NetTcpBinding，NetMSMQBinding

* **C**： **Contract**
定义的接口是如何，例如：返回值，方法名，参数。。。

---

>开始创建WCF服务
1. 新建项目 -> 选择WCF模板
2. Steps：
    >Service:
    >*  **需要定义一个接口:**
    >     该接口上需要定义一个ServiceContratAttribute 服务契约
    >     接口的方法中需要定义个OperationContract 
    >*  **需要定义一个实现类:**
    >     继承接口,实现方法!
    * **定义配置文件:**
       App.config/Web.config 都应该在system.serviceModel下面.
    *  **承载WCF:** 
       * IIS 用空的WEB项目创建并且添加WCF模板;
       * Console 直接添加WCF模板;
       * Winform 添加WCF模板;
       * ......
       
```c#
ServiceHost serviceHost = new ServiceHost(typeof(FlyClass));
serviceHost.Open();
Console.WriteLine("wcf running....");
```

>Client:

* **创建一个可执行程序**
* **添加服务引用**

    