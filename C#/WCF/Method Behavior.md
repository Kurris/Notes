### C# WCF框架---行为 Method Behavior
* **EndPoint级别 拦截**
1. **分别自定义类,继承IEndPointBehavior上的IDispatchMessageInspector接口可以实现请求调用前和调用后的一些控制.拦截等**
* 实现<u>IEndPointBehavior</u>接口中的方法
```C#
  public void ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher 
endpointDispatcher)
        {
            endpointDispatcher.DispatchRuntime.MessageInspectors.Add(new 
MyDispatchInSpector());//自定义Inspector类
        }
```
* 实现<u>IDispatchMessageInspector</u>接口的方法,并且把该类给到IEndPointBehavior接口的方法中
  

2. **把该自定义EndPoint放在servicehost的endpoint[0]中,因为第一个endpoint是我们定义的服务,第二个是mex元数据**
`serviceHost.Description.Endpoints[0].EndpointBehaviors.Add()`
#### **总结**
WCF调用方法前后会执行以下俩个方法做消息处理

* AfterReceiveRequest 执行前
    1. 统计访问量
    2. 获取系统参数,如:
        * request.Header.GetHeader<string>("ip",string.empty);
        * token...datetime...
* BeforeSendReply 执行后

---

* **OperationBehavior级别 拦截**
1. 自定义MyParaInspector类,继承`IParameterInspector`接口
    * AfterCall
    * BeforeCall: 可以在方法调用之前做一些参数检查处理
    * 
2. 自定义MyOperationBehaviorAttribute类,继承Attribute特性还有`IOperationBehavior`接口,
```C#
 public void ApplyDispatchBehavior(OperationDescription operationDescription, 
DispatchOperation dispatchOperation)
        {

            dispatchOperation.ParameterInspectors.Add(new MyParaInspector(Length));

        }
```
实现接口方法,把参数消息分发器放入该特性! 

**实现:**
* 可以在方法上添加该特性
* 在`serviceHost.Description.Endpoints[0].Contract.ContractBehaviors.Add()`添加自定义