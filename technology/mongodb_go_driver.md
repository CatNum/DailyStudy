- [1. 命令使用](#1)
    - [1.1 Find](#1.1)

### <span id="1">命令使用</span>

#### <span id="1.1">Find</span>

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
	findOpt.SetSort(bson.D{{pkg_models.TableTagLogRecoder.OccurrenceTime, -1}})
	findOpt.SetSkip(int64((req.PageNum - 1) * req.PageSize))
	findOpt.SetLimit(int64(req.PageSize))
	//skip := int64((req.PageNum - 1) * req.PageSize)
	//limit := int64(req.PageSize)
	//sort := bson.E{pkg_models.TableTagAccessControlPluginRecord.OccurrenceTime, -1}  //sort 这里老是报语法错误,使用上面的形式
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