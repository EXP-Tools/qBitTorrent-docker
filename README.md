# qBitTorrent-docker

docker 一键部署 VPS-BT 离线下载

------


## 项目构建

`caddy_user=admin caddy_pass=123456 docker-compose up -d`


## qBitTorrent： BT 离线下载管理页面

https://github.com/qbittorrent/qBittorrent

- `http://${vps-ip}/bt/` 或 `http://${vps-ip}:8080`
- username: admin
- password: adminadmin

> 登录账密修改方法： 在 web ui 设置
若忘记修改过的密码，进入容器，修改 /config/qBittorrent/Bittorrent.conf 文件的 WebUI/Password_PBKDF2 配置项，重启进程即可还原为默认密码

手机端管理工具：transdrone


## caddy： 已下载的文件列表页面

https://github.com/caddyserver/caddy

- `http://${vps-ip}/list/` 或 `http://${vps-ip}:9090`
- username: admin
- password: 123456

> BasicAuth 账密修改方法： 项目构建时



------

## 使用教程

https://zhuanlan.zhihu.com/p/64254201
https://github.com/ngosang/trackerslist/


> 此工具只能提供 torrent种子(或种子的下载地址） 进行下载，无法直接解析 磁链或迅雷链接。 对于 磁链或迅雷链接 需要先转换为 torrent种子文件，可参考 https://my.oschina.net/u/1440553/blog/4480497 
