### C# WCF框架---行为 Class Behavior
>client==>service之间的flow上做一些代码插入
* 在client-->service之间上做一些拦截代码,可以截获/修改flow上的数据;
* 在service启动的时候,插入一些代码做定制处理;


#### 并发/实例化
**测试**,在service中增加一个类变量<u>**num=0**</u>记录次数,invoke则将其打印,并且num++;
```C#
var binding = var XXXbinding
for(i=0;i<10;i++)
{
binding.invoke();
}
```
* **basicHttpBinding:**
service被调用的时候会创建一个新的实例;
所以打印出的num永远都是0;

* **wsHttpBinding:**
应为这种方式有session,所以在调用的时候,num持续增加;

但是,将代码修改如下时:
```C#
for(i=0;i<10;i++)
{
var binding = var XXXbinding
binding.invoke();
}
```
num依然为0, 因为每次被实例化新的session,其中的id必然也不一样;

#### 自定义行为
* InstanceContextMode 实例模式
* ConcurrencyMode 线程模式

1. **InstanceContextMode.Single +ConcurrencyMode.Single**
 好处: 线程安全
 坏处:性能低

2. **InstanceContextMode.Single +ConcurrencyMode.Multiple**
好处:可并发
坏处:需要控制线程安全

3. **InstanceContextMode.PerSession +ConcurrencyMode.Single**
默认的方式

**注意:** 如果binding没有session的情况下,PerSession会失效从而使用PerCall