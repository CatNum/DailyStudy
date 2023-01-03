# what
代码提交规范

# why
充分利用 commit message ，后面可以根据这个做自动化生成Change log 可以过滤某些commit（比如文档改动），便于快速查找信息

# how
### commit message 格式
>参考 https://github.com/pvdlg/conventional-changelog-metahub#commit-types
## 提交类型
| 提交类型   | 标题     | 描述                                                         |
| ---------- | -------- | ------------------------------------------------------------ |
| `feat`     | 特征     | 一个新功能                                                   |
| `fix`      | Bug修复  | 错误修复                                                     |
| `docs`     | 文档     | 仅文档更改                                                   |
| `style`    | 风格     | 不影响代码含义的更改（空格、格式、缺少分号等）               |
| `refactor` | 代码重构 | 既不修复错误也不添加功能的代码更改                           |
| `perf`     | 性能改进 | 提高性能的代码更改                                           |
| `test`     | 测试     | 添加缺失的测试或纠正现有的测试                               |
| `build`    | 构建     | 影响构建系统或外部依赖项的更改（示例范围：gulp、broccoli、npm） |
| `ci`       | 持续集成 | 对我们的 CI 配置文件和脚本的更改（示例范围：Travis、Circle、BrowserStack、SauceLabs） |
| `chore`    | 家务活   | 不修改 src 或测试文件的其他更改                              |
| `revert`   | 还原     | 恢复之前的提交                                               |

#### 要点(tip)
- 修改代码之前先 `git pull origin 具体分支名称` 更新仓库代码，避免多人协同开发过程中提交冲突
- 开发完之后 `git status` 检查更新文件是否是当前业务修改
- 不要使用 `git add -A或者 .*`  建议 add 当前业务修改的具体文件名，避免提交无关文件
- 与项目无关且不需要提交的文件 加入 .gitignore文件中, 如本地测试日志文件，go.sum文件
- 提交之前先 `git diff` 检查提交内容
- 尽量每次提交只做独立的一件事
- 提交之后 `git log` 检查提交记录
- 提交仓库 `git push origin 具体分支名称`
- 一次提交做了两件事，比如 feat 和 fix 同时存在（不推荐这样），commit message 分为两条，每一条使用换行间隔  git commit -m "$header1" -m "$header2" 多行提交
> header 格式为			$type: $subject    type 为 提交事情的类型   subject 为提交的介绍（72字以内）
> type 可参考 https://github.com/pvdlg/conventional-changelog-metahub#commit-types  建议使用 feat(feature 特性) fix(修复) test(测试代码) revert(回退了代码) refactor(重构) anno(注释变动) docs(修改文档)

### 提交格式
- git commit -m "提交类型：当前业务功能-修改内容-提交次数"
>例如：git commit -m "feat：用户列表接口-新增接口-1"
