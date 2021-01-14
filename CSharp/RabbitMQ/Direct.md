### RabbitMQ---路由模式(direct)
* 生产者
```C#
var factory = new ConnectionFactory()
            {
                HostName= "localhost",
                UserName = "ligy" ,
                Password = "ligy" ,
                //Port=15672,
            };
        using( var connection = factory.CreateConnection() )
        {
            //3. 创建信道
            using( var channel = connection.CreateModel() )
            {
                //4. 声明信息交换机
                channel.ExchangeDeclare(exchange: "directDemo" ,
                                        type: "direct");

                while( true )
                {
                    //5. 构建字节数据包
                    var message = Console.ReadLine();
                    var body = Encoding.UTF8.GetBytes(message);

                    //6. 发布到指定exchange，fanout类型的会忽视routingKey的值，所以无需填写
                    channel.BasicPublish(exchange: "directDemo" ,
                                         routingKey: "指定的Key" ,
                                         basicProperties: null ,
                                         body: body);

                    Console.WriteLine(" [x] Sent {0}" , message);
                }
            }
        }
```

* 消费者
```C#
var factory = new ConnectionFactory()
            {
                HostName = "localhost" ,
                UserName = "ligy" ,
                Password = "ligy"
            };

            using( var connection = factory.CreateConnection() )
            {
                //3. 创建信道
                using( var channel = connection.CreateModel() )
                {
                    //4. 声明信息交换机
                    channel.ExchangeDeclare(exchange: "directDemo" ,
                                            type: "fanout");//direct
                    //生成随机队列名称
                    var queueName = channel.QueueDeclare().QueueName;
                    //绑定队列到指定fanout类型exchange
                    channel.QueueBind(queue: queueName ,
                                      exchange: "directDemo" ,
                                      routingKey: "指定的Key");
    
                    //5. 构造消费者实例
                    var consumer = new EventingBasicConsumer(channel);
    
                    //6. 绑定消息接收后的事件委托
                    consumer.Received += (model , ea) =>
                    {
                        var message = Encoding.UTF8.GetString(ea.Body);
                        Console.WriteLine(" [x] Received {0}" , message);
                    };
    
                    channel.BasicConsume(queue: queueName ,
                                         autoAck: true ,
                                         consumer: consumer);
    
                    Console.WriteLine(" Press [enter] to exit.");
                    Console.ReadLine();
    
                }
            }
```