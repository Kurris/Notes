### RabbitMQ---安装

* 安装ErLang环境

   * 将ErLang安装目录下的 <u>bin路径</u> 配置到系统环境变量的`PATH`下

   * 在CMD中输入erl ;出现版本信息即可

* 使用RabbitMQ无安装版本
	
	* 将MQ目录下的<u>sbin</u> 配置到系统环境变量的`PATH`下
	
	* 在CMD输入 rabbitmq-plugins.bat enable rabbitmq_managemen 安装WEB可视化
	
	* 如果出现失败:
	
	  * 解决方法： 
	    将 `C:\Users\Administrator\.erlang.cookie` 同步至`C:\Windows\System32\config\systemprofile\.erlang.cookie `
	
	    同时删除：`C:\Users\Administrator\AppData\Roaming\RabbitMQ`目录
	  
	* 输入 rabbitmq-server.bat 启动rabbitmq 服务 `需要一直挂起cmd`
	
	* 或者输入 rabbitmq-server.bat -detached  启动rabbitmq 服务 `不需要一直挂起cmd`
	
* 查看用户 `rabbitmqctl list_users`

* 添加用户 `rabbitmqctl add_user username pwd`

* 分配用户组 `rabbitmqctl set_user_tags username groupname`

* 修改密码 `rabbitmqctl change_password username pwd`

* 删除用户 `rabbitmqctl delete_user username`

* web界面插件 `rabbitmq-plugins enable rabbitmq_management`





# 介绍



* 简单模式：一个生产者，一个消费者

  work模式：一个生产者，多个消费者，每个消费者获取到的消息唯一。

  订阅模式：一个生产者发送的消息会被多个消费者获取。

  路由模式：发送消息到交换机并且要指定路由key ，消费者将队列绑定到交换机时需要指定路由key

  topic模式：将路由键和某模式进行匹配，此时队列需要绑定在一个模式上，“#”匹配一个词或多个词，“*”只匹配一个词。
  