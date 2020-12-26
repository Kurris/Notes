[toc]
# Linux Cli

### 文件和目录处理命令
- `ls` 查看目录
	- `-lh` 查看当前目录下所有信息(人可识别的类型)
	- `-i` 查看i节点,唯一标记
- `mkdir` 创建文件夹
	- `-p` 可递归创建
- `pwd` 显示当前绝对路径
- `cp` 复制 `cp origin[] destination`
	- `-r` 复制文件夹
	- `-p` 保留文件属性,避免复制的文件修改时间被改变
- `mv` 剪切
- `rm` 删除
	- `-f` 强制删除
	- `-r` 删除文件夹
- `touch` 创建文件
- `more` 进入浏览状态 (只能往下查找)
- `less` 进入浏览状态
	- `/` 输入搜索关键字 `n` 查找下一个
- `head -n` 查看前 默认10行
- `tail -n` 查看后 默认10行
	- `-f` 动态监控日志
- `ln` 软连接/快捷方式

### 文件搜索
- `find [/path] -name filename` 查找路径下匹配的文件名
	- `*filename*` 通配符,类似sql like
	- `filename???` 匹配的文件名后面有三个字符
	- `-iname` 不区分大小写
	- `-a` 并且
	- `-o` 或者
	- `-type` f文件 d文件夹 l软连接
	- `exec(不需要确认)/-ok(需要确认) [command] {} \;`  对结果处理
	- `-inum` i节点,唯一标记
- `find [/path] -size +/- [数据块0.5k]`

- **搜索工具**
	- `mlocate`
	- `updatedb`

### 压缩
- `gzip` 压缩文件,不保留源文件

- `gunzip` 解压

  

- `tar -zcvf [tarfilename] [originname]` 压缩文件夹

  - `-z` 打包同时压缩
  - `-v`详细信息
  - `-f`指定名称
  - `-c`打包
- `tar -xcvf [tarfilename]`
	- `x` 解包
	- `z` 解压缩
  

[返回](# Linux Cli)

### 安装Dotnet
- 安装微软包证书
	`sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm`
- 安装SDK
	`sudo yum install dotnet-sdk-5.0`
- 安装运行时
	`sudo yum install dotnet-runtime-5.0`
- `cd /root/dotnet/publish`
- `dotnet Ligy.Project.WebApi.dll --urls http://127.0.0.1:8080`

### MySql

- 安装源`wget https://repo.mysql.com//mysql80-community-release-el8-1.noarch.rpm`
- 编译`rpm -ivh mysql80-community-release-el8-1.noarch.rpm --nodeps --force`
- 安装服务`yum install mysql-server`

`vi /etc/my.cnf 添加 skip-grant-tables`

```SQL
update user set authentication_string=password("Sa123456!") , password_last_changed=now() where user="root";
update user set authentication_string="*BF6EF00D956EE719C12B30A4F65D70456DE506B1" , password_last_changed=now() where user="root";

```
`grant all privileges on *.* to "mysql.infoschema"@"localhost" identified by "Sa123456!";`
`create user 'mysql.infoschema'@'localhost' identified by 'Sa123456!';`

`flush privileges;`

### Firewall
- 查看服务状态
	`systemctl status firewalld`
- 查看程序状态
	`firewall-cmd --state`
- 服务操作
	`service firewalld start/stop/restart`
	
- 查看端口是否开放
	`firewall-cmd --query-port=8080/tcp`
- 添加/移除入站规则
	`firewall-cmd --zone=public --add/remove-port=8080/tcp --permanent`
	
- 规则重新加载
	`firewall-cmd --reload`
- 查看当前规则
	`firewall-cmd --list-ports`


### Supervistor

 `yum install epel-release`
` yum install -y supervisor`
 `systemctl enable supervisord` # 开机自启动
 systemctl start supervisord # 启动supervisord服务

 systemctl status supervisord # 查看supervisord服务状态
 ps -ef|grep supervisord # 查看是否存在supervisord进程

 supervisorctl
 vim /etc/supervisord.conf

 [program:ligyapi]
directory = /root/dotnet/publish                      ;启动目录
command =dotnet Ligy.Project.WebApi.dll --urls http://*:8080    ;启动命令
autostart = true                                               ;在supervisord启动的时候也启动
startsecs = 10                                                   ;启动5秒后没有异常退出，就当作已经正常启动了
autorestart = true                                            ;程序异常退出后自动重启
startretries = 10                                                ;启动失败自动重试次数，默认是3
user = root                                                      ;哪个用户启动
redirect_stderr = true                                      ;把stderr重定向到stdout，默认false
stdout_logfile_maxbytes = 20MB                    ;stdout日志文件大小，默认50MB
stdout_logfile_backups = 20                           ;stdout日志文件备份数
stdout_logfile = /root/dotnet/logs/LigyApi.log