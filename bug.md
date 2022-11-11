- [1.空指针异常](#1)














#### <span id="1">空指针异常</span>
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
