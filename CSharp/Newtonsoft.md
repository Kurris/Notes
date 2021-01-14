### Newtonsoft.json(DotNet.json)
* **json结果转化成集合**  返回数组集合
	<u>类型JToken是JArray中的每一个组合</u>
```C# 
JArray jarray = JArray.Parse("需要转化的内容"); 
```

* **序列化对象** 返回字符串
```C#
JsonConvert.SerializeObject(Object);
```

* **反序列化**
```C#
对象 dx=JsonConvert.DeserializeObject<Object>(json字符串);
```

---
* **实体中有些属性不需要序列化返回，可以使用该特性**

- `OptOut` 默认值,类中所有公有成员会被序列化,如果**<u>不想被序列化</u>**,可以用`JsonIgnore`
```C#
[JsonObject(MemberSerialization.OptOut)]
public class Person 
{ 
    public int Age { get; set; }
    public string Name { get; set; }
    public string Sex { get; set; }
    [JsonIgnore]
    public bool IsMarry { get; set; }
}
```

- `OptIn` 默认情况下,所有的成员不会被序列化,类中的成员**只有标有特性`JsonProperty`的才会被序列化**,当类的成员很多,但客户端仅仅需要一部分数据时,很有用
```C#
[JsonObject(MemberSerialization.OptIn)]
public class Person 
{ 
    public int Age { get; set; }
    [JsonProperty]
    public string Name { get; set; }
}
```

---

- **序列化实体类的时候, 处理所有属性值为`null`的情况**
```C#
JsonSerializerSettings jsetting=new JsonSerializerSettings();
jsetting.NullValueHandling = NullValueHandling.Ignore;
JsonConvert.SerializeObject(Object, Formatting.Indented, jsetting);
```

- **对实体类单个属性的情况,如果为`null`就不处理** 
```C#
[JsonProperty(NullValueHandling=NullValueHandling.Ignore)]
public Room room { get; set; }
```

- **处理私有属性, 序列化是默认全部共有属性的**
```C#
[JsonProperty]
private int Height { get; set; }
```

- **自定义序列化名称**
```C#
[JsonProperty(PropertyName = "CName")]
public string Name { get; set; }
```