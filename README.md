# qBitTorrent-docker

docker 一键部署 VPS-BT 离线下载

------

## 概要

种子和磁力链接是现在使用最为广泛的资源下载形式了，但有时即使找到了种子资源，也会面临墙、网速、高额收费等限制问题，导致难以顺利下载。

qBitTorrent 是一款开源免费的种子和磁力链接下载工具，支持 Windows、Mac 和 Linux 平台，功能非常强大。

通过把 qBitTorrent 部署到个人的离线 VPS，就能离线下载到 VPS，再按需从 VPS 取回本地。

而一台海外的千兆带宽 VPS ，也不是月租 $5 而已（推荐 [vultr](https://www.vultr.com/)）。


## 项目说明

本仓库包含三个 docker 镜像：

| docker 镜像 | 用途 | 服务端口 | 端口说明 |
|:------:|:------:|:------:|:------:|
| qBitTorrent | 用于 BT 下载资源到 VPS | 8080 | WEB 管理界面 |
| - | - | 8081 | 用于 P2P 连接的最小端口，默认是 6881(-6889)<br/>但是 6881 已被大部分资源站拉黑，故设置为另一个最小端口 |
| - | - | 9000 | 用于内部共享私有种子的端口 |
| caddy | 用于浏览 VPS 上已下载的资源文件，并拉回本地 | 9090 | xxx |
| nginx | 反向代理 qBitTorrent 和 caddy 服务 | 80 | 项目说明页面 |


## 环境要求

![](https://img.shields.io/badge/Platform-Linux%20amd64-brightgreen.svg)



## 部署步骤

### 1. 项目构建

- 宿主机安装 docker、docker-compose
- 构建镜像并运行： `caddy_user=admin caddy_pass=123456 docker-compose up -d`

> caddy 的账号密码按需设置即可



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


Bittorrent\TrackersList=udp://open.stealth.si:80/announce\nudp://tracker.uw0.xyz:6969/announce\nhttp://tracker.ipv6tracker.ru:80/announce\nudp://tracker.birkenwald.de:6969/announce\nhttp://tracker.files.fm:6969/announce\nudp://tracker.zerobytes.xyz:1337/announce

