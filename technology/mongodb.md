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

db.getCollection('api-access-log').find({request_time:{$gt:new Date('2023-06-29'),$lt:new Date('2023-06-30')}},{engine_uid:"SN10141IKZ40"}).hint("request_time-1_incr_id_-1").sort({"request_time":-1},{"incr_id":-1}).allowDiskUse()

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
# 批量写,可以使用insertOne(),updateOne(),deleteOne()等函数对文档进行批量修改.
# 有两种方式：1）无序，即其中的函数无序执行，某个函数报错之后，其余的函数继续执行；2）有序，函数顺序执行，遇报错则停止执行。无序的比有序的效率高
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

TTL 索引是特殊的单字段索引。MongoDB 可以使用它在**一定时间**或**特定时钟时间**后自动从集合中删除文档。 TTL仅支持单字段索引，且不能是_id字段，且字段需为date类型或者含date类型的数组。

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

# 9、Time Series(时间序列集合)

时间序列数据总是包含以下三个组成部分：1）Time：数据节点被记录的时间 2）Metadata：这是一个唯一标识一个序列的label或者tag，它很少改变 3）Measurements：这是在时间增量上跟踪的数据点，一般来说是随时间改变的
key-value 对。

时间序列数据示例：

| Example | Measurement | Metadata    |
|---------|-------------|-------------|
| 股票数据    | 股票价格        | 股票代码，交易所    |
| 天气数据    | 温度          | 传感器标识符，地理位置 |
| 网站访客    | 访问数量        | URL         |

为了有效地存储时间序列数据，MongoDB提供了时间序列集合。

## 9.1 Time Series（时间序列）

### 9.1.1 Time Series Collections（时间序列集合）

在时间序列集合中，数据的存储是有组织的，来自同一个source的数据和其它相同时间点的数据存储在一起

### 9.1.2 Benefits（好处）

与普通集合相比，在时间序列集合中存储时间序列数据可以提高查询效率，减少时间序列数据和二级索引的磁盘使用。

时间序列集合使用底层的列式存储格式，并以时间顺序存储数据，并自动创建聚类索引。列式存储格式提供了以下好处

- 1）降低处理时间序列程序的复杂性
- 2）提高查询效率
- 3）减少磁盘使用
- 4）读操作时，减少io
- 5）增加 WiredTiger cache 使用

### 9.1.3 Behavior（行为）

时间序列集合和普通集合相似，你可以像普通集合一样插入和查询。

MongoDB 将时间序列集合视为由内部集合支持的可写非物化视图。 当你插入数据时，内部集合会自动将时间序列数据组织成优化的存储格式。
当你查询时间序列集合时，您对每个测量操作一个文档。对时间序列集合的查询利用优化的内部存储格式并更快地返回结果。

#### 9.1.4 Internal Index（内部索引）

当创建时间序列集合的时候，MongoDB自动在 time 字段上创建一个内部 clustered index，该索引可以提供性能优势，比如提高查询效率以及
减少磁盘使用。使用 [listIndexes](https://www.mongodb.com/docs/manual/reference/command/listIndexes/#mongodb-dbcommand-dbcmd.listIndexes)
该内部索引不会被展示.

## 9.2 Create and Query a Time Series Collection（创建、查询）
在你向时间序列集合中插入一条数据之前，你必须显式的创建该集合

### 9.2.1 Create a Time Series Collection（创建时间序列集合）

#### timeseries Object Fields
创造一个时间序列集合的时候，需要指定以下选项：

| Field                  | Type   | Description                                                                                                                                                                                                                                                |
|------------------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| timeseries.timeField   | string | 必需的。每个时间序列文档中包含日期的字段的名称。时间序列集合中的文档必须有一个有效的 BSON 日期作为 timeField 的值。                                                                                                                                                                                         |
| timeseries.metaField   | string | 选修的。每个时间序列文档中包含元数据的字段名称。指定字段中的元数据应为用于标记一系列文档的数据。元数据应该很少发生变化。该字段不能是_id,也不能跟timeField相同，但是可以是任意类型。                                                                                                                                                           |
| timeseries.granularity | string | 选修的。可以是"seconds"、"minutes"、"hours"。默认是"seconds"。手动设置该参数，可以通过优化数据在内部的存储方式来提高性能。推荐选择与连续传入的测量结果的时间建个最匹配的选项。如果指定 timeseries.metaField，请考虑 metaField 字段具有相同唯一值的连续传入测量之间的时间跨度。如果测量来自相同的源，metaField 字段通常具有相同的唯一值。如果不指定 timeseries.metaField，请考虑插入集合中的所有测量之间的时间跨度。 |
| expireAfterSeconds     | number | 选修的。通过指定文档过期的秒数，启用时间序列集合中文档的自动删除。 MongoDB 会自动删除过期的文档。有关详细信息，请参阅设置时间序列集合 (TTL) 的自动删除。                                                                                                                                                                       |
其它可用的选型：storageEngine、indexOptionDefaults、collation、writeConcern、comment。详细信息需要查看db.createCollection()函数介绍。

### 9.2.2 Insert Measurements into a Time Series Collection（插入）
插入的每个文档都应包含一个测量值。

### 9.2.3 Query a Time Series Collection（查询）
时间序列集合的查询跟标准的集合查询方式一样。额外的查询功能的实现可以使用聚合管道实现。

## 9.3 List Time Series Collections in a Database（展示集合）
To list all time series collections in a database, use the listCollections command with a filter for { type: "timeseries" }:
```shell
db.runCommand( {
   listCollections: 1,
   filter: { type: "timeseries" }
} )
```

## 9.4 Set up Automatic Removal for Time Series Collections (TTL)（设置自动删除）
当你创建一个时间序列集合，你可以使用 `expireAfterSeconds ` 参数设置文档在超过指定时间知道后过期自动删除。
