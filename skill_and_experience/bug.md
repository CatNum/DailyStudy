- [1. 空值异常](#1)
    - [1.1 空指针异常](#1.1)
    - [1.2 空指针异常](#1.2)
    - [1.3 *gin.Context.JSON](#1.3)
    - [1.4 json.Marshal](#1.4)
- [2. 时间问题](#2)
  - [2..1 时区问题](#2.1)
- [3. MongoDB](#3)
  - [3.1 MongoDB插入](#3.1)

### <span id="1">空值异常</span>

#### <span id="1.1">空指针异常</span>

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

#### <span id="1.2">gin中的require标签</span>

**问题：** 当结构体设置为require的标签时，如果字段为int，前端传递0识别为没有填写。

**解决方法：** 将int类型改为*int类型

#### <span id="1.3">*gin.Context.JSON</span>

**问题：** *gin.Context.JSON ：结构体值为NaN时，【模糊了，不记得具体场景了】

#### <span id="1.4">json.Marshal</span>

**问题：** 如果参数中的切片为nil，需要将切片初始化，因为nil在json中为null。有时会有问题

### <span id="2">时间问题</span>
#### <span id="2.1">时区问题</span>
涉及时间戳转时间（time）时，同一个时刻，不同时区时间戳是一样的，但是时间（time）是不一样的。
时间戳转时间的时候，统一转成某一个时区的时间（time）。使用time.Now()获取的是当地时间，即跟时区有关，
需要时间的时候将time.Now()转换为时间戳再转换为对应时区的时间（time）

### <span id="3">MongoDB</span>
#### <span id="3.1">MongoDB插入</span>
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
	AppInfo time.Time            `json:"app_info,omitempty" bson:"app_info,omitempty"`
	B       *B                   `json:"b,omitempty" bson:"b,omitempty"`
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