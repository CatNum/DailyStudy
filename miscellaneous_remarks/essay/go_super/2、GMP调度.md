
## 一、GMP 调度

## 1、参考文章

**进程、线程和协程**

协程跟线程是有区别的，**线程由 CPU 调度是抢占式的**，**协程由用户态调度是协作式的**，一个协程让出 CPU 后，才执行下一个协程。

将 P 个数设置为 GOMAXPROCS 的值，即程序能够同时运行的最大处理器数

Goroutine 特点：

- 占用内存更小（几 kb）
- 调度更灵活 (runtime 调度)

在 Go 中，**线程是运行 goroutine 的实体**，调度器的功能是把可运行的 goroutine 分配到工作线程上。

![img.png](pictures/2）1-1.png)

- **全局队列（Global Queue）**：存放等待运行的 G。
- **P 的本地队列**：同全局队列类似，存放的也是等待运行的 G，存的数量有限，不超过 256 个。新建 G’时，G’优先加入到 P 的本地队列，如果队列满了，则会把本地队列中一半的 G 移动到全局队列。
- **P 列表**：所有的 P 都在程序启动时创建，并保存在数组中，最多有 GOMAXPROCS(可配置) 个。
- **M**：线程想运行任务就得获取 P，从 P 的本地队列获取 G，P 队列为空时，优先从全局获取，然后从网络轮询器获取，获取不到则从其他 P 偷。M 运行 G，G 执行之后，M 会从 P 获取下一个 G，不断重复下去。

调度器的设计策略：
- **尽可能复用线程 M**，避免频繁的线程创建和销毁；
- 利用**多核并行能力**，限制同时运行（不包含阻塞）的 M 线程数 等于 CPU 的核心数目；
- **Work Stealing 任务窃取机制**，当本线程无可运行的 G 时，优先从全局获取，然后从网络轮询器获取，获取不到则从其他 P 偷，而不是销毁线程；
- **Hand Off 交接机制**，为了提高效率，M 阻塞时，会将 M 上 P 的运行队列交给其他 M 执行；
- **基于协作的抢占机制**，为了保证公平性和防止 Goroutine 饥饿问题，Go 程序会保证每个 G 运行 10ms 就让出 M，交给其他 G 去执行，这个 G 运行 10ms 就让出 M 的机制，是由单独的系统监控线程通过 retake() 函数给当前的 G 发送抢占信号实现的，如果所在的 P 没有陷入系统调用且没有满，让出的 G 优先进入本地 P 队列，否则进入全局队列；；
- **基于信号的真抢占机制**，尽管基于协作的抢占机制能够缓解长时间 GC 导致整个程序无法工作和大多数 Goroutine 饥饿问题，但是还是有部分情况下，Go调度器有无法被抢占的情况，例如，for 循环或者垃圾回收长时间占用线程，为了解决这些问题， Go1.14 引入了基于信号的抢占式调度机制，能够解决 GC 垃圾回收和栈扫描时存在的问题；


**为什么不直接将本地队列放在 M 上、而是要放在 P 上呢？** 

这是因为当一个线程 M 阻塞（可能执行系统调用或 IO请求）的时候，可以将和它绑定的 P 上的 G 转移到其他线程 M 去执行，如果直接把可运行 G 组成的本地队列绑定到 M，则万一当前 M 阻塞，它拥有的 G 就不能给到其他 M 去执行了。

**基于协作的抢占式调度和基于信号的抢占式调度**

**基于协作的抢占式调度**

在 Go 语言的 v1.2 版本就实现了基于协作的抢占式调用，这种调用的基本原理就是：

- Go 语言运行时会在**垃圾回收暂停程序**、**系统监控发现 Goroutine 运行超过 10ms** 时发出抢占请求 StackPreempt（设置抢占标志）；
- 编译器会在调用函数前插入 runtime.morestack，当发生函数调用时，runtime.morestack 调用的 runtime.newstack 会**检查 Goroutine 的 stackguard0 字段是否为 StackPreempt（是否抢占）**，如果 stackguard0 是 StackPreempt，就会触发抢占让出当前线程；

