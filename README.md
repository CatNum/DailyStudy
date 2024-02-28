# DailyStudy

# 项目经验

对于 work_and_project_summary 目录，需要在**每个小需求结束之后**及**每次项目版本结束之后**，对所做的需求进行总结。

- 需求分析阶段：需求是什么？需求是否合理？有没有争议点？产品如何考虑？
- 技术设计阶段：现有项目及技术对于需求是否支持？工期估算是否准确？如果现有技术不支持，预研是如何做的？
- 开发阶段：在开发过程中遇到了哪些问题（小问题也是问题！）？如何解决？
- 联调：联调遇到的问题？与我对接的人对我的对接文档有哪些疑惑（即我的文档有哪些没写清楚）？
- 测试阶段：bug产生的原因？如何修复？

```
|─basic                                 # 基础：存放基础语法及文件编写的模板
    |-markdown.md                           # md文件基础语法（不常见用法）
    |-template.md                           # md文件编写的模板 
|─computer_installation                 # 电脑装机：电脑装机的知识
    |-memory.md                           # 内存篇
|─ideas                                 # 想法、思考：不能成文、篇幅小的   
|─miscellaneous_remarks                 # 杂谈：包括一些文章和博文
    |-essay                                 # 文章
        |-cloud_native                          # 云原生 
        |-go_basic                              # go基础 
        |-go_super                              # go进阶 
        |-three_mintue                          # 三分钟 
        |-virtualization                        # 虚拟化 
    |-How_To_Clean_Code.md                  # 如何写干净的代码
    |-GoPractice.md                         # Go最佳实践
    |-How_To_Ask_Question.md                # 如何问问题
|—other                                 # 其它：技术之外的相关记录
    |-notesoft.md                           # 笔记选择
    |-computer_usage_tips                   # 电脑使用技巧
|—project                               # 项目：项目示例
|—skill_and_experience                  # 技巧和经验：go的使用技巧和一些日常总结的使用经验
    |-design_pattern                        # 设计模式
    |─experience                            # 经验：遇到的坑和错误以及对应经验总结
        |-go项目经验                                # go项目中遇到的一些坑和经验
        |-bug.md                                   # 遇到的bug
        |-mongodb查询优化.md                        # mongodb 查询优化
    |-pictures                              # 图片资源
    |─standard                              # 一些标准（提交、代码编写之前、代码编写、项目规划组织）
        |-commit_standard.md                    # 提交规范
        |-go_code_standard.md                   # Go代码规范
        |-pre_cdoe_standard.md                  # 编码之前的问题，如沟通等
    |-linux.md                              # linux知识
    |-the_odd_go.md                         # Go奇技淫巧
|—technology                            # 技术：涉及到的相关技术，如mongodb等
    |-MySQL                                 # MySQL
    |-mongodb.md                            # MongoDB
|—utils                                 # 工具：日常使用的一些工具
    |-apidoc.md                             # apidoc
    |-docker.md                             # docker
    |-git.md                                # git
|—wheels                                # 轮子：使用的开发框架和组件，如gorm等
    |-go                                    # go标准库
    |-gorm.md                               # gorm
    |-wire.md                               # wire     
|—work_and_project_summary              # 工作和项目总结：以月和项目为单位总结自己的学习和成果
    |-2022                                    # 2022年
    |-2023                                    # 2023年       
└─README.md
```


- TODO
- [ ] 编写内存对齐文章
- [ ] 8、GO字符串处理
- [ ] 6、MySQL技术内幕8（备份与恢复）


- QUESTION
- [ ] 5、MySQL技术内幕7（事务） - 为什么 redo log 日志写入不需要双写机制？
- [ ] 最左匹配原则，具体见下面 MySQL 2  


```text
MySQL 2
联合索引（a,b,c）
explain SELECT d from a WHERE c=1 AND b=2;  // 走索引 abc
explain SELECT a from a WHERE c=1 AND b=2;  // 不走索引 abc
```