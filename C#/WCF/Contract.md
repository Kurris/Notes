### C# WCF框架---契约调用(同步/异步) Contract
>契约的调用方式,也就是client和service之间的调用方式

* 同步方式: 阻塞的方法 [ 默认]
* 异步的方法：
    1. Task.Factory.StartNew()
    2. BeginXXX/EndXXX
    3. XXXAsync/事件Complete