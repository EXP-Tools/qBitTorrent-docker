# qBitTorrent-docker

docker 一键部署 VPS-BT 离线下载

------


# 项目构建

`caddy_user=admin caddy_pass=123456 docker-compose up -d`


# qBitTorrent： BT 离线下载管理页面

- `http://${vps-ip}/bt/` 或 `http://${vps-ip}:8080`
- username: admin
- password: adminadmin

> 登录账密修改方法： 在 web ui 设置


# caddy： VPS 文件回传本地管理页面

- `http://${vps-ip}/caddy/` 或 `http://${vps-ip}:9090`
- username: admin
- password: 123456

> BasicAuth 账密修改方法： 项目构建时



------

https://zhuanlan.zhihu.com/p/64254201
https://github.com/ngosang/trackerslist/
