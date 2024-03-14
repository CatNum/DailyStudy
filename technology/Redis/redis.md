# Redis 使用优化

- 先获取所有待查询 hashKey，再使用 管道 pipeline 一次查询，来提高查询速度 
- `Redis`批量删除：`reids-cli keys "plugin:traffic_arrange*" |xargs redis-cli del `
