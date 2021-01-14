### C# WCF框架---TCP/MSMQ
>**快速实现TCP和MSMQ模式**


* `netTcpBinding:`
    1. 修改配置文件 **binding="netTcpBinding"**
    2. 修改配置文件 **address="net.tcp://localhost:1234/MyWcf"**
     <u> 也可以自定义一个端口地址,这样我们就可以跨机器,跨进程访问; </u>
    

场景:<u>俩个.net程序搭建的跨机器访问,`TCP`远比`HTTP->basicHttpBinding`要快</u>

例如:.net与java之间就是需要使用http访问
     
     
* `netMSMQBinding:`
    * 这是封装MSMQ的一个专用类
    * 基于硬盘的方式
    * 蓄水池的方式,如 Client->信息->MSMQ<-Service 读取信息->执行操作

**搭建:**
1. 启用MSMQ功能:win+R----control----程序----启用或关闭windows功能----MSMQ
2. 计算机管理----服务和应用程序----消息队列----专用队列
    新建与address地址相同的队列名称,并且勾上事务性; 
3. * WCF接口服务实现的方式需要定义`双工模式`,方法`特性OperationContract`必须给属性`IsOneWay=true;`,
    * 方法为无返回值
    * 需要有参
4. 配置文件:
    * address="net.msmq://localhost/private/MyWcf"
    <u>不能给url指定端口,因为这不是访问;</u>
    * binding="netMsmqBinding"
    * bindingConfiguration="下面的binding模式---mymodel"
    
    在system.serviceModel中添加以下binding模式
    
```C#
    <bindings>
        <netMsmqBinding>
          <binding name="mymodel">
            <security mode="None"></security>
          </binding>
        </netMsmqBinding>
   </bindings>
```

当WCF启动的时候,在MSMQ的信息就会被读取到