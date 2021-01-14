### RabbitMQ---生产者消费者模式(持久化+ack)
* 生产者
```C#
static void Main(string[] args)
        {
   			//定义连接的地址/账号密码/端口 
            var factory = new ConnectionFactory()
            {
                HostName= "localhost",
                UserName = "ligy" ,
                Password = "ligy" ,
                //Port=15672,
            };
            
			//创建连接
            using( var connection = factory.CreateConnection() )
            {	//创建信道
                using( var channel = connection.CreateModel() )
                {
					//创建一个名称为hello的消息队列,不允许创建相同队列名,不同参数                
                    channel.QueueDeclare(
                        queue: "hello" ,//队列名称
                        durable: true , //开启持久化
                        exclusive: false , 
                        autoDelete: false, 
                        arguments: null);

                    //持久化
                    var prop = channel.CreateBasicProperties();
                    prop.Persistent = true;

                    while( true )
                    {
                        string message = Console.ReadLine(); //传递的消息内容
                        var body = Encoding.UTF8.GetBytes(message);
                        //开始传递
                        channel.BasicPublish(exchange: "", 
                                                routingKey: "hello" ,
                                                basicProperties: prop ,
                                                body: body); 
                        Console.WriteLine("已发送： {0}" , message);
                    }
                }
            }
        }
```

* 消费者
```C#
//创建登录
var factory = new ConnectionFactory()
            {
                HostName = "localhost" ,
                UserName = "ligy" ,
                Password = "ligy"
            };
			//建立连接
            using( var conn =factory.CreateConnection() )
            {	//建立空信道
                using( var channl = conn.CreateModel() )
                {
                	//定义信道的队列,必须保持与生产者一致
                    channl.QueueDeclare(queue: "hello" ,
                                        durable: true ,
                                        exclusive: false ,
                                        autoDelete: false ,
                                        arguments: null);
                    //接收的类型                    
                    channl.BasicQos(prefetchSize: 0 ,
                        prefetchCount: 1 ,//为1则消费者尚未主动ack,不再接收信息,否则以轮询的方式
                        global: false
                        );
                    //创建消费者
                    var consumer = new EventingBasicConsumer(channl);
					//接收后触发事件
                    consumer.Received += (s , e) =>
                    {
                      var queueInfo =  channl.QueueDeclarePassive("hello");

                        Console.WriteLine("当前剩下:{0}", queueInfo.MessageCount);
                        var msg = Encoding.UTF8.GetString(e.Body);
                        System.Threading.Thread.Sleep(8000);
                        Console.WriteLine("当前时间:{0}  接收到:{1}",DateTime.Now,msg);
                        //手工确认信息已经处理
                        channl.BasicAck(e.DeliveryTag , false);
                    };
	    			//开始接收
                    channl.BasicConsume(queue: "hello" ,
                        autoAck: false ,
                        consumer: consumer);
        
                    Console.ReadKey();
                }
            }
        }  
```