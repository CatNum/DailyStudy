# DailyStudy

```
|─miscellaneous_remarks                 # 杂谈：包括一些文章和博文
    |-essay                                 # 文章
        |-three_mintue                          # 三分钟 
    |-How_To_Clean_Code.md                  # 如何写干净的代码
    |-GoPractice.md                         # Go最佳实践
    |-How_To_Ask_Question.md                # 如何问问题
|—other                                 # 其它：技术之外的相关记录
    |-notesoft.md                           # 笔记选择
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
  - [ ] 前端登录接口访问被拒绝（状态栏报CORS错误，请求地址ip与服务器ip不相同）
    - 可能的错误：
    - 1）跨域 2023-07-19 （CORS 导致前端页面登录接口失效 POST 请求）
    - 2）前端请求头拼接错误（最终确认是这样，前端更改请求方式为动态ip解决）