[toc]

# Git相关知识

### 首次使用

* :package:下载 	
	- [Windows镜像下载](https://npm.taobao.org/mirrors/git-for-windows/)
	- [Ubuntu下载命令](sudo apt install git)	
* :hammer:初次配置用户信息	
  * 用户信息
    ```git
    git config --global user.name  "yourname"
    git config --global user.email "youremail@xxx.com"
	  ```
  * 产生本地密钥 `ssh-keygen -t rsa -C "youremail@xxx.com"` 
* :secret:密码问题(<u>首次输入后,可自动保存密码</u>) `git config --global credential.helper store`
* :hourglass_flowing_sand:下载远程仓库代码 `git clone [url]`
* :file_folder:初始化本地文件夹
  * `git init`
  * `git remtoe add origin [url]`
* 修改仓库链接 `ssh git remote set-url origin git@github.com:yourusername/yourrepositoryname.git`
### 基本操作
- 克隆仓库 `git clone httpsUrl`
- 冲仓库中获取更新 `git pull`
- 新增到暂存区(缓存区)	`git add .`或者`git add <file>`
- 提交到版本区 `git commit -m "注释"`
- 提交到仓库 `git push origin <branch>`

### 仓库
- 查看当前仓库短名 `git remote`
- 查看当前仓库读写地址 `git remote -v`
- 查看当前仓库所有信息 `git remote show <shortname>`
### 日志

- 查看提交记录 `git log `或者 `git log --oneline`

### 标签

- 显示所有标签 `git tag`或者`git tag -l`
- 打上标签 `git tag -a v1.0 -m "注释"`
  - `-a` 表示标签
  - `-m` 表示注释
- 对过去的提交打上标签 `git tag -a v1.2 9fceb02`
- 查看标签的内容 `git show <tag>`
- 删除标签 `git tag -d <tag>`

### 分支

- 查看分支 `git branch` 或者`git branch -v`
- 建立分支并且切换到分支 `git checkout -b <分支>`
  - `git branch <分支>`
  - `git checkout <分支>`
- 查看没有合并的分支 `git branch --no-merged`
- 查看已经合并的分支 `git branch --merged`
- 删除分支 `git branch -d <分支>`
- 合并分支
  - 切换到主分支 `git checkout master`
  - 开始合并`git merge`

### 常见问题

* 日志输出乱码
```git
  git config --global i18n.commitencoding utf-8 
  git config --global i18n.logoutputencoding utf-8 
  export LESSCHARSET=utf-8
```
* 撤销问题
    * 撤销修改 	`git checkout -- <file>`
    * 撤销**add**`git reset head^ <file>` 或者`git restore --staged <file>`
    * 撤销**commit**
      * 撤销更改
        * `git reset head^ --soft`
        * 也可以是`git reset --soft head~2`  **2**代表次数
      * 撤销替换上一次**commit**
        * `git add <file>` 
        * `git commit --amend`
        * 修改注释
    * 撤销**push **
         * 本地退回暂存区上个版本`git reset head^ --soft `
         * 然后将本地代码覆盖远程上 `git push orgin master --force`
* 迁移仓库
	- 仅保留历史提交信息`git clone --bare yourrepository`
	- 然后在你的其他服务，比如gogs新建一个仓库，然后进入你上步克隆出的仓库中，执行：`git push --mirror yourNewRepository`
	- 最后你就可以删除原来的仓库，然后git clone新仓库就行了。




