## 五、API设计

我今天要给出的最后一条建议是`设计`, 我认为这也**是最重要的**。

到目前为止我提出的所有建议都是建议。 这些是我尝试编写 `Go` 语言的方式，但我不打算在代码审查中拼命推广。

但是，在审查 `API` 时, 我就不会那么宽容了。 这是因为到目前为止我所谈论的所有内容都是可以修复而且不会破坏向后兼容性; 它们在很大程度上是实现的细节。

当涉及到软件包的公共 `API` 时，在初始设计中投入大量精力是值得的，因为稍后更改该设计对于已经使用 `API` 的人来说会是破坏性的。

### 5.1 设计难以被误用的 API

> APIs should be easy to use and hard to misuse. (API 应该易于使用且难以被误用) — Josh Bloch

如果你从这篇文章中学到任何东西，那应该是 `Josh Bloch` 的建议。 如果一个 `API` 很难用于简单的事情，那么 `API` 的每次调用都会很复杂。 当 `API` 的实际调用很复杂时，它就会变得不那么清晰，而且会更容易被忽视。

#### 5.1.1 警惕采用几个相同类型参数的函数

举个例子：一种看起来简单，但是很难去正确使用的 `API` 是采用两个或更多相同类型参数的 `API`。让我们比较两个函数签名：

```go
func Max(a, b int) int
func CopyFile(to, from string) error
```

这两个函数有什么区别？ 显然，一个返回两个数字最大的那个，另一个是复制文件，但这不重要。

```go
Max(8, 10) // 10
Max(10, 8) // 10
```

`Max` 是可交换的; **参数的顺序无关紧要**。 无论是 `8` 比 `10` 还是 `10` 比 `8`，最大的都是 `10`。

但是，却不适用于 `CopyFile`。

```go
CopyFile("/tmp/backup", "presentation.md")
CopyFile("presentation.md", "/tmp/backup")
```

这些声明中哪一个备份了 `presentation.md`，哪一个用上周的版本覆盖了 `presentation.md`？ 没有文档，你无法分辨。 如果没有查阅文档，代码审查员也无法知道你写对了顺序。

一种可能的解决方案是**引入一个 `helper` 类型**，它会负责如何正确地调用 `CopyFile`。

```go
package main

type Source string

func (src Source) CopyTo(dest string) error {
	return CopyFile(dest, string(src))
}

func main() {
	var from Source = "presentation.md"
	from.CopyTo("/tmp/backup")
}
```

通过这种方式，`CopyFile` 总是能被正确调用 - 还可以通过单元测试 - 并且可以被设置为私有，进一步**降低了误用的可能性**。

> 贴士: 具有多个相同类型参数的 `API` 难以正确使用。

> 总结：使用 `helper` 类型帮助明确函数的参数用途，来避免多个同类型参数造成的混淆。

### 5.2 为其默认用例设计 API

