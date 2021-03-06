[toc]
# DotNet Core 3.1 知识点

## log4net

* Nutget下载:`Microsoft.Extensions.Logging.Log4Net.AspNetCore`

* 在项目根目录中创建`log4net.config`文件,添加以下`xml`
	```xml
	<log4net>
    <appender name="DebugAppender" type="log4net.Appender.DebugAppender" >
      <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%date [%thread] %-5level %logger - %message%newline" />
      </layout>
    </appender>
    <!--全局异常日志-->
    <appender name="RollingFile" type="log4net.Appender.RollingFileAppender">
      <file value="logs/全局异常/" />
      <appendToFile value="true" />
      <rollingStyle value="Composite" />
      <staticLogFileName value="false" />
      <datePattern value="yyyyMMdd'.log'" />
      <maxSizeRollBackups value="10" />
      <maximumFileSize value="2MB" />
      <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%newline %n记录时间：%date{yyyy-MM-dd HH:mm:ss fff} %n线程ID:[%thread] %n日志级别：%-5level %n跟踪描述：%message%newline %n"/>
      </layout>
      <filter type="log4net.Filter.LevelRangeFilter">
        <!--日志过滤器：日志最大级别和最小级别。我现在的是全局错误记录所以限定级别为Error-->
        <levelMin value="Error" />
        <levelMax value="Error" />
      </filter>
    </appender>
    <!--监控日志-->
    <appender name="MonitorAppender" type="log4net.Appender.RollingFileAppender">
      <param name="File" value="logs/请求监控/" />
      <param name="AppendToFile" value="true" />
      <param name="MaxFileSize" value="10240" />
      <param name="MaxSizeRollBackups" value="100" />
      <param name="StaticLogFileName" value="false" />
      <param name="DatePattern" value="yyyyMMdd'.log'" />
      <param name="RollingStyle" value="Date" />
      <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%newline %n记录时间：%date{yyyy-MM-dd HH:mm:ss fff} %n线程ID:[%thread] %n日志级别：%-5level %n跟踪描述：%message%newline %n"/>
      </layout>
      <filter type="log4net.Filter.LevelRangeFilter">
        <levelMin value="Warn" />
        <levelMax value="Warn" />
      </filter>
    </appender>
    <!--程序日志-->
    <appender name="AppLogs" type="log4net.Appender.RollingFileAppender">
      <param name="File" value="logs/应用日志/" />
      <param name="AppendToFile" value="true" />
      <param name="MaxFileSize" value="10240" />
      <param name="MaxSizeRollBackups" value="100" />
      <param name="StaticLogFileName" value="false" />
      <param name="DatePattern" value="yyyyMMdd'.log'" />
      <param name="RollingStyle" value="Date" />
      <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%newline %n记录时间：%date{yyyy-MM-dd HH:mm:ss fff} %n线程ID:[%thread] %n日志级别：%-5level %n跟踪描述：%message%newline %n"/>
      </layout>
      <filter type="log4net.Filter.LevelRangeFilter">
        <levelMin value="DEBUG" />
        <levelMax value="Info" />
      </filter>
    </appender>
    <root>
      <level value="All"/>
      <appender-ref ref="MonitorAppender" />
      <!--<level value="Debug" />-->
      <appender-ref ref="RollingFile"  />
      <appender-ref ref="AppLogs"  />
      <!--<appender-ref ref="DebugAppender" />-->
    </root>
    <!--请求日志记录-->
    <logger name="LLZ.Project.WebApi.Middleware.RequestLogMiddleware">
      <!--这个name的命名的意思是：是我中间件cs文件的命名空间-->
      <level value="Warn" />
    </logger>
    <!--全局错误记录-->
    <logger name="LLZ.Project.WebApi.Filters.SysExceptionFilter">
      <level value="Error" />
    </logger>
    <!--调试，以及生产环境日志-->
    <logger name="LLZ.Project.WebApi.Helper.LogHelper">
      <level value="DEBUG" />
      <level value="INFO" />
    </logger>
  </log4net>
	
	```

* 在程序入口`Program`中,替换原生的`logger`
	```C#
	 public static IHostBuilder CreateHostBuilder(string[] args) =>
     Host.CreateDefaultBuilder(args)
     .ConfigureLogging((context, logger) =>
     {
         logger.AddFilter("System", LogLevel.Warning);
         logger.AddFilter("Microsoft", LogLevel.Warning);
         logger.AddLog4Net();
     })
     .ConfigureWebHostDefaults(webBuilder =>
     {
     webBuilder.UseStartup<Startup>();
     });
	```

