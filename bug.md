- [1. 空值异常](#1)
    - [1.1 空指针异常](#1.1)
    - [1.2 空指针异常](#1.2)
    - [1.3 *gin.Context.JSON](#1.3)
    - [1.4 json.Marshal](#1.4)
- [2. 时间问题](#2)
  - [2..1 时区问题](#2.1)

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