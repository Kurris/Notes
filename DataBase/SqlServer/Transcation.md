# 事务Transaction
* **四原则**
	* 原子性 工作单元,要么全执行,要么都不执行
	* 一致性 事务内所有都为正确
	* 隔离性 多个事务同事执行不受其他事务影响
	* 持久性 回滚或者提交后,数据永久

* **例子**
```SQL
begin tran
	begin try
		insert into lives (Eat,Play,Numb) values ('猪肉','足球',1)
		insert into lives (Eat,Play,Numb) values ('肉','球','a')
		insert into lives (Eat,Play,Numb) values ('狗肉','篮球',2)
	end try

	begin catch

		select Error_number() as ErrorNumber,--错误代码
				Error_severity() as ErrorSeverity,--错误严重级别，级别小于10 try catch 捕获不到
				Error_state() as ErrorState,--错误状态码
				Error_Procedure() as ErrorProcedure,--出现错误的存储过程或触发器的名称。
				Error_line() as ErrorLine,--发生错误的行号
				Error_message() as ErrorMessage --错误的具体信息
          
		if	(	@@trancount>0	)--全局变量@@trancount，事务开启此值+1，他用来判断是有开启事务
		rollback trans ---由于出错，这里回滚到开始，第一条语句也没有插入成功。
	end catch

if(@@trancount>0)
commit tran--如果成功Lives表中，将会有3条数据。

--表本身为空表，ID ,Numb为int 类型，其它为nvarchar类型

select * from lives

```