-----------------------------------------------------------------------------
## Swagger
* 引用 `Swashbuckle.AspNetCore`
	* 添加服务
	```C#
	services.AddSwaggerGen(setupAction =>
    {
        setupAction.SwaggerDoc("V1", new Microsoft.OpenApi.Models.OpenApiInfo()
        {
            Version = "Ver 1",
            Description = "Ligy WebApi",
            Title = "Ligy WebApi",
        });
    });
	```
	* 使用
	 ```C#
     app.UseSwagger();
     app.UseSwaggerUI(option =>
     {
     option.SwaggerEndpoint("/swagger/V1/swagger.json", "Ligy.Project.WebApi");
     });
	 ```
	
-----------------------------------------------------------------------------
## Cors
* 引用`Microsoft.AspNetCore.Cors`
	* 添加服务
	```C#
	 services.AddCors(option =>
	{
        option.AddPolicy("AllowCors", builder =>
         {
         builder.AllowAnyOrigin().AllowAnyMethod();
         });
	});
	```

	* 使用
	```C#
	app.UseRouting();
    // 跨域 必须在UseRouting之后,UseAuthorization之前
    app.UseCors("AllowCors");
    app.UseAuthorization();
	```
-----------------------------------------------------------------------------
## EFCore

### 初步配置实体模型/DbContext/依赖

- 启动程序安装`Microsoft.EntityFrameworkCore.Design`

- 安装`Microsoft.EntityFrameworkCore.Tool`用于`Migration`

- 安装`Microsoft.EntityFrameworkCore.SqlServer`/`Pomelo.EntityFrameworkCore.MySql`用于使用扩展数据库
- 使用方法
  - 创建`MyDbContext` 继承`DbContext`

  - 属性`DbSet<T>`用于暴露当前实体对象,或者暴露实体中的导航属性,再或者在`OnModuleCreating`中使用`Entity<T>()`

  - 重写方法`OnConfiguring`用于配置`DbContext`相关

  - 重写方法`OnModelCreating`用于实体生成时,给定约束或者数据

    ```C#
    public class MyDbContext : DbContext
    {
        public MyDbContext(){}

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
          optionsBuilder.UseMySql("data source=localhost;database=LigyApi; uid=root;pwd=Sa123456!;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
          {
              base.OnModelCreating(modelBuilder);
     	  }

        public DbSet<Blog> Blogs { get; set; }
        public DbSet<Post> Posts { get; set; }
    }
    ```

  - e.g: 以下这种方式需要在`Startup`中注册`DbContext`服务,好处是配置连接字符串可以通过`appsetting.json`获取
    ```C#
    public MyDbContext(DbContextOptions<MyDbContext>) : base(options){ }
         
    ```
    
    ```C#
    //注册服务
    services.AddDbContext<MyDbContext>(op =>
    {
            op.UseLoggerFactory(LoggerFactory.Create(builder =>
            {
            builder.AddFilter((string category, LogLevel level) =>
            category == DbLoggerCategory.Database.Command.Name
            && level == LogLevel.Information ).AddConsole();
            })).UseMySql(Configuration.GetConnectionString("MySqlDB"));
 });
    ```
    
   - 最后使用依赖注入即可拿到`MyDbContext`对象实例

### 深入配置
- 创建一个类继承`IEntityTypeConfiguration<T>`接口,实现`Configure`方法,并在`OnModelCreating`中按顺序调用
	```C#
	new BlogConfig().Configure(modelBuilder.Entity<Blog>());
	```
- 当配置执行顺序无关时,使用以下寻找继承该接口的类型
	```C#
	modelBuilder.ApplyConfigurationsFromAssembly(typeof(IEntityTypeConfiguration<T>).Assembly);
	```
	
### 注解(Attribute)
* 非空 `[Required]` 
* 不映射 `[NotMapped]`
* 表名称 `[Table]`
* 列名称 `[Column(name,[Order]=int,[TypeName]=string)]`
* 主键 `[Key]`
* 自动参数默认值 `[DatabaseGenerated]`
* 设置当前类某个属性被识别为外键,使用在当前类导航类型属性上 `[ForeignKey(属性名称)]`
* 配置主表的属性 `[InverseProperty(主表属性)]`
### 模型

* 主键 
	```C#
    modelBuilder.Entity<Car>()
        .HasKey(c => c.LicensePlate);
	```
	
* 主键名称
	```C#
	.HasName("PrimaryKey_BlogId");
	```
	
