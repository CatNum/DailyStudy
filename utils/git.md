[git中的各种撤销操作](https://segmentfault.com/a/1190000011910766)
| [push和commit的撤销](https://blog.51cto.com/u_15328720/3384011)
| [git区间-查看分支提交记录](https://blog.csdn.net/weixin_35193131/article/details/113491119)

# 一、git 常用指令

| <div style="width: 120pt">指令</div>                                  | <div style="width: 260pt">参数</div>                                                                                                          | <div style="width: 260pt">描述</div>                                                  | 示例 |
|---------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|----|
| git init                                                            |                                                                                                                                             | 在当前目录新建一个git代码库                                                                     |    |
| git reset                                                           | --soft:修改HEAD指向，不会修改本地代码 </br>--hard:修改本地代码为指定版本                                                                                            | 撤销git push操作                                                                        |    |
| git log                                                             | --pretty:可以控制日志输出内容的详尽程度 </br>-p:可以显示提交记录的差异                                                                                                | 默认展示所有提交记录，可以选择远程仓库和分支，也可以选择                                                        |    |
| git status                                                          | -s:简短显示                                                                                                                                     | 显示工作区和暂存区的差异                                                                        |    |
| git push                                                            | --force:强制推，当进行版本回退的时候使用                                                                                                                    | 更新操作                                                                                |    |
| git checkout                                                        | -b:创建新分支并切换到该分支  -vv:获取本地分支和远程分支的关联情况                                                                                                       | 切换分支                                                                                |    |
| git checkout -f                                                     |                                                                                                                                             | 【放弃工作区和暂存区的所有修改】                                                                    |    |
| git checkout --filename                                             | git checkout -- . 撤销所有文件工作区修改                                                                                                               | 【撤销工作区的修改】可以将工作区的代码（N）恢复为之前的版本（N-1），需要指定文件目录。如果后悔可以在IDE中右击选择历史记录升版本到N。只能修改被git追踪的文件 |    |
| git stash                                                           | save "注解":指定注解 </br>list:展示存储的修改记录 </br>pop:将修改拿出来并删除记录 </br>apply:将修改拿出来且不删除记录 drop:删除指定记录 clear:清空记录 </br>show:展示与当前分支差异 [-p 可以显示文件具体的修改] | 【工作区修改暂存到堆栈】可以将git以跟踪的工作区中的修改代码暂存到内存中（先进后出），也可以在之后拿出来                               |    |
| git remote                                                          |                                                                                                                                             | 查看远程仓库                                                                              |    |
| [git fetch](https://blog.csdn.net/qh_java/article/details/77969010) |                                                                                                                                             | 拉取远程代码                                                                              |    |
| git merge                                                           |                                                                                                                                             | 合并指定分支到当前分支                                                                         |    |
| git pull                                                            |                                                                                                                                             | git pull 相当于 git fetch+git merge                                                    |    |
| git remote prune origin                                             |                                                                                                                                             | 在本地删除远程库中已经删除的分支                                                                    |    |
| git commit --amend                                                  |                                                                                                                                             | 进入最后一次 commit 的详情信息中更改                                                              |    |
|                                                                     |                                                                                                                                             |                                                                                     |    |
|                                                                     |                                                                                                                                             |                                                                                     |    |

```shell
git reset --soft HEAD^      # 撤销上次的 commit 
```

```text
Git创建远程分支:
git checkout -b my-test  //在当前分支下创建my-test的本地分支分支
git push origin my-test  //将my-test分支推送到远程
git branch --set-upstream-to=origin/my-test //将本地分支my-test关联到远程分支my-test上   
git branch -a //查看远程分支 
```

## 1.1 如何合并指定文件和目录

[博客](https://juejin.cn/post/6844903598241873928)

```text
前提条件：当前在 v2.1.2 分支，v2.1.1 分支的 pkg/object 目录下有文件更新需要合并到 v2.1.2 分支
使用命令 git checkout release-v2.1.1 pkg/object ，则可以完成将 pkg/object 目录从 v2.1.1 合并到 v2.1.2 
```

# 二、git 遇到的问题

## 2.1 git pull 超时

情况：之前 `git` 正常，没有做什么配置。突然有一天拉代码就超时了，本来以为是网络问题，但是 `github`
正常访问，且换网、第二天再拉还是不行；遂怀疑是不是 `ssh` 有问题了，
尝试 `http` 克隆代码，也不行。遂网上查询，看到很多讲代理的帖子。

前提条件：

1. 使用 clash
2. 开启系统代理

解决方法：[在 HTTPS 端口使用 SSH](https://docs.github.com/zh/authentication/troubleshooting-ssh/using-ssh-over-the-https-port "在 HTTPS 端口使用 SSH")

