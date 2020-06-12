### C# WCF框架---请求/响应, 单工, 双工
* 请求/响应 
 默认的方式

* 单工模式
    方法特性OperationContract标记围IsOneWay=true,并且不能带有返回值

* 双工模式
    1. 方法特性OperationContract标记IsOneWay=true,并且不能带有返回值
    2. 服务特性ServiceContract标记SessionMode=SessionMode.Required,CallbackContract =typeof(回调的接口类型)
    3. 定义回调接口
        * 方法特性OperationContract标记IsOneWay=true,并且不能带有返回值
        

**服务端:**
```c#
public class Duplex : IDuplex
    {
        IResult result;
        public Duplex()
        {
            //从方法的操作上下文中获取到客户端传递过来的IResult这个接口的实现类对象
            result = OperationContext.Current.GetCallbackChannel<IResult>();
        }
        public void Run(string msg)
        {
            //模拟5秒钟以后处理完成
            System.Threading.Thread.Sleep(5000);
            result.Reuslt("处理完成"+msg);
        }
    }
```

**客户端:**

* 定义一个类并且继承回调接口,实现该方法;