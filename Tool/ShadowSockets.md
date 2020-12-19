# ShadowSockets

- `yum -y install python-setuptools && easy_install pip`

- `pip install shadowsocks`

- `touch /etc/shadowsocks.json`

- `vi /etc/shadowsocks.json`

  - ```json
    {
    "server":"IP",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "port_password":{
        "端口":"mima",
    	"6231":"123456",
    	"6232":"zxc203097"
    },
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false
    }
    ```

    

- `ssserver -c /etc/shadowsocks.json -d start`

