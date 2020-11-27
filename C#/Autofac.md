[toc]

# Autofac

### 初步使用

* 在`Progam`的`CreateHostBuilder`方法中替换ServiceCollection容器

	```C#
	UseServiceProviderFactory(new AutofacServiceProviderFactory())
	```
	
	```C#
  public static IHostBuilder CreateHostBuilder(string[] args) =>
    Host.CreateDefaultBuilder(args)
        .UseServiceProviderFactory(new AutofacServiceProviderFactory())
        .ConfigureWebHostDefaults(webBuilder =>
        {
            webBuilder.UseStartup<Startup>();
	      });
	```
* 然后在`Startup`中增加一个方法

	```c#
    public void ConfigureContainer(ContainerBuilder containerBuilder)
    {
        containerBuilder.RegisterType<CNClock>().As<IClock>();
	  }
	```
* 最后在类中的构造函数使用,就能够被注入
	```c#
	public EFTestsController(MyDbContext context, IClock clock, ILogger<EFTestsController> logger)
        {
            this.clock = clock;
            this._context = context;
            this._logger = logger;
        }
	```

```C#
//瞬时生命周期：注册之后，每次获取到的服务实例都不一样（默认的注册方式）
containerBuilder.RegisterType<CNClock>().As<IClock>().InstancePerDependency();

//单例生命周期：整个容器中获取的服务实例都是同一个
containerBuilder.RegisterType<CNClock>().As<IClock>().SingleInstance();

//作用域生命周期：在相同作用域下获取到的服务实例是相同的(一次请求中)
containerBuilder.RegisterType<CNClock>().As<IClock>().InstancePerLifetimeScope();

//作用域生命周期：可以指定到某一个作用域，然后在相同作用域下共享服务实例
containerBuilder.RegisterType<CNClock>().As<IClock>().InstancePerMatchingLifetimeScope("My");

//http请求上下文的生命周期：在一次Http请求上下文中,共享一个组件实例。仅适用于asp.net mvc开发。
containerBuilder.RegisterType<CNClock>().As<IClock>().InstancePerRequest();

//拥有隐式关系类型的创建新的嵌套生命周期的作用域，在一个生命周期域中所拥有的实例创建的生命周期中，
//每一个依赖组件或调用Resolve()方法创建一个单一的共享的实例，并且子生命周期域共享父生命周期域中的实例
containerBuilder.RegisterType<CNClock>().InstancePerOwned<IClock>();
```

### 