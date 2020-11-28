[toc]
# Nginx


### 反向代理
* 在`nginx.conf`中的`http`节点,使用`include xxx.conf;`可以从配置文件目录导入一个扩展内容

* 在扩展文件中,可以添加`server`节点信息
		```nginx
   server{
                listen 8081;
                server_name localhost;
                location /AA{
                      proxy_redirect off;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                      proxy_pass http://localhost:5000/api/Values/Get;    # 收到 server_name 定义的连接之后，会转发到这个连接里面
                 }
            }
   ```

