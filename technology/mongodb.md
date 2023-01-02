# 1、MongoDB基本介绍

## 1.1 MongoDB存储

MongoDB是一款文档数据库，文档的存储格式是BSON，是一种类似JSON的文档形式。

MySQL及MongoDB术语对应关系如下：

| MySQL | MongoDB           |
|-------|-------------------|
| 数据库   | 数据库               |
| 表     | 集合                |
| 记录（行） | 文档                |
| 列     | 字段（key-value形式）   |

主键：_id，唯一主键，如果不指定，MongoDB会自动生成。
# 2、MongoDB shell
## 2.1 常用 shell
```shell
db        # 显示当前数据库
show dbs  # 展示所有数据库
show collections  # 展示当前数据库所有的集合
use test          # 切换数据库为 test
```

## 2.2 MongoDB operators
### 1）Query and Projection Operators
1.1 Comparison Query operators(比较查询操作符)

| 操作符  | 作用  |
|------|-----|
| $eq  | =   |
| $gt  | ＞   |
| $gte | ＞=  |

1.2 Logical Query Operators

| 操作符  | 作用  |
|------|-----|
| $and | 和   |
| $or  | 或   |

1.3 Element Query Operators

| 操作符       | 作用       |
|-----------|----------|
| $exists   | 查询存在的    |
| **$type** | 查询指定类型字段 |

### 2) Update Operators(更新操作符)

更新操作使用的操作符。

### 3) Aggregation Pipeline Stages(聚合管道阶段)

| 阶段操作符    | 阶段含义                 |
|----------|----------------------|
| $group   | 根据指定字段分组             |
| $limit   | 限制查询数量               |
| $match   | 匹配规则（一般作为第一个阶段）      |
| $set     | 设置新字段                |
| $sort    | 排序                   |
| $project | 映射，对字段进行计算或者控制字段是否输出 |

### 4) Aggregation Pipeline Operators(聚合管道操作符)

| 操作符  | 作用                               |
|------|----------------------------------|
| $add | 加和，将同一个文档的两个字段的值相加               |
| $gte | ＞=                               |
| $lte | ＜=                               |
| $max | 取最大值                             |
| $sum | 计算数组的和，将多个文档相同字段进行求和，一般用于group之后 |

## 2.3 增删改查 shell

```shell
# 插入
# 如果该集合不存在，插入操作会创建该集合。如果该数据库也不存在，同样也会创建数据库。
db.coll.insertOne( { x: 1 } )   # 往coll集合中插入单条记录
db.coll.insertMany([            # 往coll集合中插入多条记录
  { x: 1 },
  { y: 1 }
])
# 查询
db.coll.find()      # 查询coll集合中所有的记录
db.coll.find( { "x": 1 } )    # 查询coll集合中 x = 1 的所有的记录
# 使用查询操作符
db.inventory.find( { qty: { $eq: 20 } } )     # 使用 $eq 操作符
db.inventory.find( { qty: 20 } )              # 不使用 $eq 操作符
db.inventory.find( { $or: [ { quantity: { $lt: 20 } }, { price: 10 } ] } )    # 使用 $or 操作符
# 修改
db.collection.updateOne()
db.collection.updateMany()
db.collection.replaceOne()
# 删除
db.inventory.deleteOne( { status: "D" } )
db.inventory.deleteMany()
db.inventory.deleteMany({})
# bulk write
# 批量写,可以使用insertOne(),updateOne(),deleteOne()等函数对温暖当进行批量修改.
# 有两种方式，一种是无序的，即其中的函数无序执行，某个函数报错之后，其余的函数继续执行；一种是有序的，函数顺序执行，遇报错则停止执行。无序的比有序的效率高
```
# 5、MongoDB 聚合
聚合就是一个管道，管道由一个及以上阶段构成，每个阶段有一个输入和输出，上一个管道的输出作为下一个管道的输入。
```shell
# 聚合
db.ntlv.aggregate(
    {"match":{
        "date.value":{
            "$gte":1672106400,
            "$lte":1672110000
        },
        "app_info.name":"民有"
    }},
    {"$group":{
        "_id":"$date.value",
        "frontend_connection_count":{
            "$max":"$cluster_stat_indicator.frontend_connection_count"
        },
        "backend_connection_count":{
            "$max": "$cluster_stat_indicator.backend_connection_count"
        },
        "frontend_new_connection_count":{
            "$sum": "$cluster_stat_indicator.frontend_new_connection_count"
        },
        "backend_new_connection_count":{
            "$sum": "$cluster_stat_indicator.backend_new_connection_count"
        }
    }},
    {"$project":{
        "_id":0,
        "time_stamp": "$_id",
        "app_name": "$app_info.name",
        "connection_sum":{
            "$add":["$frontend_connection_count", "$backend_connection_count"]
        },
        "connection_add":{
            "$add":["$frontend_new_connection_count", "$backend_new_connection_count"]
        }
    }}
)
```
# 6、MongoDB 索引
## 6.1 Single Field Indexes(单一索引)

单字段索引。索引的排序无关紧要，因为 MongoDB 可以在任意方向上遍历索引。

## 6.2 Compound Indexes(复合索引)

复杂索引。索引字段的顺序大多数遵循 相等性、排序、范围 来创建。

索引匹配遵循最左前缀匹配原则。**索引字段的升序和降序影响排序是否走索引**，例如创建name升序-age降序的组合索引，
当遇到name升序-age降序的查询和name降序-age升序的查询都可以走索引，而遇到name升序-age升序或者name降序-age降序的查询时则无法走索引。
即查询的每个字段顺序必须要与索引排序一致或都相反，这样MongoDB会选择从正向遍历索引或者反向遍历索引从而走索引查询。

## 6.3 TTL（Time To Live）索引

TTL 索引是特殊的单字段索引。MongoDB 可以使用它在**一定时间**或**特定时钟时间**后自动从集合中删除文档。
TTL仅支持单字段索引，且不能是_id字段，且字段需为date类型或者含date类型的数组。

支持将一个非TTL的单一索引转换为TTl索引；支持更改TTL索引过期时间。

TTL索引文档在指定字段的值加上指定的过期时间（秒数）之后过期。1）如果指定字段为一个数组，将使用数组中最早的date值去计算；2）如果字段不是一个date或者是一个不含
date的数组，则文档永不过期；3）如果某文档不包含该索引字段，则文档永不过期。

文档过期时间可能和 MongoDB 从数据库中删除记录的时间是不一致的。MongoDB的后台任务每60s运行一次。


## 6.4 索引相关shell
```shell
# 索引
db.coll.createIndex( { score: 1 } )
db.coll.createIndex( { "lastModifiedDate": 1 }, { expireAfterSeconds: 3600 } )  # 创建TTL索引并设置过期时间
db.coll.getIndexes()
db.pets.dropIndex( "catIdx" )
db.coll.dropIndexes()         # 删除所有索引
```

# 7、MongoDB官方文档

[MongoDB官方文档](https://www.MongoDB.com/docs/v6.0/)

```
|—MongoDB Shell(mongosh)                    # shell
|—MongoDB CRUD Operators                    # crud 操作
|—Aggregation Operators                     # 聚合操作
|—Reference                                 # 参考
|  |—Operators                              # 操作符
└─Technical Support                         # 技术支持
```

# 8、MongoDB compass
MongoDB 官方可视化工具