# Docker

### 安装

- Centos 8+

  - 先移除

    ```shell
    yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine
    ```

  - 安装依赖`yum install -y yum-utils`

  - 如果是8+系统 `yum-config-manager --enable docker-ce-test`

  - 安装容器.io`yum install https://download.docker.com/linux/centos/8/x86_64/stable/Packages/containerd.io-1.4.3-3.1.el8.x86_64.rpm`

  - 安装组件`yum install docker-ce docker-ce-cli`



### 命令行

- 查看日志 `docker logs [option] [container]`





### MySql

- 启动myql镜像`docker run --name ligymysql -p 3306:3306 -e MYSQL\_ROOT\_PASSWORD=123456 -d mysql`
  - `--name` 容器名称
  - `-p`端口号
  - `3306:3306`本地端口:容器端口
  - `-e`设置环境变量
  - `-d`后台运行
  - `-v`本地文件夹:容器文件夹

- 进入mysql镜像容器` docker exec -it ligymysql /bin/bash`

