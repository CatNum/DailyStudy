[原文地址](https://github.com/selfteaching/How-To-Ask-Questions-The-Smart-Way) | 
[中文译本](https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way/blob/main/README-zh_CN.md)

# 总结
1. 在自己探索无果之后再进行提问
2. 保持谦逊但是不要太卑微
3. 追求准确简洁减少繁杂的描述（不要写救救我、紧急之类的）
4. 准备好问题，尽量降低助人者的时间成本


# 目录
- [1.声明](#1)
- [2.简介](#2)
- [3.在提问之前](#3)
- [4.当你提问时](#4)
  - [4.1 慎选提问的论坛](#4.1)
  - [4.2 Stack Overflow](#4.2)
  - [4.3 网站和 IRC 论坛](#4.3)
  - [4.4 第二步，使用项目邮件列表](#4.4)
  - [4.5 使用有意义且描述明确的标题](#4.5)
  - [4.6 使问题容易回复](#4.6)
  - [4.7 使用清晰、正确、精准且合乎语法的语句](#4.7)
  - [4.8 使用易于读取且标准的文件格式发送问题](#4.8)
  - [4.9 精确地描述问题并言之有物](#4.9)
  - [4.10话不在多而在精](#4.10)
  - [4.11 别动辄声称找到 Bug](#4.11)
  - [4.12 低声下气不能代替你的功课](#4.12)
  - [4.13 描述问题症状而非你的猜测](#4.13)
  - [4.14 按发生时间先后列出问题症状](#4.14)
  - [4.15 描述目标而不是过程](#4.15)
  - [4.16 别要求使用私人电邮回复](#4.16)
  - [4.17 清楚明确的表达你的问题以及需求](#4.17)
  - [4.18 询问有关代码的问题时](#4.18)
  - [4.19 别把自己家庭作业的问题贴上来](#4.19)
  - [4.20 去掉无意义的提问句](#4.20)
  - [4.21 即使你很急也不要在标题写紧急](#4.21)
  - [4.22 礼多人不怪，而且有时还很有帮助](#4.22)
  - [4.23 问题解决后，加个简短的补充说明](#4.23)
- [5.如何解读答案](#5)
  - [5.1 RTFM 和 STFW：如何知道你已完全搞砸了](#5.1)
  - [5.2 如果还是搞不懂](#5.2)
  - [5.3 处理无礼的回应](#5.3)
- [6.如何避免扮演失败者](#6)
- [7.不该问的问题](#7)
- [8.好问题与蠢问题](#8)
- [9.如果得不到回答](#9)
- [10.如何更好地回答问题](#10)
- [11.相关资源](#11)
- [12.鸣谢](#12)



# <span id="2">2. 简介</span>
黑客们喜欢**挑战性**的问题。

黑客们不讳言对那些**不愿思考、或者在发问前不做他们该做的事的人**的蔑视。但是不是对新手和无知者的敌意。

黑客们回答问题的风格是**指向那些真正对此有兴趣并愿意主动参与解决问题的人**，这一点不会变，也不该变。

如果你厌恶我们的态度，高高在上，或过于傲慢，不妨也设身处地想想。**我们并没有要求你向我们屈服** —— 
事实上，我们**大多数人非常乐意与你平等地交流**，只要你付出小小努力来满足基本要求，
我们就会欢迎你加入我们的文化。但让我们帮助那些不愿意帮助自己的人是没有效率的。
无知没有关系，但装白痴就是不行。

所以，你**不必在技术上很在行才能吸引我们的注意**，但你**必须表现出能引导你变得在行的特质** —— 
**机敏、有想法、善于观察、乐于主动参与解决问题**。如果你做不到这些使你与众不同的事情，
我们建议你花点钱找家商业公司签个技术支持服务合同，而不是要求黑客个人无偿地帮助你。

如果你决定向我们求助，当然你也不希望被视为失败者，更不愿成为失败者中的一员。
能立刻得到快速并有效答案的最好方法，就是**像赢家那样提问 —— 聪明、自信、有解决问题的思路，
只是偶尔在特定的问题上需要获得一点帮助。**

# <span id="3">3. 在提问之前</span>

在你准备要通过电子邮件、新闻群组或者聊天室提出技术问题前，请先做到以下事情：

1. 尝试在你准备提问的论坛的旧文章中搜索答案。
2. 尝试上网搜索以找到答案。
3. 尝试阅读手册以找到答案。
4. 尝试阅读常见问题文件（FAQ）以找到答案。
5. 尝试自己检查或试验以找到答案。
6. 向你身边的强者朋友打听以找到答案。
7. 如果你是程序开发者，请尝试阅读源代码以找到答案。

**个人认为有效的顺序和途径：**
1. 文档、手册
2. 常见问题
3. 谷歌
4. 源码
5. 自己检查或试验
6. 向身边朋友打听

准备好你的问题，草率的发问只能得到草率的回答，甚至得不到答案，表现出在寻求帮助前为解决问题付出的努力。
靠提出有内涵的、有趣的、有思维激励作用的问题（一个有潜力贡献社区经验的问题，而不仅仅是被动的索取知识）
去“挣到”一个答案。

另一方面，表明你愿意在找答案的过程中做点什么是一个非常好的开端。`谁能给点提示？`、
`我的这个例子里缺了什么？`以及`我应该检查什么地方`比`请把我需要的确切的过程贴出来`更容易得到答复。
因为你表现出只要有人能指个正确方向，你就有完成它的能力和决心。

# <span id="4">4. 当你提问时</span>

## <span id="4.1">4.1 慎选提问的论坛</span>

小心选择你要提问的场合。如果你做了下述的事情，你很可能被忽略掉或者被看作失败者：

- 在与主题不合的论坛上贴出你的问题。
- 在探讨进阶技术问题的论坛张贴非常初级的问题；反之亦然。
- 在太多的不同新闻群组上重复转贴同样的问题（cross-post）。
- 向既非熟人也没有义务解决你问题的人发送私人电邮。

## <span id="4.2">4.2 Stack Overflow</span>
搜索，然后在 Stack Exchange 问。

Stack Overflow 是 Stack Exchange 其中的一个小网站

## <span id="4.3">4.3 网站和 IRC 论坛</span>
对应软硬件的网站和IRC论坛

## <span id="4.4">4.4 第二步，使用项目邮件列表</span>
优先用户邮箱，然后开发者邮箱，如果没有开发者邮箱，可以发送给维护者邮箱。

## <span id="4.5">4.5 使用有意义且描述明确的标题</span>
使用简单扼要的描述方式来提问。一个好的标题范例是`目标 —— 差异`式的描述。
在**目标部分**指出是哪一个或哪一组东西有问题， 在**差异部分**描述与期望不一致的地方。

编写`目标 —— 差异` 式描述的过程有助于你组织对问题的细致思考。

## <span id="4.6">4.6 使问题容易回复</span>

## <span id="4.7">4.7 使用清晰、正确、精准且合乎语法的语句</span>
正确的拼写、标点符号和大小写是很重要的。
## <span id="4.8">4.8 使用易于读取且标准的文件格式发送问题</span>

## <span id="4.9">4.9 精确地描述问题并言之有物</span>
仔细、清楚地描述你的问题或 Bug 的症状。
- 描述问题发生的环境（机器配置、操作系统、应用程序、以及相关的信息），提供经销商的发行版和版本号（如：Fedora Core 4、Slackware 9.1等）。
- 描述在提问前你是怎样去研究和理解这个问题的。
- 描述在提问前为确定问题而采取的诊断步骤。
- 描述最近做过什么可能相关的硬件或软件变更。
- 尽可能地提供一个可以重现这个问题的可控环境的方法。

尽量去揣测一个黑客会怎样反问你，在你提问之前预先将黑客们可能提出的问题回答一遍。
## <span id="4.10">4.10 话不在多而在精</span>
你需要提供**精确有内容**的信息。这并不是要求你简单的把成堆的出错代码或者资料完全转录到你的提问中。如果你有庞大而复杂的测试样例能重现程序挂掉的情境，尽量将它剪裁得越小越好。

这样做的用处至少有三点。 **第一**，表现出你为简化问题付出了努力，这可以使你得到回答的机会增加； **第二**，简化问题使你更有可能得到有用的答案； **第三**，在精炼你的 bug 报告的过程中，你很可能就自己找到了解决方法或权宜之计。
## <span id="4.11">4.11 别动辄声称找到 Bug</span>
当你在使用软件中遇到问题，除非你非常、非常的有根据，不要动辄声称找到了 Bug。提示：除非你能提供解决问题的源代码补丁，或者提供回归测试来表明前一版本中行为不正确，否则你都多半不够完全确信。这同样适用在网页和文件，**如果你（声称）发现了文件的Bug，你应该能提供相应位置的修正或替代文件。**

请记得，还有其他许多用户没遇到你发现的问题，否则你在阅读文件或搜索网页时就应该发现了（你在抱怨前已经做了这些，是吧？）。这也意味着很有可能是你弄错了而不是软件本身有问题。

编写软件的人总是非常辛苦地使它尽可能完美。如果你声称找到了 Bug，也就是在质疑他们的能力，即使你是对的，也有可能会冒犯到其中某部分人。当你在标题中嚷嚷着有Bug时，这尤其严重。

**提问时，即使你私下非常确信已经发现一个真正的 Bug，最好写得像是你做错了什么。**如果真的有 Bug，你会在回复中看到这点。这样做的话，如果真有 Bug，维护者就会向你道歉，这总比你惹恼别人然后欠别人一个道歉要好一点。
## <span id="4.12">4.12 低声下气不能代替你的功课</span>

## <span id="4.13">4.13 描述问题症状而非你的猜测/span>

## <span id="4.14">4.14 按发生时间先后列出问题症状</span>

## <span id="4.15">4.15 描述目标而不是过程</span>

## <span id="4.16">4.16 别要求使用私人电邮回复</span>

## <span id="4.17">4.17 清楚明确的表达你的问题以及需求</span>
要理解专家们所处的世界，请把专业技能想像为充裕的资源，而回复的时间则是稀缺的资源。你要求他们奉献的时间越少，你越有可能从真正专业而且很忙的专家那里得到解答。

## <span id="4.18">4.18 询问有关代码的问题时</span>
尽量精简代码的数量，并提示如何入手。
错误：不提示如何入手。张贴几百行代码，然后说一声`它不能工作`。
正确：张贴几十行代码，然后说一句`在第七行以后，我期待它显示 <x>，但实际出现的是 <y>`比较有可能让你得到回应。

## <span id="4.19">4.19 别把自己家庭作业的问题贴上来</span>

## <span id="4.20">4.20 去掉无意义的提问句</span>
避免用无意义的话结束提问，例如有人能帮我吗？或者这有答案吗？。

首先：如果你对问题的描述不是很好，这样问更是画蛇添足。

其次：由于这样问是画蛇添足，黑客们会很厌烦你 —— 而且通常会用逻辑上正确，但毫无意义的回答来表示他们的蔑视， 例如：没错，有人能帮你或者不，没答案。

一般来说，避免用 是或否、对或错、有或没有类型的问句，除非你想得到是或否类型的回答。

## <span id="4.21">4.21 即使你很急也不要在标题写紧急</span>

## <span id="4.22">4.22 礼（礼貌）多人不怪，而且有时还很有帮助</span>
坦白说，这一点并没有比使用清晰、正确、精准且合乎语法和避免使用专用格式重要（也不能取而代之）。黑客们一般宁可读有点唐突但技术上鲜明的 Bug 报告，而不是那种有礼但含糊的报告。（如果这点让你不解，记住我们是按问题能教给我们什么来评价问题的价值的）

## <span id="4.23">4.23 问题解决后，加个简短的补充说明</span>

# <span id="5">5. 如何解读答案</span>

## <span id="5.1">5.1 RTFM 和 STFW：如何知道你已完全搞砸了</span>
有一个古老而神圣的传统：如果你收到RTFM（Read The Fucking Manual）的回应，回答者认为你应该去读他妈的手册。当然，基本上他是对的，你应该去读一读。

RTFM 有一个年轻的亲戚。如果你收到STFW（Search The Fucking Web）的回应，回答者认为你应该到他妈的网上搜索。那人多半也是对的，去搜索一下吧。（更温和一点的说法是 Google 是你的朋友！）

## <span id="5.2">5.2 如果还是搞不懂</span>
如果你看不懂回应，别立刻要求对方解释。像你以前试着自己解决问题时那样（利用手册，FAQ，网络，身边的高手），先试着去搞懂他的回应。如果你真的需要对方解释，记得表现出你已经从中学到了点什么。

## <span id="5.3">5.3 处理无礼的回应</span>


# <span id="6">6 如何避免扮演失败者</span>
不要过多关注没有意义的口水战

# <span id="7">7 不该问的问题</span>

# <span id="8">8 好问题与蠢问题</span>

# <span id="9">9 如果得不到回答</span>

# <span id="10">10 如何更好地回答问题</span>

# <span id="11">11 相关资源</span>

# <span id="12">12 鸣谢</span>
