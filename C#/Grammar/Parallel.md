### C# Parallel 并行线程

1. **Parallel.Invoke 主要用于任务的并行** 它主要有俩种形式
 * Parallel.Invoke( params Action[] actions);　　
 * Parallel.Invoke(Action[] actions,TaskManager manager,TaskCreationOptions options);

```c#
            var actions = new Action[]
            {
                () => ActionTest("test 1"),
                () => ActionTest("test 2"),
                () => ActionTest("test 3"),
                () => ActionTest("test 4")
            };

            Console.WriteLine("Parallel.Invoke 1 Test");
            Parallel.Invoke(actions);

            Console.WriteLine("结束！");
```
2. **For方法，主要用于处理针对数组元素的并行操作(数据的并行)** 
```C#
int[] nums = new int[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
            Parallel.For(0, nums.Length, (i) =>
            {
                Console.WriteLine("针对数组索引{0}对应的那个元素{1}的一些工作代码……ThreadId={2}", i, nums[i], Thread.CurrentThread.ManagedThreadId);
            });
```
3. **Foreach方法，主要用于处理泛型集合元素的并行操作(数据的并行)**
```c#
List<int> nums = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
            Parallel.ForEach(nums, (item) =>
            {
                Console.WriteLine("针对集合元素{0}的一些工作代码……ThreadId={1}", item, Thread.CurrentThread.ManagedThreadId);
            });         
```
4. **并行也可以使用 AsParallel() 基于Linq的方式**
```C#
List<int> nums = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
            var evenNumbers = nums.AsParallel().Select(item => Calculate(item));
```
5. **ForEach的独到之处就是可以将数据进行分区，每一个小区内实现串行计算，分区采用Partitioner.Create实现**
```C#
ConcurrentBag<int>  bag = new ConcurrentBag<int>();
                var watch = Stopwatch.StartNew();
                watch.Start();
                Parallel.ForEach(Partitioner.Create(0, 3000000), i =>
                {
                    for (int m = i.Item1; m < i.Item2; m++)
                    {
                        bag.Add(m);
                    }
                });
```
>以上的`ConcurrentBag<T>`是线程安全的类,如果需要在并行线程处理集合,必须使用这个类;
>位置`System.Collections.Concurrent;`
>还有`ConcurrentDictionary<T>`,`ConcurrentStack<T>`,`ConcurrentQueue<T>`,

6. **ParallelOptions** 为我们提供了硬件开启线程的数量
```C#
ParallelOptions options = new ParallelOptions();　
options.MaxDegreeOfParallelism = 4;
```
7. **并行终止**
* `Break`: 当然这个是通知并行计算尽快的退出循环，比如并行计算正在迭代100，那么break后程序还会迭代所有小于100的。　　
* `Stop`:这个就不一样了，比如正在迭代100突然遇到stop，那它啥也不管了，直接退出。
```C#
Parallel.For(0, 20000000, (i, state) =>
            {
                if (bag.Count == 1000)
                {
                    //state.Break();                   
                    state.Stop();
                    return;
                }
                bag.Add(i);
            });
```
  8. **取消并行** `CancellationTokenSource`
    将取消的参数传入`ParallelOptions`的`CancellationToken `


  9. **异常捕捉** `AggregateExcepation` 即可捕捉一组异常