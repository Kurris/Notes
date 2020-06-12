### C# WCF框架---无配置方式
>WCF的配置都是程序运行的过程中或者config文件的endpoint和元数据
>那么通过反编译代码,可以清晰的了解到或者config文件的类是如何使用的!

---
#### 在承载WCF的程序中:
1. `ServiceHost serviceHost = new ServiceHost(typeof(`<u>FlyClass</u>`), new 
Uri(`<u>"http://localhost:8733/WCFLearn/MyWcf/"</u>`));`

    **在ServiceHost中,我们明确需要实现类还有指定WCF的服务地址**

2. `serviceHost.AddServiceEndpoint(typeof(`<u>IFlyService</u>`), new BasicHttpBinding(), 
string.Empty);`

    **在ServiceHost中添加终结点,这个也是我们自己定义的服务;**
    **指定服务接口**
    **指定绑定类型**
    **空地址**(初始化已经赋予)
   
3. `serviceHost.Description.Behaviors.Add(new ServiceMetadataBehavior() { 
HttpGetEnabled = true, HttpsGetEnabled = true });`
    **添加服务的行为**
   
    `serviceHost.Description.Behaviors.Find<ServiceDebugBehavior>().IncludeExceptionDetailInFaults = false;`
    **<u>有的服务行为在初始化时已经存在,这个时候我们需要通过update去更新</u>**


4. `serviceHost.AddServiceEndpoint(typeof(IMetadataExchange), 
MetadataExchangeBindings.CreateMexHttpBinding(), "mex");`
    **绑定元数据协议**

---
#### 在客户端中:
1. `ChannelFactory<IFlyService> factory = new ChannelFactory<IFlyService>(new BasicHttpBinding(), "http://localhost:8733/WCFLearn/MyWcf/");`
    **创建信道工厂**
    **指定接口类型**
    **指定绑定类型**
    **指定服务地址**
    
2.          `factory.Open();`
    **打开信道工厂**
3.        `  factory.CreateChannel().Fly("I CAN FLY");`
    **创建信道**---->**调用方法**
4. `         factory.Close();`
    **异常时关闭信道工厂**