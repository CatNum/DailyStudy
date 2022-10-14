



- [1.使用gorm的前置条件](#1)
  - [1.1 MySQL的安装和配置](#1.1)
- [2.gorm基本操作](#2)
  - [2.1 增](#2.1)
  - [2.2 查](#2.2)
  - [2.3 改](#2.3)
  - [2.4 删](#2.4)
- [3.钩子操作](#3)



# <span id="1">1. 使用gorm的前置条件</span>
## <span id="1.1">1.1 MySQL的安装和配置</span>

[Debian中安装MySQL](https://www.myfreax.com/how-to-install-mysql-on-debian-10/)
| [MySQL创建用户并授予权限](https://www.myfreax.com/how-to-create-mysql-user-accounts-and-grant-privileges/)

```text
#用rpm查看是否安装了MySQL
rpm -qa | grep mysql

#用ps命令查看是否有MySQL进程
ps -ef | grep mysql

##########拓展小知识##############
linux系统基本上分两大类，RedHat系列和Debian系列。
RedHat系列：有Redhat、Centos、Fedora等。
Debian系列：有Debian、Ubuntu等 。
RedHat 系列常见的安装包格式 rpm包,安装rpm包的命令是“rpm -参数”。
    包管理工具 yum。
    支持tar包 。
Debian系列常见的安装包格式 deb包,安装deb包的命令是“dpkg -参数”。
    包管理工具 apt-get。
    支持tar包 。
```

```shell
sudo systemctl status mysql                                    查看 mysql 状态
mysql -u root -p              密码：123456                      更改为账号密码登录方式
CREATE USER 'username1'@'%' IDENTIFIED BY 'password1';         创建用户
GRANT ALL ON db1.* TO username1@'%' WITH GRANT OPTION;         给用户赋予权限
```

# <span id="2">2. gorm基本操作</span>

## <span id="2.1">2.1 添加</span>

### 默认值
可以通过设置`default`标签设置默认值，设置了该标签会填充值为零值的字段。若要在迁移时跳过默认值定义，你可以使用 `default:(-)`
```text
注意
对于声明了默认值的字段，像 0、''、false 等零值是不会保存到数据库。您需要使用指针类型或 Scanner/Valuer 来避免这个问题，
```

### 创建记录
创建记录的几种方法：
Create方法的参数可以是结构体指针也可以是结构体值类型，官方的例子都是使用的指针类型。
 - 使用**对象指针**创建：db.Create(&user)
 - **指定字段**创建记录，未指定的字段为null：db.Select("Name", "Age", "CreatedAt").Create(&user)
 - **忽略指定的字段**创建记录，被忽略的设置为null：db.Omit("Name", "Age", "CreatedAt").Create(&user)
 - **批量插入**，传入一个切片：db.Create(&users)
 - **分批批量插入**，传入一个切片，可以指定每批的数量：db.CreateInBatches(users, 100)
 - 根据**map创建**(好处是可以不用创建对象，更方便。但是参数的传递很不方便。比较适合后端批量插入)：
 ```go
    db.Model(&User{}).Create(map[string]interface{}{
      "Name": "jinzhu", "Age": 18,
    })
    
    // batch insert from `[]map[string]interface{}{}`
    db.Model(&User{}).Create([]map[string]interface{}{
      {"Name": "jinzhu_1", "Age": 18},
      {"Name": "jinzhu_2", "Age": 20},
    })
```
   - 使用**SQL表达式、Context Valuer** 创建记录（未记录）
   
### 高级选项
- **钩子操作**：GORM 允许用户定义的钩子有 `BeforeSave`, `BeforeCreate`, `AfterSave`,
  `AfterCreate` 创建记录时将调用这些钩子方法，请参考 [Hooks]() 中关于生命周期的详细信息
  如果您想跳过 钩子 方法，您可以使用 SkipHooks 会话模式，例如：
```go
DB.Session(&gorm.Session{SkipHooks: true}).Create(&user)
```
- **关联创建**：创建关联数据时，如果关联值是非零值，这些关联也会被创建，且他们的`Hook`方法也会被调用
```go
  type CreditCard struct {
  gorm.Model
  Number   string
  UserID   uint
  }
  
  type User struct {
  gorm.Model
  Name       string
  CreditCard CreditCard
  }
  
  db.Create(&User{
  Name: "jinzhu",
  CreditCard: CreditCard{Number: "411111111111"}
  })
  // INSERT INTO `users` ...
  // INSERT INTO `credit_cards` ...
 ```
- **Upsert及冲突**（未记录）


## <span id="2.2">2.2 查找</span>

### 指定查询字段
使用`Select()`指定检索的字段，默认检索所有字段。

### 查询形式
- 通过gorm提供的**函数**直接获取，比如`First()`、`Last()`
- **String条件**：使用`Where()`函数进行条件判断，参数通过 String 提供
- **Struct & Map条件**：使用`Where()`函数进行判断，参数通过Struct 或 Map提供。使用struct时，
对零值（0,'',false等）不进行查询。

### 查询方法
- 查询**单条**记录：`First()`（主键升序第一条）、`Last()`（主键降序第一条）、`Take()`（没有指定排序字段）。
没有找到记录时，它会返回 `ErrRecordNotFound` 错误。函数参数需要为结构体的指针类型或者使用`db.model()`
指定model才能生效。如果model没有指定主键，那么将按照model的第一个字段排序。
- 根据**主键**获取
```go
db.First(&user, 10)
// SELECT * FROM users WHERE id = 10;
db.Find(&users, []int{1,2,3})
// SELECT * FROM users WHERE id IN (1,2,3);
// 如果主键是字符串
db.First(&user, "id = ?", "1b74413f-f3b8-409f-ac47-e8c062e3472a")
// SELECT * FROM users WHERE id = "1b74413f-f3b8-409f-ac47-e8c062e3472a";
```
- 检索**全部**对象：`db.Find()`

### 查询筛选
- **内联条件筛选**：查询条件也可以内联到`First()`和`Find()`之类的方法中，用法类似于`Where()`，可以使用String、Struct、Map方式提供查询条件
- **非条件筛选**：`Not()`
- **或条件筛选**：`Or()`
- **排序筛选**：`Order()`，字段排序规则在Order函数中通过字符串选择
- **Limit & Offset**：`Limit()`指定要检索的最大记录数。 `Offset()`指定在开始返回记录前要跳过的记录数。
- **Group By & Having**：分组筛选和条件筛选
- **Distinct**：从model中选择特定的值
- **Joins**：（未记录）
- **Joins 预加载**：（未记录）
- **Joins 一个衍生表**：（未记录）
- **Scan**：`Scan()` 结果至 struct，用法与 `Find` 类似

## <span id="2.3">2.3 更新</span>

### 更新方法
- **保存所有字段**：`Save` 会保存所有的字段，即使字段是零值
```go
db.First(&user)

user.Name = "jinzhu 2"
user.Age = 100
db.Save(&user)
// UPDATE users SET name='jinzhu 2', age=100, birthday='2016-01-01', updated_at = '2013-11-17 21:34:10' WHERE id=111;
```
- **更新单个列**：当使用 `Update` 更新单个列时，你需要指定条件，否则会返回 `ErrMissingWhereClause` 错误。
当使用了 `Model` 方法，且该对象主键有值，该值会被用于构建条件。
- **更新多列**：`Updates` 方法支持 `struct` 和 `map[string]interface{}` 参数。当使用 `struct` 更新时，默认情况下，GORM 只会更新非零值的字段。
如果想要确保指定字段被更新，应该使用`Select`更新选定字段，或使用`map`来完成更新操作。
- **更新选定字段**：`Select`选定更新字段，`Omit`选定忽略字段。
- **更新Hook**：对于更新操作，GORM 支持 `BeforeSave`、`BeforeUpdate`、`AfterSave`、`AfterUpdate` 钩子。
- **批量更新**：不使用`model`指定主键则进行批量更新。没有任何条件的情况下gorm默认不会执行批量更新，对此
可以通过1.加一些条件 2.使用原生SQL 3.启用`AllowGlobalUpdate`模式来开启批量更新。例如：
```go
db.Model(&User{}).Update("name", "jinzhu").Error // gorm.ErrMissingWhereClause

db.Model(&User{}).Where("1 = 1").Update("name", "jinzhu")
// 1.通过加条件解决 UPDATE users SET `name` = "jinzhu" WHERE 1=1    

db.Exec("UPDATE users SET name = ?", "jinzhu")
// 2.通过原生SQL解决 UPDATE users SET name = "jinzhu"

db.Session(&gorm.Session{AllowGlobalUpdate: true}).Model(&User{}).Update("name", "jinzhu")
// 3.通过开启AllowGlobalUpdate模式解决 UPDATE users SET `name` = "jinzhu"
```
- **高级选项**
  - **使用SQL表达式更新**（未记录）
  - **使用子查询进行更新**
  - **不使用`Hook`和时间追踪**：如果您想在更新时跳过 `Hook` 方法且不追踪更新时间，可以使用 `UpdateColumn`、`UpdateColumns`，其用法类似于 `Update`、`Updates`
  - **返回修改行的数据**：可以更新数据并将选定的字段赋值给对象，不指定字段则默认全部。
  - **检查字段是否有变更**：`Changed`方法，它可以被用在 `Before Update Hook` 里，
`Changed` 方法只能与 `Update`、`Updates` 方法一起使用，
并且它只是检查字段本身的值与更改之后的值是否相同，如果不同，且字段没有被忽略，则返回 true，反之返回false
  - **在`Update`时修改值**：若要在 Before 钩子中改变要更新的值，如果它是一个完整的更新，可以使用 `Save`；否则，应该使用 `SetColumn`  

## <span id="2.4">2.4 删除</span>
- 删除一条记录：Delete，删除时需要指定主键，否则会批量删除
- 根据主键删除：



# <span id="3">3. 钩子操作</span>

