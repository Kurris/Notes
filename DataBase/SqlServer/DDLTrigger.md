### Sql 触发器 DDL Trigger
>数据库级别DDL触发器存在sys.triggers
>服务器级别DDL触发器存在sys.server_triggers

* 创建一个数据库级别DDL
```SQL
create trigger  trigger_name
on database
for/after drop_table,alter_table
as
statement
```

* 创建一个服务器级别DDL
 ```SQL
create trigger  trigger_name
on all server
for/after 
create_database
as
statement
 ```