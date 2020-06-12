### C# 多线程 Thread
* **概念**:
 程序本身就是一个进程,进程中可以包括多个线程

* 命名空间System.Threading

#### 一. **创建一个线程**
1. 无参数方法
 ```
 Thread thread=new Thread(new ThreadStart(方法名))
 ```
 2. 有参数方法
 ```
 Thread thread = new Thread(new ParameterizedThreadStart(方法名))
 ```

---
  >线程分为前台线程和后台线程,程序关闭时,前台线程没有执行完成,那么整个程序实际上还是后台中; 
  >所以需要设置线程为后台线程执行
  >```
  >thread.IsBackground=true
  >```
  >此时,关闭应用程序后,线程自动停止
3. 线程准备 并非启动,而是告诉cpu该线程已经准备就绪
```
thread.Start();
```
#### 二.终止线程

调用线程方法Abort(),该方法调用会终止线程,并且抛出异常


#### 总结
Thread可以的方式并不多,例如取返回值,开多个线程处理代码比较繁琐;

 

 