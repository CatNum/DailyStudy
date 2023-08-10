- [1. PDF 前言](#1)
    - [1.1 背景](#1.1)
- [2. 相关库](#2)
    - [2.1 pdfcpu](#2.1)
    - [2.2 gofpdf + wkhtmltopdf](#2.2)












### <span id="1">1. PDF 前言</span>

#### <span id="1.1">1.1 背景</span>
在做可视化项目的过程中，有一个需求如下：
- 提供在线预览报告接口（PDF形式）
- 提供下载报告接口（PDF形式）
- 提供具体日志下载（Excel形式）

因为多个页面都需要使用该功能，所以需要抽出公共方法
1. 初步目标是可以根据传入的结构体和标识（标识是哪个页面调用以获取不同的报告首页）生成对应的PDF  ----2023/08/10



### <span id="2">2. 相关库</span>

#### <span id="2.1">2.1 pdfcpu</span>
github仓库地址：[pdfcpu库](https://github.com/pdfcpu/pdfcpu)

该库已经稳定但是会有重大更新，不适合使用在项目中。

#### <span id="2.2">2.2 gofpdf + wkhtmltopdf</span>
相关介绍：[相关链接](https://www.php.cn/faq/540227.html)

使用`wkhtmltopdf`将`html`转`pdf`相关样例：[例子地址](https://www.jianshu.com/p/3dce30736279)

`github`仓库地址：[gofpdf库](https://github.com/jung-kurt/gofpdf)

如何安装`wkhtmltopdf` ：[链接](https://www.hmxthome.com/linux/4879.html)

`github`仓库地址：[go-wkhtmltopdf：go对wkhtmltopdf的封装](https://github.com/SebastiaanKlippert/go-wkhtmltopdf)

##### 简单概括
- `gofpdf` ：可以调用`API`生成`pdf`

- `wkhtmltopdf` ：是命令行，可以使用命令来将`html`转换为`pdf`