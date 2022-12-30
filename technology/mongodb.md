1、Mongodb基本介绍

1.1 Mongodb存储

MySQL及MongoDB术语对应关系如下：

| MySQL | MongoDB           |
|-------|-------------------|
| 数据库   | 数据库               |
| 表     | 集合                |
| 记录（行） | 文档                |
| 列     | 字段（key-value形式）   |

主键：_id，唯一主键，如果不指定，MongoDB会自动生成。


2、mongodb shell

mongodb operators：

1）Query and Projection Operators

1.1 Comparison Query operators(比较查询操作符)

e.g. $eq $gt $gte ...

1.2 Logical Query Operators

e.g. $and $or ...

1.3 Element Query Operators

e.g. $exists **$type**

2) Update Operators(更新操作符)

更新操作使用的操作符。

3) Aggregation Pipeline Stages(聚合管道阶段)

e.g. $group $limit $match $project $set $sort

4) Aggregation Pipeline Operators(聚合管道操作符)

e.g. $add $gte $lte $max $sum

使用 mongosh 进入shell操作界面。

```shell
db        # 显示当前数据库
show dbs  # 展示所有数据库
show collections  # 展示当前数据库所有的集合
use test          # 切换数据库为 test
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
# 查询操作符
db.inventory.find( { qty: { $eq: 20 } } )     # 使用 $eq 操作符
db.inventory.find( { qty: 20 } )              # 不使用 $eq 操作符
db.inventory.find( { $or: [ { quantity: { $lt: 20 } }, { price: 10 } ] } )    # 使用 $or 操作符
# 删除
# 修改
# 聚合
# 索引
db.coll.
db.coll.createIndex( { "lastModifiedDate": 1 }, { expireAfterSeconds: 3600 } )  # 创建TTL索引并设置过期时间
```

3、mongodb compass

4、mongodb 增删改查

5、mongodb 聚合

6、mongodb 索引

TTL索引： 设置记录自动过期。

1）指定某段时间之后过期。2）指定在某个时间点之后过期。

7、mongodb 事务