* 复合主键(**不能**使用`[Key]`注解标注俩个属性)
	```C#
	modelBuilder.Entity<Car>()
        .HasKey(c => new { c.State, c.LicensePlate });
	```
	
* 索引
	```C#
	 builder.HasIndex(x => x.BlogId);
	```
	
* 复合索引
	```C#
	.HasIndex(p => new { p.FirstName, p.LastName });
	```
	
* 非空
	```C#
	 builder.Property(x => x.Url)
                 .IsRequired();
	```
	
* 不映射
	```C#
	builder.Ignore(x => x.BlogId);
    builder.Ignore("BlogId");
	
	```
	
* 默认值
	```C#
	.HasDefaultValue<T>(T t)
	.HasDefaultValueSql<T>("表达式")
	```
	
* 计算列
	```C#
	.HasComputedColumnSql("表达式",stored);
	```
	
* 影子属性(实体中没有数据库中的字段)
	设定
	
	```C#
	builder.Property<string>("shadowprop");
	```
	访问
	```c#
	db.Entry(blog).Property<string>("shadowprop").CurrentValue = "value";
	db.Blogs.OrderBy(x => EF.Property<string>(x, "shadowprop"));
	```
	
	
	
* 模型创建时,实体属性类型转换,转换器命名空间`Microsoft.EntityFrameworkCore.Storage.ValueConversion`
	```C#
		.HasConversion(ValueConverter);
	```
 也可以直接指定类型,EF会自动寻找合适的转换器
     ```C#
     .HasConversion<string>();
  
	   ```
	
* 关系

  - 一对多

     - 主从都有导航属性

    ```C#
    modelBuilder.Entity<Post>()//从表
                .HasOne(p => p.Blog)//对应一个主表
                .WithMany(b => b.Posts);//并且主表有多个从表
    ```

    - 一对多,主有导航属性,从表没有

    ```C#
    modelBuilder.Entity<Blog>()//主表
                .HasMany(b => b.Posts)//主表有多个从表
                .WithOne();//并且从表只对应一个主表了
    ```

    - 一对多,都没有导航属性

    ```C#
    modelBuilder.Entity<Post>()//从表
                .HasOne<Blog>()//从表有一个主表
                .WithMany()//并且主表有多个从表
                .HasForeignKey(p => p.BlogId);//对应的从表外键是XXX
    
    ```
  - 一对一
  	- 确保主从都只有一个导航属性,并且从表指明主表的导航字段
  		```C#
  		modelBuilder.Entity<Blog>()
            .HasOne(b => b.BlogImage)
            .WithOne(i => i.Blog)
  		```
  	- 如果需要指明特别的外键
  	```C#
  	modelBuilder.Entity<Blog>()
            .HasOne(b => b.BlogImage)
            .WithOne(i => i.Blog)
            .HasForeignKey<BlogImage>(b => b.BlogForeignKey);
  	```
  	

  

  - 多对多

    - 主从都需要List<导航属性>,并将建立主从类

      - .net 5之前

        ```C#
        modelBuilder.Entity<PostTag>()
                    .HasKey(t => new { t.PostId, t.TagId });
        
        modelBuilder.Entity<PostTag>()
            .HasOne(pt => pt.Post)
            .WithMany(p => p.PostTags)
            .HasForeignKey(pt => pt.PostId);
        
        modelBuilder.Entity<PostTag>()
            .HasOne(pt => pt.Tag)
            .WithMany(t => t.PostTags)
            .HasForeignKey(pt => pt.TagId);
        ```

      - .net 5后增加方式

        ```C#
        modelBuilder.Entity<Post>()
                    .HasMany(p => p.Tags)
                    .WithMany(p => p.Posts)
                    .UsingEntity<PostTag>(
                        j => j
                            .HasOne(pt => pt.Tag)
                            .WithMany(t => t.PostTags)
                            .HasForeignKey(pt => pt.TagId),
                        j => j
                            .HasOne(pt => pt.Post)
                            .WithMany(p => p.PostTags)
                            .HasForeignKey(pt => pt.PostId),
                        j =>
                        {
                            j.Property(pt => pt.PublicationDate).HasDefaultValueSql("CURRENT_TIMESTAMP");
                            j.HasKey(t => new { t.PostId, t.TagId });
                        });
        ```

        

  - 级联删除

    ```C#
    .OnDelete(DeleteBehavior.Cascade)
    ```

    
