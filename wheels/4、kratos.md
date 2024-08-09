
## 一、Kratos 框架

### 1、设计理念

- 不限制使用任何第三方库
- DDD 和 Clean Architecture

组件：

- CLI 工具：用于从模板创建项目
- 使用 Protobuf 定义 API
  - 默认仅生成 gRPC 接口的代码；如果需要生成 HTTP 代码，请在 proto 文件中使用 option (google.api.http) 来添加 HTTP 部分的定义后再进行生成。（HTTP 接口默认使用 JSON 作为序列化格式，可以参考[序列化](https://go-kratos.dev/docs/component/encoding/)配置）
  - 这种方式可靠性更强，但是字段结构灵活性相比 JSON 较差，诸如文件上传接口，可以参考[upload 例子](https://github.com/go-kratos/examples/blob/main/http/upload/main.go)，来实现普通的 http.Handler 接口 并 挂载到路由上
- 服务之间的元数据传递，参考[元数据传递](https://go-kratos.dev/docs/component/metadata)
- 错误处理：[error 模块](https://github.com/go-kratos/kratos/tree/main/errors)
- 配置文件
- 服务注册和服务发现
- 日志
- 监控
- 链路追踪
- 负载均衡
- 限流熔断
- 中间件
- 插件