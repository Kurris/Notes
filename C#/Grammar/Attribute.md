### C# 特性Attribute
* 自定义特性需要继承 **Attribute**
* 特性在编程中并没有什么作用,只是作为元数据,在程序运行时,动态反射,查找特性,并且做相应的功能,常用于AOP思想
* 自定义特性可以决定使用的地方,如类,字段,属性
   需要使用特性[**AttributeUsage**(AttriubuteTargets.XXX, (这个是是否可以重复使用)AllowMultiple=true )]    
   
---
[Customer("参数",属性名=xxx)]