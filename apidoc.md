- [apidoc 的使用](#1)
  - [apidoc 的安装](#1.1)
  - [apidoc 配置文件](#1.2)
  - [apidoc 参数](#1.3)
  - [apidoc 技巧](#1.4)



参考文档：[apidoc教程](https://blog.csdn.net/qq_32352777/article/details/102746237)
 | [apidoc文档中文翻译](https://blog.csdn.net/hjh15827475896/article/details/79398369)
 | [apidoc的安装配置及使用](https://juejin.cn/post/6844903990606446605#heading-4)
 | [apidoc官方文档](https://apidocjs.com/#example-basic)

# <span id="1">apidoc</span>
## <span id="1，1">apidoc 的基本使用流程</span>
1. 安装nodejs
   1. 对nodejs进行环境配置：[node环境配置](https://blog.csdn.net/u012965203/article/details/97612935)
2. 安装apidoc
3. 创建apidoc配置文件
4. 添加注释
5. 使用`apidoc -c [配置文件地址] -i [项目地址] -o [文件输出地址] `生成apidoc文件夹
## <span id="1，2">apidoc 配置文件</span>
需要配置apidpc.json
## <span id="1，3">apidoc 注释</span>
apidoc 注释可以卸载api接口上方，也可以专门写一个后缀为.js的文件
官方的example.js
```js
/**
 * @api {get} /user/:id Request User information[接口描述]
 * @apiName GetUser[接口名]
 * @apiGroup User[接口组]
 *
 * @apiParam {Number} id Users unique ID.[接口入参]
 *
 * @apiSuccess {String} firstname Firstname of the User.[成功返回参数]
 * @apiSuccess {String} lastname  Lastname of the User.[成功返回参数]
 *
 * @apiSuccessExample Success-Response:[成功返回样例]
 *     HTTP/1.1 200 OK
 *     {
 *       "firstname": "John",
 *       "lastname": "Doe"
 *     }
 *
 * @apiError UserNotFound The id of the User was not found.[错误样例]
 *
 * @apiErrorExample Error-Response:[错误返回样例]
 *     HTTP/1.1 404 Not Found
 *     {
 *       "error": "UserNotFound"
 *     }
 */
```

## <span id="4">apidoc 技巧</span>

```text
①apidoc注释一般书写位置：控制器，即对外的接口，接受参数和返回响应的接口
②和其它注释不会冲突，一般先写apidoc注释，再写其它注释，其它注释信息不会展示在apidoc文档中
③可以直接在注释中放json，通过@apiSuccessExample {json}参数，显示更直接
④如果参数和返回值中存在层级关系，则参考对象的方式，用"."连接，示例： person.age
```