- 索引

  - 简单使用

    ```C#
    modelBuilder.Entity<Blog>()
            .HasIndex(b => b.Url);
    ```

  - 复合索引

    ```C#
    modelBuilder.Entity<Person>()
            .HasIndex(p => new { p.FirstName, p.LastName });
    ```

  - 索引唯一性

    ```C#
    modelBuilder.Entity<Blog>()
            .HasIndex(b => b.Url)
            .IsUnique();
    ```

  - 设定索引名称

    ```C#
    modelBuilder.Entity<Blog>()
            .HasIndex(b => b.Url)
            .HasDatabaseName("Index_Url");
    ```

  - 筛选索引

    > 不能对视图创建筛选索引
    >
    > 筛选的索引不支持 `LIKE` 运算符

     ```C#
    .HasFilter("[Url] IS NOT NULL");//使用表达式
     ```

- 继承

  - TPH

    > *每个层次结构一个表* (TPH) 模式映射继承
    >
    > 建立一个表,自动创建基类和子类的字段,并且有一列Discriminator保存类型
    >
    > 查询基类可以将所有子类查询出来
    >
    > 查询子类,只会有子类数据
    >
    > 可以指定鉴别器的列,使用hasDiscriminator(x=>x.XXX)

    - 合并列

      > 如果俩个同级子类都存在相同的属性名称,那么在表创建的时候就会产生单独列"A"和"表名_A"
      >
      > 使用.hasColumnName("XXX")指明同一个名称,这样就可以使用同一个字段

  - TPC

    > 每一种类型一个表
    >
    > 使用ToTable(表名称)指明
    >
    > 或者注解标记`[Table()]`


- 转换器

  - HasConversion

    ```C#
    modelBuilder.Entity<Blog>()
                    .Property(x => x.BlogType)
                    .HasConversion(
                    v => v.ToString(),//转换成string
                    v => (BlogType)Enum.Parse(typeof(BlogType), v));//数据库加载数据转换
    ```

  - ValueConverter

    ```C#
     var vt = new ValueConverter<BlogType, string>(
                    v => v.ToString(),
                    v => (BlogType)Enum.Parse(typeof(BlogType), v)
                    );
    ```

  - 自动转换

    ```C#
     modelBuilder.Entity<Blog>()
                    .Property(x => x.BlogType)
                    .HasConversion<string>();
    ```

- 表拆分

  > 一对一的关系中,将外键表和主表生成在同一个表`ToTable()`中,可以合并列,用法和普通关系没有差别

- 从属类型


  - 一对一


```C#
	 .hasOwn   withOwner
```

  - 一对多

    ```C#
    modelBuilder.Entity<Distributor>().OwnsMany(p => p.ShippingCenters, a =>
    {
        a.WithOwner().HasForeignKey("OwnerId");
        a.Property<int>("Id");
        a.HasKey("Id");
    });
    ```

  - 表拆分

    ```C#
    modelBuilder.Entity<Order>().OwnsOne(
        o => o.ShippingAddress,
        sa =>
        {
            sa.Property(p => p.Street).HasColumnName("ShipsToStreet");
            sa.Property(p => p.City).HasColumnName("ShipsToCity");
        });
    ```

- 无键实体类型

  > 不会被更改跟踪,可用于默认数据----类型数据


  - 设置`[KeyLess]` 或者 `HasNoKey()`

  - 如果一个实体中,存在一个以上的相同实体属性的情况,那么实体属性中,不能有当前实体的`<Type>Id`,

    并且需要在modelBuilder中配置相关映射关系

    ```C#
    public class Blog
        {
            public int BlogId { get; set; }
    
            public string Url { get; set; }
    
            public BlogType BlogType { get; set; }
    
            public Profile ProfileA { get; set; }
            public Profile ProfileB { get; set; }
    
            public DateTime EditTime { get; set; }
        }
    
    public class Profile
        {
            public int ProfileId { get; set; }
            public string Name { get; set; }
            public Blog Blog { get; set; }
        }
    
     modelBuilder.Entity<Blog>()
                    .HasOne(x => x.ProfileA)
                    .WithOne()
                    .HasForeignKey<Blog>("PAId");
    
                modelBuilder.Entity<Blog>()
                    .HasOne(x => x.ProfileB)
                    .WithOne()
                    .HasForeignKey<Blog>("PBId");
    ```

    

 

### 数据迁移`Migration`

