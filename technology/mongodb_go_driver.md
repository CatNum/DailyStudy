- [1. 命令使用](#1)
    - [1.1 Find](#1.1)
- [2. 关键字使用](#2)
    - [2.1 Regex模糊查询](#2.1)

### <span id="1">1. 命令使用</span>

#### <span id="1.1">1.1 Find</span>

```go
package main

func (a *Model) GetLog(ctx *gin.Context, req types.LogReq) (int64, []pkg_models.Log, error) {
	// 获取指定记录
	filter := bson.D{}
	if req.Name != "" {
		filter = append(filter, bson.E{pkg_models.TableTagLogRecoder.Name, req.SourceIp})
	}
	filter = append(filter, bson.E{
		pkg_models.TableTagLogRecoder.OccurrenceTime, bson.D{
			{Gte, req.StartTime},
			{Lte, req.EndTime},
		},
	})
	logList := make([]pkg_models.Log, 0)
	findOpt := options.Find()
	findOpt.SetSort(bson.D{{pkg_models.TableTagLogRecoder.OccurrenceTime, -1}}) // pkg_models.TableTagLogRecoder.OccurrenceTime = "occurrenceTime"
	findOpt.SetSkip(int64((req.PageNum - 1) * req.PageSize))
	findOpt.SetLimit(int64(req.PageSize))
	//skip := int64((req.PageNum - 1) * req.PageSize)
	//limit := int64(req.PageSize)
	//sort := bson.E{pkg_models.TableTagLogRecoder.OccurrenceTime, -1}  //sort 这里老是报语法错误,使用上面的形式
	//findOpt := &options.FindOptions{Sort: sort, Skip: &skip, Limit: &limit}
	cur, err := a.coll.Find(ctx, filter, findOpt)
	if err != nil {
		return 0, nil, err
	}
	err = cur.All(ctx, &logList)
	if err != nil {
		return 0, nil, err
	}

	return total, logList, nil
}
```

### <span id="2">2. 关键字使用</span>

#### <span id="2.1">2.1 Regex模糊查询</span>

错误用法：

```go

package main

func GetLog(req types.RoutingAccessTotalLogReq) () {
	filter := bson.D{}

	if req.Route != "" {
		// 错误写法
		filter = append(filter, bson.E{pkg_models.TableTagRouteRecord.Route, bson.E{types2.Regex, ".*" + req.Route + ".*"}})
		// 正确写法
		filter = append(filter, bson.E{pkg_models.TableTagRouteRecord.Route, primitive.Regex{Pattern: ".*" + req.Route + ".*"}})
	}
	if req.Path != "" {
		// 错误写法
		filter = append(filter, bson.E{pkg_models.TableTagRouteRecord.PathMatch, bson.E{types2.Regex, ".*" + req.Path + ".*"}})
		// 正确写法
		filter = append(filter, bson.E{pkg_models.TableTagRouteRecord.PathMatch, primitive.Regex{Pattern: ".*" + req.Path + ".*"}})
	}

	coll := client.Database("sample_restaurants").Collection("restaurants")
	cursor, err := coll.Find(context.TODO(), filter)
	if err != nil {
		
	}
	err = cursor.All(ctx,&str)   // str 为对应结构体的对象
	if err != nil {
		
    }

}


```