解决如下问题：
- 某些 Goroutine 可以长时间占用线程，造成其它 Goroutine 的饥饿；
- 垃圾回收需要暂停整个程序（Stop-the-world，STW），最长可能需要几分钟的时间6，导致整个程序无法工作；

，但是他无法面对一些场景，比如在死循环中没有任何调用发生，那么这个协程将永远执行下去，永远不会发生调度，这显然是不可接受的。

对于上述问题，因为这种调度方式是协程主动的，是基于协作的，所以只是缓解，还是有一些边缘问题没有解决，比如：
- for 循环
- 垃圾回收长时间占用线程

**基于信号的抢占式调度**

目前的抢占式调度也**只会在垃圾回收扫描任务时触发**，我们可以梳理一下上述代码实现的抢占式调度过程：

- M 注册一个 SIGURG 信号的处理函数：sighandler。
- sysmon 线程检测到**执行时间过长的 goroutine**、**GC stw** 时，会向相应的 M（或者说线程，每个线程对应一个 M）发送 SIGURG 信号。
- 收到信号后，内核执行 sighandler 函数，通过 pushCall 插入 asyncPreempt 函数调用。
- 回到当前 goroutine 执行 asyncPreempt 函数，通过 mcall 切到 g0 栈执行 gopreempt_m。
- 将当前 goroutine 插入到全局可运行队列，M 则继续寻找其他 goroutine 来运行。
- 被抢占的 goroutine 再次调度过来执行时，会继续原来的执行流。

**使用 preemptM 发送抢占信号的地方主要有下面几个：**

- Go 后台监控 runtime.sysmon 检测**超时**发送抢占信号；
- Go GC **栈扫描**发送抢占信号；
- Go GC **STW** 的时候调用 preemptall 抢占所有 P，让其暂停；

基于信号的抢占式调度只解决了垃圾回收和栈扫描时存在的问题，它到目前为止没有解决所有问题。

Go 1.13 及之前版本两种会导致卡死的情况：

情况一：
```go
package main

import (
	"fmt"
	"runtime"
)

func main() {

	var x int
	for i := 0; i < 1; i++ {
		go func() {
			for {
				x++
			}
		}()
	}

	// 当主 goroutine 主动触发 GC 时，需要把所有当前正在运行的 goroutine 停止下来，
	// 即 stw（stop the world），但是 goroutine 正在执行无限循环，没法让它停下来。
	runtime.GC()

	fmt.Println("x = ", x)

}
```

情况二：

```go
package main

import (
	"fmt"
	"runtime"
	"time"
)

func main() {

	var x int

	processes := runtime.GOMAXPROCS(0)
	for i := 0; i < processes; i++ {
		go func() {
			for {
				x++
			}
		}()
	}

	time.Sleep(time.Second)

	fmt.Println("x = ", x)

}
```


> 参考链接：
>
> [[Golang三关-典藏版] Golang 调度器 GMP 原理与调度全分析](https://learnku.com/articles/41728 "[Golang三关-典藏版] Golang 调度器 GMP 原理与调度全分析")
>
> [深入分析Go1.18 GMP调度器底层原理](https://zhuanlan.zhihu.com/p/586236582 "深入分析Go1.18 GMP调度器底层原理")
> 
> [Go底层原理：一起来唠唠GMP调度（一）](https://blog.csdn.net/weixin_46618592/article/details/129333252 "Go底层原理：一起来唠唠GMP调度（一）")
>
> [6.5 调度器 #](https://draveness.me/golang/docs/part3-runtime/ch06-concurrency/golang-goroutine/#65-%E8%B0%83%E5%BA%A6%E5%99%A8 "6.5 调度器 #")
>
> [Golang调度器(5)—协作与抢占](https://juejin.cn/post/7217810344696954936#heading-9 "Golang调度器(5)—协作与抢占")
> 
> [深度解密 Go 语言之基于信号的抢占式调度](https://qcrao.com/post/diving-into-preempt-by-signal/ "深度解密 Go 语言之基于信号的抢占式调度")
> 
> [从源码剖析Go语言基于信号抢占式调度](https://juejin.cn/post/6944672255628541960?from=search-suggest "从源码剖析Go语言基于信号抢占式调度")
> 
> [英文博客](URL "英文博客")
> [英文博客](URL "英文博客")
> 