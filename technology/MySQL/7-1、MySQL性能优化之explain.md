## 一、MySQL 性能调优

### 1.1 explain 语句

三个重要的字段：type、key、extra。

#### 1.1.1 type

EXPLAIN 输出的 type 列描述了**表的连接方式**。在 JSON 格式的输出中，这些内容作为 access_type
属性的值。下面的列表描述了连接类型，从最好的类型到最差的类型排序：

| 类型              | 描述                                                                                    |
|-----------------|---------------------------------------------------------------------------------------|
| system          | 表只有一行记录（等于系统表），这是 const 类型的特例，平时不会出现，不需要进行磁盘 io                                       |
| const           | 最多只能匹配到一条数据，通常使用主键或唯一索引进行等值条件查询                                                       |
| eq_ref          | 当进行等值联表查询使用主键索引或者唯一性非空索引进行数据查找 (实际上唯一索引等值查询 type 不是 eq_ref 而是 const)                  |
| **ref**         | 使用了非唯一性索引进行数据的查找                                                                      |
| fulltext        | 使用 FULLTEXT 索引执行连接。                                                                   |
| ref_or_null     | 对于某个字段即需要关联条件，也需要 null 值的情况下，查询优化器会选择这种访问方式                                           |
| **index_merge** | 该连接类型表明使用了索引合并优化                                                                      |
| unique_subquery | unique_subquery 只是一个索引查找功能，完全替代子查询以提高效率。                                              |
| index_subquery  |                                                                                       |
| **range**       | 使用索引来选择行，仅检索给定范围内的行。当使用 = 、 <> 、 > 、 >= 、 < 、 <= 、 IS NULL 、 <=> 、 BETWEEN 、 LIKE 运算符 |
| **index**       | 全索引扫描这个比 all 的效率要好，主要有两种情况，一种是当前的查询时覆盖索引，即我们需要的数据在索引中就可以索取，或者是使用了索引进行排序，这样就避免数据的重排序   |
| **ALL**         | 全表扫描，需要扫描整张表，从头到尾找到需要的数据行。一般情况下出现这样的 sql 语句而且数据量比较大的话那么就需要进行优化。                       |

ref_or_null 的情况：

```text
SELECT * FROM ref_table
  WHERE key_column=expr OR key_column IS NULL;
```

#### 1.1.2 key

key 列表示MySQL实际决定使用的键（索引）。

除了参考文章《MySQL通过explain分析时，possible_keys为null,key为所建索引的原因》中的情况，如下情况也会出现 possible_key 为空，但是
key 存在值的情况（版本 5.7.38）：

![img.png](picture/7-1）1.1.2-1.png)
![img_1.png](picture/7-2）1.1.2-2.png)
![img_2.png](picture/7-3）1.1.2-3.png)

这种情况一般发生在覆盖索引条件下，possible_keys为null说明用不上索引的树形查找，但如果二

级索引包含了所有要查找的数据，二级索引往往比聚集索引小，所以mysql可能会选择顺序遍历这个二

级索引直接返回，但没有发挥树形查找优势，所以就出现了这个情况。

#### 1.1.3 extra

EXPLAIN 输出的 Extra 列包含有关 MySQL 如何解析查询的附加信息。

| 字段                        | 描述                                                                                                   |
|---------------------------|------------------------------------------------------------------------------------------------------|
| using filesort            | 利用排序算法进行排序，会消耗额外的位置                                                                                  |
| using temporary           | 建立临时表来保存中间结果                                                                                         | 
| using index               | 这个表示当前的查询是**覆盖索引**的，直接从索引中读取数据，而不用访问数据表。如果同时出现 using where 表名索引被用来执行索引键值的查找，如果没有，表面索引被用来读取数据，而不是真的查找 | 
| Using index condition     | 索引下推优化                                                                                               | 
| Using index for group-by  | 与 Using index 表访问方法类似，是覆盖索引的，不需要额外访问实际行                                                              | 
| Using index for skip scan | 表示使用“跳过扫描”访问方法                                                                                       | 
| Using MRR                 | 使用多范围读取优化策略读取表                                                                                       | 
| using where               | 使用 where 进行条件过滤                                                                                      | 
| using join buffer         | 使用连接缓存                                                                                               | 
| impossible where          | where 语句的结果总是 false                                                                                  | 

对于 using index ：对于具有用户定义的聚集索引的 InnoDB 表，即使 Using index 不存在于 Extra 列中，也可以使用该索引。如果 type
是 index 且 key 是 PRIMARY ，就是这种情况。

> 参考链接：
>
> [一文详解Mysql优化中explain各字段含义](https://learnku.com/articles/60919 "一文详解Mysql优化中explain各字段含义")
>
> [10.8.2 解释输出格式](https://dev.mysql.com/doc/refman/8.0/en/explain-output.html "10.8.2 解释输出格式")
>
> [MySQL通过explain分析时，possible_keys为null,key为所建索引的原因](https://blog.csdn.net/eden_Liang/article/details/108026148 "MySQL通过explain分析时，possible_keys为null,key为所建索引的原因")
>
> [MySQL之explain extra字段解析](https://www.modb.pro/db/409873 "MySQL之explain extra字段解析")