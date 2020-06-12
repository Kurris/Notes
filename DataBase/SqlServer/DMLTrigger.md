# DML trigger
>存在sys.objects 目录视图,可用object_id()
>在触发器执行的时候,内存中会产生俩张表
>**inserted** ->insert 或者 update 操作
>**deleted** ->delete 或者 update 操作

* 触发器有2种类型 ,3种用法
	1. `for/after`: 这俩种用法都一样,是在`insert`,`update`,`delete`语句之后执行,受`check`影响
	例如: 2个有级联的表,如何删除了第一个表的数据,然后想用`for/after`触发器去删除另外一个表的数据时!此时会受到约束影响导致报错!所以约束check是比`for/after`触发器优先!
  
	2. `before` 在之前(同上,不同触发时间)


	3. `inteadof` :这种触发器的方式是取代insert,update,delete在表上的操作,从而把操作放到该触发器上执行,不受约束影响,优先级搞,在该触发器上就可以同时执行删除这俩个表的关联数据!

#### 语法:
* 创建一个触发器
```
if object_id('trigger_name') is not null
drop trigger trigger_name
beign
    create trigger trigger_name         
    on {table_name | view_name}           
    {for | After | Instead of }    [ insert, update,delete ]          
    as           
      begin
       sql_statement 
      end
end
```

* 启用一个触发器
```SQL
enable trigger trigger_name on table
```
* 禁止一个触发器
```SQL
disable trigger trigger_name on table
```