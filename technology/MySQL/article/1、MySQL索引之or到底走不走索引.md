

1. 确保 or 两边都是索引
2. 确保字段的区分度足够大

> 参考链接：
>
> [MySQL中， in和or 会走索引吗](https://developer.aliyun.com/article/1172777 "MySQL中， in和or 会走索引吗")
> 
> [索引失效有哪些？](https://xiaolincoding.com/mysql/index/index_lose.html "索引失效有哪些？")


null 走不走索引
我觉得这一点还是跟优化器有关系，要看优化器的成本是怎么计算的


> 参考链接：
>
> [10｜数据库索引：为什么MySQL用B+树而不用B树？](https://leeshengis.com/archives/672553 "10｜数据库索引：为什么MySQL用B+树而不用B树？")
>
> [(五)MySQL索引应用篇：建立索引的正确姿势与使用索引的最佳指南！](https://juejin.cn/post/7149074488649318431 "(五)MySQL索引应用篇：建立索引的正确姿势与使用索引的最佳指南！")
> 
> [(十七)SQL优化篇：如何成为一位写优质SQL语句的绝顶高手！](https://juejin.cn/post/7164652941159170078 "(十七)SQL优化篇：如何成为一位写优质SQL语句的绝顶高手！")


索引失效的场景，以及为什么失效？

当前网络资料整理出来的索引失效的场景，其实直接说出来，是不对的。

因为有些所谓的失效场景其实并不是绝对的，要看具体的 SQL 语句和表数据、表结构等等

其实索引失效的本质就是执行成本的高低，优化器会选择一个执行成本较低的执行计划。而网上所谓的失效场景，都是对这一规则的经验化总结，
但是针对具体的场景还是需要具体分析。（比如上文中的 or 和 null）

> 参考链接：
> 
> [11 索引出错：请理解 CBO 的工作原理](https://learn.lianglianglee.com/%E4%B8%93%E6%A0%8F/MySQL%E5%AE%9E%E6%88%98%E5%AE%9D%E5%85%B8/11%20%20%E7%B4%A2%E5%BC%95%E5%87%BA%E9%94%99%EF%BC%9A%E8%AF%B7%E7%90%86%E8%A7%A3%20CBO%20%E7%9A%84%E5%B7%A5%E4%BD%9C%E5%8E%9F%E7%90%86.md "11 索引出错：请理解 CBO 的工作原理")
