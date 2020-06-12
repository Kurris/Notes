### C# 数据类型
* 显示转换就是"大的类型"---->"小的类型";可以理解为大的东西放进一个小的容器,属于强制转换类型,丢失数据

* 隐式转换就是"小的类型"---->"大的类型";可以理解为小的东西放进一个大的容器,这是安全的,不会丢弃数据

---
强转: 
```
double d = 3.6       
int i;     
i= (int)d;       
输出 i=3; 
```
**丢失0.6数据!!!**

<u>使用Conver.ToInt 强转,如果value为俩个数之间,则取这个数的偶数位</u>
例如:        4.5->4;  3.5->4;   
但是如果是 4.4->4;  4.6->5;

* **常用变量类型**: 整型: ` int`,`char`,`byte`
                        浮点型:`float`,`double`
                        布尔类型: `true`,`flase`
                        十进制:`decimal`
                        空值: `null`



1. **对于参数为`null`的时候：**
 `Convert.ToDouble`，返回 0.0；
 `Double.Parse` 抛出异常。
2. ** 对于参数为string.Empty/""的时候:**
 `Convert.ToDouble`抛出异常；
 `Double.Parse` 抛出异常。
3. **其它区别：**
 'Convert.ToDouble'可以转换的类型较多；
 'Double.Parse' 只能转换数字类型的字符串。
' Double.TryParse' 与 'Double.Parse' 又较为类似