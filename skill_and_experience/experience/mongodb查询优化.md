## 1. MongoDB 大数据量分页查询优化

文章：https://zhuanlan.zhihu.com/p/535496767

利用 有序id(确定其实查询位置) + skip 提高查询速度

存在问题：当数据有一定量级，利用搜索进行查询，查询的数据占总量很少甚至没有数据，则查询很慢(会扫描全部数据)


## 2. MongoDB 数据删除

根据过滤条件获取 id切片，然后根据 id 进行删除。注意需要**分片删除**，比如每次删除一万条。