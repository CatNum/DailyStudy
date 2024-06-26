- [1. 空值异常](#1)
    - [1.1 空指针异常](#1.1)
    - [1.2 gin中的require标签](#1.2)
    - [1.3 *gin.Context.JSON](#1.3)
    - [1.4 json.Marshal](#1.4)
- [2. 时间问题](#2)
    - [2..1 时区问题](#2.1)
- [3. MongoDB](#3)
    - [3.1 MongoDB插入](#3.1)
    - [3.2 MongoDB Shell使用时表名带有特殊字符](#3.2)
    - [3.3 MongoDB Go Driver 时间查询时的时区问题](#3.3)
- [4. 多线程问题](#4)
    - [4.1 多线程解压及打包](#4.1)
- [5. 标签问题](#5)
    - [5.1 omitempty](#5.1)
- [6. 编码问题](#6)
    - [6.1 Redis使用中文名乱码](#6.1)
- [7. 高并发问题](#7)
    - [7.1 高并发插入Mongodb造成记录重复](#7.1)
- [8. 字符串问题](#8)
  - [8.1 字符串拼接分割导致的问题](#8.1)
- [9. Go 并发编程](#9)
  - [9.1 Channel 使用](#9.1)

### <span id="1">1 空值异常</span>

#### <span id="1.1">1.1 空指针异常</span>

参考文章：[空指针异常](https://zhuanlan.zhihu.com/p/420744715)
指针变量尽量使用new创建，否则如果没有对指针变量存储的变量进行初始化，则指针变量为空，会报空指针异常。

```go
func main() {
var i *int
//fmt.Println(i, &i,*i)
// 输出： nil i的地址 *i报错
i = new(int)
*i = 10
fmt.Println(i, &i, *i)
// 输出： i存储的变量的地址 i的地址 i存储的变量的值10
}
```

**当使用切片下表对切片进行赋值的时候，要注意切片该下表的空间地址是否初始化了，这里很容易空指针异常**

#### <span id="1.2">1.2 gin中的require标签</span>

**问题：** 当结构体设置为require的标签时，如果字段为int，前端传递0识别为没有填写。

**解决方法：** 将int类型改为*int类型

#### <span id="1.3">1.3 *gin.Context.JSON</span>

**问题：** *gin.Context.JSON ：结构体值为NaN时，【模糊了，不记得具体场景了】

#### <span id="1.4">1.4 json.Marshal</span>

**问题：** 如果参数中的切片为nil，需要将切片初始化，因为nil在json中为null。有时会有问题

### <span id="2">2 时间问题</span>

#### <span id="2.1">2.1 时区问题</span>

涉及时间戳转时间（time）时，同一个时刻，不同时区时间戳是一样的，但是时间（time）是不一样的。 时间戳转时间的时候，统一转成某一个时区的时间（time）。使用time.Now()获取的是当地时间，即跟时区有关，
需要时间的时候将time.Now()转换为时间戳再转换为对应时区的时间（time）

### <span id="3">3 MongoDB</span>

#### <span id="3.1">3.1 MongoDB插入</span>

MongoDB 可以使用在 bson.D 中使用结构体嵌套字段进行插入，例子如下。注：MongoDB 使用结构体插入的时候，如果结构体字段首字母小写，则该字段不会插入。

如果B中的S和A是小写开头的字段，则以下对于嵌套字段的插入会失败。

```go

package main

import (
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/bson"
	"time"
)

type A struct {
	AppInfo time.Time `json:"app_info,omitempty" bson:"app_info,omitempty"`
	B       *B        `json:"b,omitempty" bson:"b,omitempty"`
}

type B struct {
	S string `bson:"s,omitempty"`
	A string `bson:"a,omitempty"`
}

func main() {
	cli := NewClient()
	coll := cli.Database("sample").Collection("test")
	b := B{
		S: "s1",
		A: "a1",
	}
	aa := A{
		AppInfo: time.Now(),
		B:       &b,
	}
	a := bson.D{
		{"app_info", aa.AppInfo},
		{"b", aa.B},
	}
	result, err := coll.InsertOne(context.TODO(), a)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(result)
}

// NewClient 创建连接
func NewClient() *mongo.Client {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	clientOptions := options.Client().ApplyURI("mongodb://192.192.100.69:27017/?directConnection=true")

	client, err := mongo.Connect(ctx, clientOptions)
	//client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI("mongodb://root:123456@192.192.100.85:27017"))
	if err != nil {
		panic(err)
	}

	return client
}
```

#### <span id="3.2">3.2 MongoDB Shell使用时表名带有特殊字符</span>

[参考链接](https://blog.csdn.net/zw05011/article/details/105527386)

**场景：** 使用`shell`对`mongodb`进行操作，`mongodb`集合名带有特殊字符，比如‘-’

```shell
db.api-log.update({}, {$rename:{"old_name":"new_name"}}, false, true)  # 该语句会报错
#应该使用下面的语句
db.getCollection('api-log').update({}, {$rename:{"old_name":"new_name"}}, false, true)
```

### <span id="3.3">3.3 MongoDB Go Driver 时间查询时的时区问题</span>

**场景：** 使用MongoDB Go Driver进行时间范围查询，MongoDB中存储的是 UTC0 的时间

**问题：** 直接查询MongoDB中的数据会导致查询出的时间和本地时间不一致，不能直接返回给前端展示。

**解决方法：** 需要对时间进行本地时区的转换，将时间转换为本地时区。

**涉及理论：** MongoDB在查询和插入时间的时候，会将时间转换为 UTC0 进行查询和插入，我们需要将前端传来的时间转换为本地时区再进行查询操作。同时，对查出来的时间 我们也需要将时区转换为当前时区再返回给前端。

**疑问：** 为什么MongoDB只在从Go到MongoDB的时候进行转换，从MongoDB查询的结果不进行转换。【这不会很别别扭吗】

[参考文章](https://blog.csdn.net/u010649766/article/details/79385948)

### <span id="4">4 多线程问题</span>

#### <span id="4.1">4.1 多线程解压及打包</span>

**场景一：** 多协程同时跑解压打包

协程中的流程：解压压缩包，生成临时文件到指定目录，加入授权文件，打包，打包完成后删除目录

**多协程跑导致的问题：** 当多个协程解压同一个压缩包时，生成的临时文件目录一致导致问题。例如当a协程正在删除临时目录，b协程正在解压压缩包生成临时目录，会造成冲突。

**场景二：** 解压协程中嵌套打包协程

解压协程：会将指定压缩包解压到指定目录

打包协程：会将指定文件打包生成压缩包放入指定目录

**导致的问题：** 解压协程未完全解压完成，打包协程已经开始运行，打包协程打包的过程中获取的信息不一致。例如a协程在时间t访问需要压缩的目录，获取目录大小，
然后解压协程还在解压，然后打包协程在时间t+1对目录进行打包，发现在时间t获取的目录大小小于当前文件的大小，导致打包失败，会报`archive/tar: write too long`错误。

### <span id="5">5 标签问题</span>

#### <span id="5.1">5.1 omitempty</span>

[omitempty讲解](https://old-panda.com/2019/12/11/golang-omitempty/)

**作用：** 该标签的作用是，在golang结构体转换为 json 或者 bson 时，忽略字段的默认值，即当golang结构体中的字段的值为类型默认值时，转换为json或bson时忽略该字段。

```go
package main

type test struct {
	Invert bool `json:"invert,omitempty" bson:"invert,omitempty"` // 是否取反
}
```

**问题：** 比如上例中，该字段的类型为bool，bool在mongodb中的默认值是 false，当入参为 false 时，mongodb在插入记录时会忽略该字段，造成该记录中不存在该字段的问题。

**造成的影响：** 会导致在查询的时候，对该字段值为 false 的记录查询失败。

**解决方法：** 去掉 omitempty 字段。

```go
package main

type Policy struct {
	XId  string `json:"_id,omitempty" bson:"_id,omitempty"`
	Name string `json:"name,omitempty" bson:"name"`
}
```

**前提：** Xid为string类型，入参时不输入Xid，无 omitempty 标签。

**问题：** 前端json在转为后端结构体时，XId会被赋值为 "" ，然后如果没有 omitempty,则以 "" 作为mongodb中的唯一标识， ，造成只能插入一条记录，因为所有的_id经过转化都是 ""
，主键唯一索引冲突导致插入失败。

**解决方法：** 加上 omitempty 字段，这时候，在结构体转化为 bson 插入数据库的时候，数据库会忽略 "" ,然后自动生成 一个唯一的 _id 来作为该记录的 _id。

### <span id="6">6 编码问题</span>

#### <span id="6.1">6.1 Redis使用中文名乱码 </span>

在Redis中，使用中文名作为key会导致乱码【在RedisDesktopManager中以及使用redis-cli下】。

**eg.** 两个hash，一个为hash1:中文:SourceIp:20230220:09:34；另一个为hash1:中文:SourceIp:20230220:09:35， 这两个hash在Redis Desktop Manager
中会显示两个目录，而不是一个。如果把“中文”换成英文字符，就会在一个目录下，便于观看。

**解决方法：** 可以使用 redis-cli --raw 进入命令行模式，则中文不会乱码

### <span id="7">7 高并发问题</span>

#### <span id="7.1">7.1 高并发插入Mongodb造成记录重复 </span>

**前提：**

- **需求：** 记录如果存在就更新，如果不存在就插入。

- **场景：** 初始逻辑：先判断是否存在，不存在就调用插入接口，存在就调用更新接口。

**造成问题：** 当高并发插入时，多个协程同时判断不存在，调用插入接口，导致插入多条重复记录。

**解决方式：**

1. 加锁
    - 缺点：会对主流程产生影响，尤其是在高并发的情况下。

2. 加唯一索引，先插入再更新
    - 添加一个唯一索引字段，使用数据库本身的唯一性来确保插入的数据是唯一的。这样高并发下，只能插入一条记录，判断插入失败 ，则再更新一次记录

  
### <span id="8">8 字符串问题</span>

#### <span id="8.1">8.1 字符串拼接分割导致的问题 </span>

**问题：** 
  - **前提：** 
    - 数据存储在 `Redis` 中；
    - `Redis` 的 `Key` 中需要存储前端展示的信息（包括资源的名字，比如商品名称），商品除了商品名称，还有商品Uid
    - 名称中对特殊字符没有限制，对长度也没有限制，对一切都没有限制
  - **造成问题的原因：** 使用 `-` 拼接多个名称，然后在取数据的时候根据 `-` 分割来取到对应的商品名称
  - **造成的问题：** 因为名字没有限制，用户可以输入 `-` ，导致取数据的时候分割不符合预期，导致商品名称展示错误
 - **如何解决:**
   - **解决思路：**
     - 1、限制商品名称的输入，禁止输入一些特殊字符
     - 2、将名称转换为不包含特殊符号的密文再使用 `-` 拼接
     - 3、使用单独的 `Key` 对商品Uid和商品名称建立对应关系（ `Redis` `Sting` 类型存储），在原先Key上只存商品Uid，先取商品Uid，再取商品名称。
     - 4、使用`json`或者`proto`序列化，避免使用 `-` 拼接分割操作
   - **解决思路局限性：**
     - 1、因为项目问题，不支持更改
     - 2、名称转换为密文，太长了，不友好
     - 3、对后端逻辑更改太大，时间不允许
     - 4、方法合适，但是当名称中包含 `英文冒号` 时，也会有当前问题（因为这里先是将数据存储到结构体，然后序列化为对应 `json` 或 `proto`，然后
存入 `Key` 中，取数据的时候，再根据其反序列为结构体，避免了字符串的拼接和分割操作。注：但是因为公共方法中对 `Redis` 的 `Key` 有通过 `英文冒号`分割的操作，所以也有当前问题）
       - 4.1 这里结合第 `2` 种解决方法，先将其转换为 `json` 串，再使用 `base64` 编码，确保了最终结果没有 `英文冒号` ，因为只对最终 `json` 进行 `base64` 编码，所以不会有太长的问题，同时也避免了包含 `英文冒号` 造成的问题


### <span id="9">9 Go 并发编程</span>

#### <span id="9.1">9.1 Channel 使用 </span>

- 在 Go 中，Channel 的 len(Channel) 是基本不会使用的，
  1. len 会随着消费和生产一直在变更，不是一个确定的值，所以 len(channel) 一般没有实际的意义，所以就没有用处