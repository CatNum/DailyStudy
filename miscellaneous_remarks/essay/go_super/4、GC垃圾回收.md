## 一、GC垃圾回收

## 1、参考文章

> 参考链接：
>
> [Golang垃圾回收三色标记原理详解🤣](https://juejin.cn/post/7304268951315415090#heading-9 "Golang垃圾回收三色标记原理详解🤣")
> 
> [[Golang三关-典藏版] Golang三色标记混合写屏障GC模式全分析](https://learnku.com/articles/68141 "[Golang三关-典藏版] Golang三色标记混合写屏障GC模式全分析")
> 
> [28 内存回收下篇：三色标记-清除算法是怎么回事？](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/%E9%87%8D%E5%AD%A6%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F-%E5%AE%8C/28%20%20%E5%86%85%E5%AD%98%E5%9B%9E%E6%94%B6%E4%B8%8B%E7%AF%87%EF%BC%9A%E4%B8%89%E8%89%B2%E6%A0%87%E8%AE%B0-%E6%B8%85%E9%99%A4%E7%AE%97%E6%B3%95%E6%98%AF%E6%80%8E%E4%B9%88%E5%9B%9E%E4%BA%8B%EF%BC%9F.md "28 内存回收下篇：三色标记-清除算法是怎么回事？")
> 
> [英文博客](URL "英文博客")
> [英文博客](URL "英文博客")


垃圾收集(Garbage Collection，简称GC)，是现代编程语言提供的内存管理功能，能够自动释放不需要的内存对象，
而不用程序员手动显式释放，从而提高开发效率，并降低内存泄漏的风险。

Go语言具有自己的垃圾收集器，并在多个版本不断演进优化:

- V1.3 及之前：标记清除算法
- V1.5：三色并发标记法
- V1.8：混合写屏障机制

**标记清除算法**

1. STW 暂停程序业务逻辑
2. 标记可达对象
3. 清除不可达对象
4. 停止 STW ，让程序业务逻辑继续跑

优点：

- 除算法明了，过程鲜明干脆

缺点：

- STW，stop the world；让程序暂停，程序出现卡顿 (重要问题)；
- 标记需要扫描整个 heap；
- 清除数据会产生 heap 碎片。

Go V1.3 做了简单的优化，将 STW 的步骤提前（标记完，清除前停止 STW），减少 STW 暂停的时间范围。

**三色标记法**

1. 全部对象默认为 白色
2. 从根节点开始遍历，遍历到的第一层可达对象标记为 灰色
3. 遍历灰色集合，将灰色对象引用的对象标记为灰色，将本身标记为黑色
4. 重复第三步，直到没有灰色对象
5. 回收所有白色对象（垃圾）

上述步骤仍然需要 STW。我们在开始三色标记之前就会加上 STW，在扫描确定黑白对象之后再放开 STW。

有两种情况，在三色标记法中，是不希望被发生的。

- 条件 1: 一个白色对象被黑色对象引用 (白色被挂在黑色下)
- 条件 2: 灰色对象与它之间的可达关系的白色对象遭到破坏 (灰色同时丢了该白色)。

如果当以上两个条件同时满足时，就会出现对象丢失现象！

**屏障机制**

**强三色不变式**：不允许黑色对象引用白色对象

**弱三色不变式**：所有被黑色对象引用的白色对象都处于灰色保护状态。需要确保黑色对象引用的白色对象有其他的灰色对象可以到达。

**插入写屏障**

**具体操作:** 在 A 对象引用 B 对象的时候，B 对象被标记为灰色。(将 B 挂在 A 下游，B 必须被标记为灰色)

**满足:** 强三色不变式. (不存在黑色对象引用白色对象的情况了， 因为白色会强制变成灰色)

缺点：“插入屏障” 机制，在**栈空间的对象操作中不使用. 而仅仅使用在堆空间对象的操作中**，所以栈在准备回收白色之前需要 STW
再扫描一遍。

**删除写屏障**

**具体操作:** 被删除的对象，如果自身为灰色或者白色，那么被标记为灰色。

**满足:** 弱三色不变式. (保护灰色对象到白色对象的路径不会断)

缺点：这种方式的**回收精度低**，一个对象即使被删除了最后一个指向它的指针也依旧可以活过这一轮，在下一轮 GC 中被清理掉。

**Go V1.8 的混合写屏障 (hybrid write barrier) 机制#**

**具体操作:**

1. GC 开始将**栈上的对象**全部扫描并标记为黑色 (之后不再进行第二次重复扫描，无需 STW)，
2. GC 期间，任何在**栈上创建的新对象**，均为黑色。
3. 被删除的对象标记为灰色。
4. 被添加的对象标记为灰色。

**满足:** 变形的弱三色不变式.

混合写屏障也是只作用与堆，不作用在栈上

Golang 中的混合写屏障满足弱三色不变式，结合了删除写屏障和插入写屏障的优点，只需要在开始时并发扫描各个 goroutine
的栈，使其变黑并一直保持，这个过程不需要 STW，而标记结束后，因为栈在扫描后始终是黑色的，也无需再进行 re-scan
操作了，减少了 STW 的时间。

**垃圾回收触发时机**

- 每次内存分配时都会检查当前内存分配量是否已达到阈值，如果达到阈值则立即启动 GC。内存增长率由**环境变量 GOGC** 控制，**默认为
  10**0，即每当**内存扩大一倍时**启动 GC。阀值 = 上次GC内存分配量 * 内存增长率
- 默认情况下，**最长 2 分钟**触发一次 GC。
- 程序代码中也可以使用 **runtime.GC() 来手动触发 GC**。这主要用于 GC 性能测试和统计。