- 在`Visual Studio` 中的**程序包管理器控制台**中,选择当前`DbContext`所在的工程
	
	- 添加迁移,生成首次迁移文件
	
	```Shell
		add-migration firstmigration -verbose
	```
	- 此处添加`-OutputDir Your\Directory` 用于导出迁移文件
	- 添加 `-Project 项目名称`指定迁移的项目
	
- 更新到实际的数据库
  ```Shell
  update-database -verbose
  ```

   - 假设将一个字段名称修改了,要注意迁移的警告,可能需要手动添加`newName`,否则原列数据会被清除

   - 使用SQL

     ```C#
     migrationBuilder.Sql(
     @"
         UPDATE Customer
         SET FullName = FirstName + ' ' + LastName;
     ");
     ```

- 获取当前所有迁移

  ```Shell
  Get-Migration
  ```

- 生成脚本

  ```C#
  Script-Migration (from) A (to) B -Idempotent(幂等)
  ```

  

- 删除上一次的迁移

  ```shell
  delete-migaraion -verbose
  ```

  

  

### 数据操作

>`DbContext`并非线程安全
>
>`OnModelCreating`方法的优先级最高
- 检查实体是否设置了主键
	```C#
	var @bool = db.Entry(new Blog()
    {
        Rating = 5,
        Url = "baidu.com"
    }).IsKeySet;
	```

- 添加一行数据,创建一个新的实体并且添加到`db`中的`Blogs(DBSet<T>)`属性中,使用`SaveChanges()`方法对数据进行持久化保存
	```C#
	using (var db = new MyDbContext())
    {
    var blog = new Blog { Url = "http://sample.com" };
    db.Blogs.Add(blog);
    db.SaveChanges();
    }
	```

- 查询数据
  - 查询一行数据
  	>如果查询的数据实体存在于当前上下文中,那么查询的实体就会被上下文中的实体附加上,而不会执行实际的查询(如果标记了AsNoTrackingWithIdentityResolution(),那么上下文实体不会有相同的标识)

  	```C#
  	var blogs1 = db.Blogs.Find(1);
        blogs1.Rating = 5;
    var blogs2 = db.Blogs.Single(x => x.BlogId == 1);
    ```
	
	- 在顶级投影中,`Select`,如果返回的类型在客户端中使用了方法处理类型的属性,返回的实体一样会被跟踪
	
	  - 注意内存泄漏,
	    - 原因:
	      - 顶级投影会被缓存的委托引用,为了再次使用
	      - 投影方法中使用了`EF`没有映射的实例`this`之类
	    - 解决:
	      - 静态方法
	      - 传入局部参数
	
	- 加载数据
	
	  - 预先加载
	    - 使用`Include`或者`ThenInclude()`
      - 在InClude里面支持过滤:`Where`、`OrderBy`、`OrderByDescending`、`ThenBy`、`ThenByDescending`、`Skip` 和 `Take`。
      - 在InClude里面只能执行一个过滤
      - 可以对同一个导航属性使用过滤
    - 注意在当前上下文中,如果已查询某数据,但是后续再查询该数据时,当前查询结果会引用第一次的数据....导致第二次条件失败
  
  - 显示加载
  
    - 实体:`db.Entry(blog).Reference(b => b.ProfileA).Load();`
  
    - 实体集合:` db.Entry(blog).Collection(b => b.Posts).Load();`
  
    				使用`Query()`可以在服务器上进行评估
  
  - 延迟加载
  
      - 无代理:
        - `LazyLoadingEnabled=true`
        - 注入ILazyLoader,并且在属性上使用`Load`方法
      - 代理:
        - 引用一个代理包
      - 需要延迟加载的属性标记`virtual`即可
  
  - 查分查询 `AsSplitQuery`  针对笛卡尔积
  
  - 单一查询 ``AsSingleQuery` `
  
    
  
  - **注意**
  
    > 某些序列化框架不允许使用循环引用。 例如，Json.NET 在发现循环引用的情况下，会引发异常。
  
    	解决:
  
      ```C#
      services.AddMvc()
              .AddJsonOptions(
                  options => options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
              );
      ```
    
  - 原生SQL
  
      - `FromSqlRaw` 
          - 查询字段必须和实体一致
          - 不能使用`$`传入参数,防止**SQL注入**,需要使用"string.format"的方法
          - 可以使用`SqlParameter`传入参数
      - `FromSqlInterpolated`可以防止**SQL注入**

-----------------------------------------------------------------------------
## SignalR
>实时通信技术,回落机制
>使用三种底层技术,websocket,server sent event, long polling
>websocket 仅支持现代浏览器,现代服务器
>server sent event连接数问题