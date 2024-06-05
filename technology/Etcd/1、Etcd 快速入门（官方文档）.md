## 一、Etcd 快速入门

### 1、Etcd 支持的平台【选看】

etcd 支持在不同的平台上运行，但它提供的支持分为三个级别：

- 级别一：由 etcd 维护者完全支持； etcd 保证通过所有测试，包括功能和稳健性测试。
- 级别二：etcd 保证通过集成和端到端测试，但不一定是功能或稳健性测试。
- 级别三：etcd 可以保证构建，可能会进行轻微测试（或不进行测试），因此应将其视为不稳定。

这里仅列出常用的几种支持信息，详细信息见：[支持的平台](https://etcd.io/docs/v3.5/op-guide/supported-platform/ "支持的平台")。

| 架构    | 操作系统    | 支持级别 | 维护者                                                     |
|-------|---------|------|---------------------------------------------------------|
| AMD64 | Linux   | 1    | [维护者](https://github.com/etcd-io/etcd/blob/main/OWNERS) |
| ARM64 | Linux   | 1    | [维护者](https://github.com/etcd-io/etcd/blob/main/OWNERS) |
| ARM   | Linux   | 3    |                                                         |
| AMD64 | Windows | 3    |                                                         |

### 2、硬件建议【选看】

在开发和测试中，资源有限的笔记本或者便宜的云机器都可以支持 etcd 进行开发。但是，在生产中运行 etcd 集群时，这些硬件指南可以帮助更好的管理。

#### 2.1 中央处理器（CPUs）

etcd 部署很少需要大量的 CPU 能力。典型的集群需要两到四个核心才能平稳运行。负载较重的 etcd 部署，每秒服务数千个客户端或数万个请求，
往往才会受到 CPU 限制，因为 etcd 可以服务于内存中的请求。如此繁重的部署通常需要八到十六个专用核心。

#### 2.2 内存（Memory）

etcd 的内存占用相对较小，但其性能仍然取决于是否有足够的内存。 etcd 服务器将积极缓存键值数据，并花费大部分剩余内存来跟踪观察者。通常
8GB 就足够了。
对于具有数千个观察者和数百万个键值数据的重型部署，请相应地分配 16GB 到 64GB 内存。

#### 2.3 磁盘（Disks）

快磁盘（Fast disks）是 etcd 部署性能和稳定性的最关键因素。

慢磁盘（slow disk）会增加 etcd 请求延迟并可能损害集群稳定性。由于 etcd 的共识协议依赖于将元数据持久存储到日志中，因此大多数
etcd 集群成员必须将每个请求写入磁盘。
此外，etcd 还将增量地将其状态 check 到磁盘，方便它可以截断日志。如果这些写入花费的时间太长，心跳可能会超时并触发选举，从而破坏集群的稳定性。
一般来说，要判断磁盘对于 etcd 来说是否足够快，可以使用 [fio](https://github.com/axboe/fio)
等基准测试工具。请阅读此处的[示例](https://prog.world/is-storage-speed-suitable-for-etcd-ask-fio/)。

etcd 对磁盘写入延迟非常敏感。通常需要 50 个连续 IOPS（例如，7200 RPM 磁盘）。
对于负载较重的集群，建议使用 500 个连续 IOPS（例如，典型的本地 SSD 或高性能虚拟化块设备）。
请注意，大多数云提供商发布并发 IOPS，而不是顺序 IOPS；发布的并发 IOPS 可能比顺序 IOPS 高 10 倍。
要测量实际的顺序 IOPS，我们建议使用磁盘基准测试工具，例如 [diskbench](https://github.com/ongardie/diskbenchmark)
或 [fio](https://github.com/axboe/fio)。

etcd 仅需要适度的磁盘带宽，但当发生故障的成员必须恢复集群时，更多的磁盘带宽可以获取更快的恢复时间。
通常 10MB/s 将在 15 秒内恢复 100MB 数据。对于大型集群，建议 100MB/s 或更高，以在 15 秒内恢复 1GB 数据。

如果可能，使用 SSD 备份 etcd 的存储。 SSD 通常比旋转磁盘提供更低的写入延迟和更少的方差，从而提高了 etcd 的稳定性和可靠性。
如果使用旋转磁盘，请尽可能使用最快的磁盘 (15,000 RPM)。对于旋转磁盘和 SSD 来说，使用 RAID 0 也是提高磁盘速度的有效方法。
对于至少三个集群成员，RAID 的镜像和/或奇偶校验变体是不必要的； etcd 的一致性复制已经保证了高可用性。

> 注：
> IOPS (Input/Output Per Second)：即每秒的输入输出量(或读写次数)，是衡量磁盘性能的主要指标之一。
> 关于磁盘详见：[吞吐量和 IOPS 及测试工具 FIO 使用](https://www.cnblogs.com/hukey/p/12714113.html)

#### 2.4 网络（Network）

快速可靠的网络有益于多成员 etcd 部署。为了让 etcd 保持一致性和分区容忍性，不可靠的网络和分区中断将导致可用性较差。
低延迟确保 etcd 成员可以快速通信。高带宽可以减少恢复失败的 etcd 成员的时间。 1GbE 足以满足常见的 etcd 部署。对于大型 etcd
集群，10GbE 网络将缩短平均恢复时间。

尽可能在单个数据中心内部署 etcd 成员，以避免延迟开销并减少分区事件的可能性。如果需要另一个数据中心的故障域，请选择距离现有数据中心较近的数据中心。
另请阅读[调优文档](https://etcd.io/docs/v3.5/tuning/)以获取有关跨数据中心部署的更多信息。

#### 2.5 总结

以上配置为官方推荐指南，官方文档中给出了具体的规模对应的推荐配置，见[官方文档](https://etcd.io/docs/v3.5/op-guide/hardware/)。

### 3、安装【必看】

安装 etcd 可以从预编译的二进制文件或者源代码两种方式进行安装，本文只讲述通过二进制文件安装。

1. 从[版本](https://github.com/etcd-io/etcd/releases/)下载适合您平台的压缩存档文件，选择版本 v3.5.13 或更高版本。
2. 解压存档文件。这会产生一个包含二进制文件的目录。
3. 将可执行二进制文件添加到环境变量中的 Path 中。比如我的 Path 中加入的是：D:\etcd\etcd-v3.5.13-windows-amd64
4. 从 shell 测试 etcd 是否在您的路径中：

```text
$ etcd --version
etcd Version: 3.5.13
...
```

### 4、 简单使用

1. 通过解压文件中的 etcd.exe 启动 etcd
2. 在另一个终端，执行 `etcdctl put greeting "Hello, etcd"` 添加一个键值数据
3. 执行 `etcdctl get greeting` 获取键值数据


### 5、Etcd 应用场景

Etcd 是一个分布式的，一致的 key-value 存储，适用于以下场景：
- 共享配置
- 服务发现

> 参考链接：
>
> [Supported platforms](https://etcd.io/docs/v3.5/op-guide/supported-platform/ "Supported platforms")
>
> [Hardware recommendations](https://etcd.io/docs/v3.5/op-guide/hardware/ "Hardware recommendations")
>
> [Install](https://etcd.io/docs/v3.5/install/ "Install")
>
> [Quickstart](https://etcd.io/docs/v3.5/quickstart/ "Quickstart")
>
> [吞吐量和 IOPS 及测试工具 FIO 使用](https://www.cnblogs.com/hukey/p/12714113.html "吞吐量和 IOPS 及测试工具 FIO 使用")