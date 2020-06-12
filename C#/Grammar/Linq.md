#  Linq

* Linq的**From**类型语法可以实现查询数据,一般用于对实体的操作,并且是可以延迟执行,提高性能
* 还有一种方式是基于**IEnumerable**接口和**Lambda**表达式,并且实现了**GetEnumerator**方法

##### 一.  From语法
1. **简单查询** 没有条件,只是单独把实体list数据展示出来
```c#
var query = from r in listStudents select r;
```
2. **条件查询** **where**条件查询,r是一个list实体数据,通过"."运算符可以找到该实体的属性score
```c#
var query = from r in listStudents
where r.score < 60
select r;
```
3. **排序查询** 使用**orderby**和**descending**按倒序排列
```c#
var query = from r in listStudents
orderby r.score descending
select r;
```

4.  **分组查询** nums是个数组,分组完之后,g取代a,条件是取g中相同的数量>1,最后可生成一个匿名类,并且带有b,c的属性
```c#
var query = from a in nums
                    group a by a into g
                    where g.Count() > 1
                    select new { b = g.Key , c = g.Count() 
```

5. **联合查询** 组合qst和c两个集合,条件是俩个集合的year相等,通过select投影新的类型集合
```c#
var qjoin = from r in qSt
                join c in qSc
                on r.year equals c.year
                select new
                {
                Year = r.year,
                stName = r.name,
                scName = c.name
                };
````

6. **分页查询**  Skip(i)从下标多少开始;Take(i)获取多少数据;
```c#
            int[] nums = { 2,6,4,8,7,66,4};
            //排除前俩个,选3个数据
            var query1 = nums.Skip(2).Take(3);
            foreach (var item in query1)
            {
                Console.WriteLine(item);//打印结果为4 8 7 
            }
```

7, **构造并行**

* **取消方法** 定义一个取消并行的`取消参数`
```c#
var cts = new CancellationTokenSource();
```
* **并行查询** 内部可以自动实现多线程执行数据查询,并且可以主动中断查询过程.具体可以通过执行慢方法体现
```c#
var sum = (from x in                              data.AsParallel().WithCancellation(cts.Token)
where x < 20 select x
```
`此处的多线程实现方式在其他笔记中记录`

---
##### 二.  基于**IEnumerable**接口和**Lambda**表达式
1. **Select**
    投影被查找的数据放进一个新集合里面,新集合类型为查找返回的类型
2. **SelectMany**
投影被查找的数据,如果查找的数据返回是数组,则该数组的元素会被依次放进一个新集合里面
3. **Find**
查找匹配的数据,返回被查找的数据在该集合的首个
4. **FindAll**
查找匹配的数据,返回被查找的数据集合
5. **FindIndex**
查找匹配的数据,返回被查找的数据在该集合的首个索引
6. **FindLast**
查找匹配的数据,返回被查找的数据集合的最后一个
7. **FindLastIndex**
查找匹配的数据,返回被查找的数据集合的最后一个索引
8. **Remove**\
移除集合中匹配的首个元素,返回移除的Bool结果
9. **RemoveAll**
移除集合中匹配的元素,返回移除数量
10. **RemoveRange**
指定开始索引,指定移除个数
11. **RemoveAt**
移除集合中指定的索引元素
12. **Reverse<T>**
* 无参方法,直接反转集合   
* 指定开始索引,指定反转个数
* 泛型,指定反转后的元素类型
13. **Union**
关联2个集合,去除相同的元素
14. **Sum** **Average** **Max** **Min**
总和,平均数,最大,最小
15. **All**
表示所有元素匹配才返回True
16. **Any**
表示任意元素匹配才返回True
17. **IndexOf**
* 无参数,查找元素在集合中的索引
* 指定元素,查找的开始索引,无则返回-1

---