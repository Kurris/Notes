### C# Newtonsoft.json
* **json结果转化成集合**  返回数组集合
``` 
JArray jarray = JArray.Parse("需要转化的内容"); 
```
`类型JToken是JArray中的每一个组合`

* **序列化对象** 返回字符串
```
JsonConvert.SerializeObject(对象);
```

* **反序列化**
```
对象 dx=JsonConvert.DeserializeObject<对象>(json字符串);
```

---
* **实体中有些属性不需要序列化返回，可以使用该特性**
1. **OptOut** 默认值,类中所有公有成员会被序列化,如果**不想被序列化**,可以用**特性JsonIgnore**
```
[JsonObject(MemberSerialization.OptOut)]
public class Person { public int Age { get; set; }
public string Name { get; set; }
public string Sex { get; set; }
[JsonIgnore]
public bool IsMarry { get; set; }
```
2. **OptIn** 默认情况下,所有的成员不会被序列化,类中的成员**只有标有特性JsonProperty的才会被序列化**,当类的成员很多,但客户端仅仅需要一部分数据时,很有用
```
[JsonObject(MemberSerialization.OptIn)]
public class Person { public int Age { get; set; }
[JsonProperty]
public string Name { get; set; }
```

---

* **序列化实体类的时候, 处理所有属性值为null的情况**
```
JsonSerializerSettings jsetting=new JsonSerializerSettings();
jsetting.NullValueHandling = NullValueHandling.Ignore;
Console.WriteLine(JsonConvert.SerializeObject(实体类, Formatting.Indented, jsetting));
```
* **对实体类单个属性的情况,如果为NULL就不处理** 
```
[JsonProperty(NullValueHandling=NullValueHandling.Ignore)]
public Room room { get; set; }
```

* **处理私有属性, 序列化默认全部共有属性**
```
[JsonProperty]
private int Height { get; set; }
```

* **自定义序列化名称**
```
[JsonProperty(PropertyName = "CName")]
public string Name { get; set; }
```