# Directory Structure
```
└─ DailyStudy                                                                    # No comment provided
    └─ basic                                                                       # 基础：存放基础语法及文件编写的模板
        |- markdown.md                                                               # md文件基础语法（不常见用法）
        |- template.md                                                                # # 一、如何设计友好的标识符
    |- changeCommit.sh                                                              #  changeCommit.sh
    └─ computer_installation                                                            # 硬件相关、包括电脑安装等
        |- memory.md                                                                #  [装机 | 配置升级] 内存篇
    |- directory.md                                                             #  Directory Structure
    |- generate_structure.sh                                                              # !/bin/bash
    └─ ideas                                                                         # 想法、思考：不能成文、篇幅小的
        |- 1、technology_ideas.md                                                 # No comment provided
        |- 2、product_ideas.md                                                    # No comment provided
    |- LICENSE                                                                            # IT License
    └─ miscellaneous_remarks                                                            # 杂谈：包括一些文章和博文
        └─ essay                                                                                  # 文章
            └─ cloud_native                                                                      # 云原生
                |- 1、云原生环境安装.md                                                  # No comment provided
                |- 2、云原生介绍.md                                                    # No comment provided
                |- 3、了解 IaaS、PaaS、SaaS、BaaS、FaaS？.md                 # # 三、了解 SaaS、PaaS、IaaS、BaaS、FaaS
            └─ go_basic                                                                        # Go 基础
                |- 1、泛型.md                                                       # No comment provided
                |- 2、defer延迟调用.md                                   # # 二、[Go基础] 一文讲透 Go 中的 defer 延迟调用
                |- 3、Slice.md                                         # # 三、[Go基础] Slice切片（文末附思维导图！！！）
                |- 4、Map.md                                                # # 四、[Go基础] 一文讲透 Go 中的 map
                |- 5、sync_map.md                                     # # 五、[Go基础] gopher不得不知的 sync.map
                |- 6、channel.md                                                  # No comment provided
                |- 7、流程控制语句select.md                                             # No comment provided
                |- 8、Go并发之sync包的应用.md                                            # No comment provided
            └─ go_super                                                                        # Go 进阶
                |- 1、内存对齐.md                                                     # No comment provided
                |- 2、GMP调度.md                                                    # No comment provided
                |- 3、内存管理.md                                                     # No comment provided
                |- 4、GC垃圾回收.md                                                            # # 一、GC垃圾回收
                |- 5、协程池的实现.md                                                                #  参考链接：
            └─ three_minute                                                                   # 3 分钟系列
                |- 1、如何设计友好的标识符.md                                               # No comment provided
                |- 2、耐看的注释都是如何被创造出来的.md                                                # # 二、如何编写优秀的注释
                |- 3、什么是好的包名.md                                                          # # 三、什么是好的包名
                |- 4、项目结构.md                                                                # # 四、项目结构
                |- 5、API设计.md                                                    # No comment provided
                |- 6、错误处理.md                                                                # # 六、错误处理
                |- 7、并发.md                                                                    # # 七、并发
                |- 8、Go字符串处理.md                                                         # # 八、Go 字符串处理
            └─ virtualization                                                                    # 虚拟化
                |- 1、虚拟化介绍.md                                                              # # 一、虚拟化介绍
        |- How_To_Ask_Question.md         # 原文地址](https://github.com/selfteaching/How-To-Ask-Questions-The-Smart-Way) | 
        |- How_To_Clean_Code.md                                                  # No comment provided
    └─ other                                                                                      # 其它
        └─ computer_usage_tips                                                                # 电脑使用技巧
            |- 1、长时间使用电脑如何防止眼睛干涩.md                                 # # 一、长时间使用电脑如何防止眼睛干涩（Windows暗夜模式）
        |- notesoft.md                                                                       #  效率软件选择
    └─ project                                                                               # 项目：项目示例
        |- main.go                                                                       # ackage main
    |- README.md                                                                         #  DailyStudy
    |- rename.sh                                                                            # !/bin/sh
    └─ skill_and_experience                                                # 技巧和经验：go的使用技巧和一些日常总结的使用经验
        └─ design_pattern                                                                       # 设计模式
            |- 1、函数选型模式.md                                                                # # 一、函数选项模式
            |- 2、单例模式.md                                                                    # # 一、单例模式
            |- 3、工厂模式.md                                                                    # # 一、工厂模式
            |- 4、DDD 领域驱动设计.md                                                   # No comment provided
        └─ experience                                                                             # 经验
            |- bug.md                                                                 #  [1. 空值异常](#1)
            |- go项目经验.md                                                                  # # 1、抽离公共方法
            |- mongodb查询优化.md                                                # # 1. MongoDB 大数据量分页查询优化
        |- linux.md                                                                   # ### Ubuntu 的安装
        └─ standard                                                      # 一些标准（提交、代码编写之前、代码编写、项目规划组织）
            |- 1、commit_standard.md                                                            #  what
            |- 2、go_code_standard.md                                                #  一、如何写出优雅的Go语言代码
            |- 3、pre_code_standard.md                                                           # # 前言
            |- 4、project_standard.md                                                            # # 前言
        |- the_odd_go.md                       # 突破go包结构访问权限，访问其它Go包中的私有函数](https://colobu.com/2017/05/12/call-private-functions-in-other-packages/)
    └─ technology                                                              # 技术：涉及到的相关技术，如mongodb等
        └─ Etcd                                                                                 # ETCD
            |- 1、Etcd 快速入门（官方文档）.md                                                    # # 一、Etcd 快速入门
            |- 2、Etcd 如何读取数据.md                                                  # No comment provided
            |- 3、Etcd 如何写入数据.md                                                  # No comment provided
        └─ MessageQueues                                                                        # 消息队列
            └─ 1、Kafaka                                                                       # Kafaka
                |- 1、消息队列扫盲.md                                                   # No comment provided
        └─ MongoDB                                                                           # MongoDB
            |- mongodb.md                                                             #  1、MongoDB基本介绍
            |- mongodb_go_driver.md                                                   #  [1. 命令使用](#1)
        └─ MySQL                                                                               # MySQL
            |- 1、MySQL技术内幕1-2章.md                                                # No comment provided
            |- 2、MySQL技术内幕3-4章.md                                                # No comment provided
            |- 3、MySQL技术内幕5（索引）.md                           #  MySQL技术内幕：InnoDB存储引擎 基于mysql 5.6 精华版总结
            |- 4、MySQL技术内幕6（锁）.md                            #  MySQL技术内幕：InnoDB存储引擎 基于mysql 5.6 精华版总结
            |- 5、MySQL技术内幕7（事务）.md                           #  MySQL技术内幕：InnoDB存储引擎 基于mysql 5.6 精华版总结
            |- 6、MySQL技术内幕8（备份与恢复）.md                        #  MySQL技术内幕：InnoDB存储引擎 基于mysql 5.6 精华版总结
            |- 7-1、MySQL性能优化之explain.md                                       # # 一、MySQL 性能调优之explain
            |- 7-2、MySQL性能优化之索引调优.md                                             # No comment provided
            |- 7-3、MySQL性能优化之SQL优化.md                                           # # 一、MySQL 性能调优之SQL优化
            |- 7-3、MySQL性能优化之连接池.md                                               # # 一、MySQL 性能调优之连接池
            |- 7-4、MySQL性能优化.md                                                       # # 一、MySQL 性能调优
            └─ article                                                             # 专项文章，专门针对某个细节写的文章
                |- 1、MySQL索引之or到底走不走索引.md                                        # No comment provided
                |- 2、一文讲穿MySQL.md                                                # No comment provided
            └─ MySQL 知识精炼                                                                 # MySQL 知识精炼
                |- 1、基础架构.md                                                     # No comment provided
        |- pdf.md                                                                   #  [1. PDF 前言](#1)
        └─ PostgreSQL                                                                # PostgreSQL 知识记录
            └─ 官方文档精炼                                                                         # 官方文档精炼
                |- 1、第11章：索引.md                                                   # # 一、PostgreSQL 之索引
        └─ Protobuf                                                                         # Protobuf
            |- 1、Protobuf 基本使用.md                                                # No comment provided
        └─ Redis                                                                               # Redis
            |- 1、Redis对象（一）.md                                                          # # 一、Redis 对象
            |- 2、Redis对象（二）.md                                                          # # 一、Redis 对象
            |- 3、Redis是怎么运作的.md                                                     # # 一、Redis 是怎么运作的
            |- 4、和客户端打交道.md                                                              # # 一、和客户端打交道
            |- 5、Redis数据丢弃怎么办.md                                                   # # 一、Redis 数据丢失怎么办
            |- 6、场景应用.md                                                        # # 一、场景应用（重点是缓存和分布式锁）
            |- redis.md                                                                  #  Redis 使用优化
    └─ utils                                                                            # 工具：日常使用的一些工具
        |- apidoc.md                                                               #  [apidoc 的使用](#1)
        |- cursor.md                                                             # No comment provided
        |- dlv+goland远程调试.md                                                      #  dlv + Goland 远程调试
        |- docker.md                                                             # No comment provided
        └─ Git                                                                              # Git 工具使用
            |- 1、GitHub 提交中如何展示账号头像及相关信息？.md                            # # 一、GitHub 提交中如何展示账号头像及相关信息？
            |- 7.11 Git Submodule.md                                             # No comment provided
            |- git.md                      # git中的各种撤销操作](https://segmentfault.com/a/1190000011910766)
        |- git.md                          # git中的各种撤销操作](https://segmentfault.com/a/1190000011910766)
    └─ wheels                                                                   # 轮子：使用的开发框架和组件，如gorm等
        |- 1、gorm.md                                                            #  [1.使用gorm的前置条件](#1)
        |- 2、msgp.md                                                                         #  msgp 库
        |- 3、wire.md                                                             # No comment provided
        |- 4、kratos.md                                                           # No comment provided
        └─ go                                                                         # Go 相关工具，包含标准库等
            |- 1、io.md                                                                       # # 1、io库
            |- 2、单元测试.md                                                         # No comment provided
        |- gorm.md                                                              #  [1.使用gorm的前置条件](#1)
        |- msgp.md                                                                           #  msgp 库
        |- wire.md                                                               # No comment provided
    └─ work_and_project_summary                                           # 工作和项目总结：以月和项目为单位总结自己的学习和成果
        └─ 2022                                                                  # No comment provided
            |- 2209-2305.md                                                      # No comment provided
        └─ 2023                                                                  # No comment provided
            |- 2305.md                                                           # No comment provided
```
