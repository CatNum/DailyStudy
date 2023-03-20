## 五、API设计

我今天要给出的最后一条建议是设计, 我认为这也是最重要的。

到目前为止我提出的所有建议都是建议。 这些是我尝试编写 Go 语言的方式，但我不打算在代码审查中拼命推广。

但是，在审查 API 时, 我就不会那么宽容了。 这是因为到目前为止我所谈论的所有内容都是可以修复而且不会破坏向后兼容性; 它们在很大程度上是实现的细节。

当涉及到软件包的公共 API 时，在初始设计中投入大量精力是值得的，因为稍后更改该设计对于已经使用 API 的人来说会是破坏性的。

### 5.1 设计难以被误用的 API

> APIs should be easy to use and hard to misuse. (API 应该易于使用且难以被误用) — Josh Bloch

如果你从这篇文章中学到任何东西，那应该是 Josh Bloch 的建议。 如果一个 API 很难用于简单的事情，那么 API 的每次调用都会很复杂。 当 API 的实际调用很复杂时，它就会变得不那么清晰，而且会更容易被忽视。

#### 5.1.1 警惕采用几个相同类型参数的函数

举个例子：一种看起来简单，但是很难取正确使用的 API 是采用两个或更多相同类型参数的 API。让我们比较两个函数签名：

```go
func Max(a, b int) int
func CopyFile(to, from string) error
```

这两个函数有什么区别？ 显然，一个返回两个数字最大的那个，另一个是复制文件，但这不重要。

```go
Max(8, 10) // 10
Max(10, 8) // 10
```

Max 是可交换的; 参数的顺序无关紧要。 无论是 8 比 10 还是 10 比 8，最大的都是 10。

但是，却不适用于 CopyFile。

```go
CopyFile("/tmp/backup", "presentation.md")
CopyFile("presentation.md", "/tmp/backup")
```

这些声明中哪一个备份了 presentation.md，哪一个用上周的版本覆盖了 presentation.md？ 没有文档，你无法分辨。 如果没有查阅文档，代码审查员也无法知道你写对了顺序。

一种可能的解决方案是引入一个 helper 类型，它会负责如何正确地调用 CopyFile。

```go
type Source string

func (src Source) CopyTo(dest string) error {
	return CopyFile(dest, string(src))
}

func main() {
	var from Source = "presentation.md"
	from.CopyTo("/tmp/backup")
}
```

通过这种方式，CopyFile 总是能被正确调用 - 还可以通过单元测试 - 并且可以被设置为私有，进一步降低了误用的可能性。

> 贴士: 具有多个相同类型参数的API难以正确使用。

