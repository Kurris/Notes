### C#入门
>C#是基于 **.net framework** 平台运行
>能够编写windows的桌面程序,Web程序,基本Http,Tcp的程序,windows服务程序等!


程序主要包含:
* namespace命名空间
* class类
* class 方法
* class属性,字段
* Main主方法
* 注释等

>**namespace**需要用using引用,一个程序可以有多个命名空间;
>一个namespace可以有**多个**类class,类里面包含多个属性,方法,其中Main只有一个,为程序入口!

##### 一个简单面向对象代码如下:
1. 指定命名空间
```
namespace ConsoleApplication1
```
2. 类与方法Main入口
```C#
class Program
    {
        static void Main(string[] args)
        {
        }
    }
```
3. 字段和属性
```C#
private string sfield = string.Empty;
public string Field { get; set; }
```

4. 方法
```C#
private string GetString()
{
return this.sfield;
}
```

#### 总结
##### >> 面向对象语言就是对一个事物的多个组成方面作处理,例如车子就是一个程序,其中命名空间就是车,类就是车品牌,组成的零件如轮子,座椅,发动机等都可以称为属性,方法也就是车子的功能!