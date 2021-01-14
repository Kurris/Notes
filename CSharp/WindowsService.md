### C# Windows服务
>概述: C#能够开发基于windows平台的服务应用,可以用于检测程序的运行状态,还能做一些自动化的操作,例如自动获取更新,自动处理数据库的数据等等

* **新建windows服务模板**
    * 在其设计界面上右键添加安装程序
        * 修改<u>serviceInstaller1</u>的`decription`为该服务的描述
        * 修改<u>serviceInstaller1</u>的`ServiceName`为该服务的名称
        * 修改<u>serviceInstaller1</u>的`StartType`为该服务的启动类型
        * 修改<u>serviceProcessInstaller1</u>的`Account`为LocalSystem--最高级别
    * 在Program上的OnStart上写上服务启动后触发的功能
    * 在Program上的OnStop上写上服务停止后触发的功能

**最后**编译代码,生成exe文件

---

* **建立工具执行对windows服务的操作**
>首先引用以下命名空间:
><u>using System.ServiceProcess;</u>
><u>using System.Configuration.Install;</u>

* 判断服务是否存在
```C#
private static bool IsExists(string sServiceName)
{
ServiceController[] serviceControllers = ServiceController.GetServices();
return serviceControllers.Any(s => string.Compare(s.ServiceName, 
sServiceName) == 0);
}
```
* 安装服务
``` C#
private static void SetupService()
        {
                if (IsExists(_mServiceName))
                {
                    Console.WriteLine("service by "+_mServiceName+ " is already 
exists,do not install again\r\n");
                    return;
                }
                using (AssemblyInstaller  assemblyInstaller  =new 
AssemblyInstaller())
                {
                    assemblyInstaller.UseNewContext = true;
                    assemblyInstaller.Path = _msPath;//生成的服务exe文件地址
                    IDictionary savedstate = new Hashtable();
                    assemblyInstaller.Install(savedstate);
                    assemblyInstaller.Commit(savedstate);
                    Console.WriteLine("服务安装完成\r\n");
                }
            }
        }
```
* 卸载服务
```C#
private static void RemoveService()
        {
                if (!IsExists(_mServiceName))
                {
                    Console.WriteLine("service by " + _mServiceName + " is not 
exists,can not remove\r\n");
                    return;
                }
                using (AssemblyInstaller assemblyInstaller = new 
AssemblyInstaller())
                {
                    assemblyInstaller.UseNewContext = true;
                    assemblyInstaller.Path = _msPath;
                    assemblyInstaller.Uninstall(null);
                    Console.WriteLine("服务卸载完成\r\n");
                }
            }
        }
```
* 开启服务
```C#
private static void StartService()
        {
                if (!IsExists(_mServiceName))
                {
                    Console.WriteLine("service by " + _mServiceName + " is not 
exists,can not start\r\n");
                    return;
                }
                using (ServiceController controller =new 
ServiceController(_mServiceName))
                {
                    if (controller.Status != ServiceControllerStatus.Running
                        || controller.Status != ServiceControllerStatus.StartPending)
                    {
                        controller.Start();
                        Console.WriteLine("服务启动完成\r\n");
                    }
                    else {
                        Console.WriteLine("服务正在运行中....无需启动\r\n");
                    }
                }
        }
```
* 停止服务
```C#
private static void StopService()
        {   
                if (!IsExists(_mServiceName))
                {
                    Console.WriteLine("service by " + _mServiceName + " is not 
exists,can not stop\r\n");
                   return;
                }
                using (ServiceController controller =new 
ServiceController(_mServiceName))
                {
                    if (controller.Status != ServiceControllerStatus.Stopped
                        || controller.Status != ServiceControllerStatus.StopPending)
                    {
                        controller.Stop();
                        Console.WriteLine("服务停止完成\r\n");
                    }
                    else {
                        Console.WriteLine("服务已经停止...无需再次停止\r\n");
                    }
                }
            }
        }
```