### 自增ID


* **SELECT SCOPE_IDENTITY()**
返回插入到同一作用域中的 IDENTITY 列内的最后一个 IDENTITY 值。
* **SELECT @@IDENTITY** 
返回插入到当前会话中任何作用域内的最后一个 IDENTITY 列值
* **SELECT IDENT_CURRENT('TbName')**
不受作用域和会话的限制，而受限于指定的表。IDENT_CURRENT 返回为任何会话和作用域中的特定表所生成的值。

---
**一个作用域就是一个模块——存储过程、触发器、函数或批处理。**

* 因此，如果两个语句处于同一个存储过程、函数或批处理中，则它们位于相同的作用域中。对于马上使用的刚才插入的新记录ID用SCOPE_IDENTITY()是最合适的;


* 对于想要得到一系列的操作中最后得到的那个自增的ID最好用@@IDENTITY


* 对于想要得到一个表中的最后一个插入操作所产生的ID的最好用IDENT_CURRENT('TBName')