几年前，我就对 `functional options`[7](https://commandcenter.blogspot.com/2014/01/self-referential-functions-and-design.html)
进行过讨论[6](https://dave.cheney.net/2014/10/17/functional-options-for-friendly-apis)，使 API 更易用于默认用例。

这一节的主旨是你应该为**常见用例**设计 `API`。 另一方面， `API` 不应要求调用者提供他们不在乎的参数。

#### 5.2.1 不鼓励使用 nil 作为参数

本章开始时我建议是不要强迫提供给 `API` 的调用者他们不在乎的参数。 这就是我要说的为**默认用例**设计 `API`。

> 贴士: 不要在同一个函数签名中混合使用可为 `nil` 和不能为 `nil` 的参数。

> 贴士: 认真考虑 `helper` 函数会节省不少时间。 清晰要比简洁好。

> 贴士: 避免公共 `API` 使用测试参数 避免在公开的 `API` 上使用仅在测试范围上不同的值。 相反，使用 `Public wrappers` 隐藏这些参数，使用辅助方式来设置测试范围中的属性。

本章内容并没有很好的理解，以后再研究。

#### 5.2.2 首选可变参数函数而非 []T 参数

我经常会写一个带有切片参数的函数或者方法。

```go
func ShutdownVMs(ids []string) error
```

这只是我编的一个例子，但它与我所写的很多代码相同。 这里的**问题**是人们假设函数被调用的时候需要多个参数。 但是很多时候这些类型的函数调用的时候只需要一个参数，为了满足函数参数的要求，它必须打包到一个切片内。

另外，因为 `ids` 参数是切片，所以你可以将一个空切片或 `nil` 传递给该函数，编译也没什么错误。 但是这会增加**额外的测试负载**，因为你应该涵盖这些情况在测试中。

举一个这类 `API` 的例子，最近我重构了一条逻辑，要求我设置一些额外的字段，如果一组参数中至少有一个非零。 逻辑看起来像这样：

````go
if svc.MaxConnections > 0 || svc.MaxPendingRequests > 0 || svc.MaxRequests > 0 || svc.MaxRetries > 0 {
// apply the non zero parameters
}
````

由于 `if` 语句变得很长，我想将检查的逻辑拉入其自己的函数中。 这就是我提出来的函数：

````go
package main

// anyPostive indicates if any value is greater than zero.
func anyPositive(values ...int) bool {
	for _, v := range values {
		if v > 0 {
			return true
		}
	}
	return false
}
````

这就能够向读者**明确**内部块的执行条件：

````go
if anyPositive(svc.MaxConnections, svc.MaxPendingRequests, svc.MaxRequests, svc.MaxRetries) {
// apply the non zero parameters
}
````

但是 `anyPositive` 还存在一个**问题**，有人可能会这样调用它:

````go
if anyPositive() { ... }
````

在这种情况下，`anyPositive` 将返回 `false`，因为它不会执行迭代而是立即返回 `false`。对比起如果 `anyPositive` 在没有传递参数时返回 `true`, 这还不算世界上最糟糕的事情。

然而，如果我们可以更改 `anyPositive` 的签名以**强制调用者应该传递至少一个参数**，那会更好。我们可以通过**组合正常和可变参数**来做到这一点，如下所示：

````go
package main

// anyPostive indicates if any value is greater than zero.
func anyPositive(first int, rest ...int) bool {
	if first > 0 {
		return true
	}
	for _, v := range rest {
		if v > 0 {
			return true
		}
	}
	return false
}
````

现在不能使用少于一个参数来调用 `anyPositive`。

> 总结：1）抽离代码过长的逻辑判断代码。 2）使用正常和可变参数的组合来达到更好的效果。确保必须传递一个及以上的参数。

### 5.3 让函数定义它们所需的行为

假设我需要编写一个将 `Document` 结构保存到磁盘的函数的任务。

````go
// Save writes the contents of doc to the file f.
func Save(f *os.File, doc *Document) error
````

我可以指定这个函数 `Save`，它将 `*os.File` 作为写入 `Document` 的目标。

缺点：

- **扩展不便**。如果网络存储在之后成为需求，则该函数签名需要改变，这会**影响到所有的调用者**。
- **测试麻烦**。直接操作磁盘上的文件，为了验证操作，需要写入文件之后再读取文件，且需要确保 `f` 被写入临时位置并且之后要将其删除。
- **参数冗余**。`*os.File` 还定义了许多与 `Save` 无关的方法，比如读取目录并检查路径是否是符号链接。 如果 `Save` 函数的签名只用 `*os.File` 的相关内容，减少不需要的内容，那将会更好。

我们应该怎么做？

````go
// Save writes the contents of doc to the supplied
// ReadWriterCloser. Only Read,Write,Close
func Save(rwc io.ReadWriteCloser, doc *Document) error
````

使用 `io.ReadWriteCloser`，我们可以应用**[接口隔离原则]**(https://zh.wikipedia.org/wiki/%E6%8E%A5%E5%8F%A3%E9%9A%94%E7%A6%BB%E5%8E%9F%E5%88%99)来重新定义 `Save`
以获取更通用文件形式。

通过此更改，**任何实现 `io.ReadWriteCloser` 接口的类型都可以替换以前的 `*os.File`**。

这使 `Save` 在其应用程序中更广泛，并向 `Save` 的调用者**阐明 `*os.File` 类型的哪些方法**与其**操作**有关。

而且，`Save` 函数的实现者也不可以在 `*os.File` 上调用那些不相关的方法，因为它隐藏在 `io.ReadWriteCloser` 接口后面。

但我们可以进一步采用**接口隔离原则**。

首先，如果 `Save` 遵循[**单一功能原则**](https://zh.wikipedia.org/wiki/%E5%8D%95%E4%B8%80%E5%8A%9F%E8%83%BD%E5%8E%9F%E5%88%99)，它不可能读取它刚刚写入的文件来验证其内容 -
这应该是另一段代码的功能。

````go
// Save writes the contents of doc to the supplied
// WriteCloser. Only Write,Close
func Save(wc io.WriteCloser, doc *Document) error
````

因此，我们可以将我们传递给 `Save` 的**接口的规范**缩小到**只写**和**关闭**。

其次，通过向 `Save` 提供一个关闭其流的机制，使其看起来仍然像一个文件，这就提出了在什么情况下关闭 `wc` 的问题。

可能 `Save` 会无条件地调用 `Close`，或者在成功的情况下调用 `Close`。

这给 `Save` 的调用者带来了问题，因为它可能希望在写入文档后将其他数据写入流。

```go
// Save writes the contents of doc to the supplied
// Writer.
func Save(w io.Writer, doc *Document) error
```

一个更好的解决方案是重新定义 `Save` 仅使用 `io.Writer`，它**只负责将数据写入流**。

将**接口隔离原则**应用于我们的 `Save` 功能，同时, 就需求而言, 得出了最具体的一个函数 - 它只需要一个可写的东西 - 并且它的功能最通用，现在我们可以使用 `Save` 将我们的数据**保存到实现 `io.Writer` 的任何事物中**。

[译注: 不理解设计原则部分的同学可以阅读 Dave 大神的另一篇《Go 语言 SOLID 设计》](https://www.jianshu.com/p/0aebd9618300)

> 总结:
> 
> 1）接口隔离原则：客户（client）不应被迫使用对其而言无用的方法或功能。接口隔离原则（ISP）拆分非常庞大臃肿的接口成为更小的和更具体的接口，这样客户将会只需要知道他们感兴趣的方法。尽可能地减少参数携带的方法，只需要提供必要的方法。
> 
> 2）单一功能原则：函数应该是只实现单一功能。将方法和函数拆分为更细粒度的函数，每个函数只实现唯一的功能。

> 内容学习于该博客：[英文博客](https://dave.cheney.net/practical-go/presentations/qcon-china.html "英文博客")
>
> 同时借鉴于该翻译：[中文翻译](https://github.com/llitfkitfk/go-best-practice/blob/master/README.md "中文翻译")