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

| 镜像 | 用途 | 服务端口 | 端口说明 |
|:------:|:------:|:------:|:------|
| [qBitTorrent](https://github.com/qbittorrent/qBittorrent) | 用于 BT 下载资源到 VPS | 8080 | WEB 管理界面 |
| - | - | 8081 | 用于 P2P 连接的最小端口，默认 6881(-6889)，<br/>但 6881 已被大部分资源站拉黑，<br/>故设置为另一个最小端口 |
| - | - | 9000 | 用于内部共享私有种子的端口 |
| [caddy](https://github.com/caddyserver/caddy) | 用于从 VPS 上拉回资源到本地 | 9090 | 资源文件的浏览界面 |
| [nginx](https://www.nginx.com/) | 反向代理 qBitTorrent 和 caddy 服务 | 80 | 项目说明页面 |


## 环境要求

![](https://img.shields.io/badge/Platform-Linux%20amd64-brightgreen.svg)



## 部署步骤

### 1. 项目构建

- 宿主机安装 docker、docker-compose
- 宿主机防火墙/安全组放行这些端口的入口流量： 80、8080、8081-8089、8081-8089/udp、9000、9090
- 下载仓库： `git clone https://github.com/lyy289065406/qBitTorrent-docker /usr/local/qBitTorrent-docker`
- 打开仓库目录： `cd /usr/local/qBitTorrent-docker`
- 构建镜像并运行： `caddy_user=admin caddy_pass=123456 docker-compose up -d`

> caddy 的账号密码按需设置即可；qBittorrent 的密码因为使用 PBKDF2 算法，又没有提供生成密码的命令行工具，故只能在 WEB 页面上修改。


### 2. 配置 qBitTorrent

- 登录 WEB 管理页面：`http://${vps-ip}/bt/`（或 `http://${vps-ip}:8080`）
- 默认登录账密: `admin / adminadmin`
- 修改默认密码: 【选项】 -> 【Web UI】 -> 【验证】
- 修改 tracker 列表： 【选项】 -> 【BitTorrent】 -> 【自动添加以下 tracker 到新的 torrent】

> 更多配置可参考《[专业磁力种子下载工具 qBittorrent 使用教程](https://zhuanlan.zhihu.com/p/64254201)》

![](imgs/01.png)

![](imgs/02.png)


### 3. 配置 caddy

- 登录 WEB 页面：`http://${vps-ip}/list/` 或 `http://${vps-ip}:9090`
- 默认 BasicAuth 登录账密: `admin / 123456`

> BasicAuth 的账号密码在第 1 步构建项目时已配置好


### 4. 配置定时更新 trackers

通过 trackers 可以优化下载速度，但是 trackers 是有有效时限的，在以下地方可以获取最新的 trackers 列表：

- [https://github.com/ngosang/trackerslist](https://github.com/ngosang/trackerslist)
- [https://torrents.io/tracker-list/](https://torrents.io/tracker-list/)
- [https://newtrackon.com/list](https://newtrackon.com/list)

通过 [`update_trackers.sh`](update_trackers.sh) 脚本可以自动刷新 trackers 配置。

建议把该脚本配置到 crontab ，每天更新一次：

```shell

# 编辑定时任务
crontab -e

# 每天更新一次 trackers
0 0 1 */2 0 /bin/sh /usr/local/qBitTorrent-docker/update_trackers.sh
```


## FAQ

### Q1： 为什么无法下载迅雷链接或磁力链接

qBitTorrent 并不能直接解析迅雷链接或磁力链接，它只能解析 torrent 种子文件、或种子文件的下载链接。

对于迅雷链接或磁力链接，需要使用其他工具先转换为 torrent 种子文件，具体方法可参考[这篇文章](https://my.oschina.net/u/1440553/blog/4480497 )。


### Q2： 下载文件保存到哪里？

仓库下的 [`downloads`](downloads) 挂载到 docker 容器，下载的文件均保存到这里。

在前端可以通过 caddy 下载，在后端可以到这个目录下载。

另外需要注意下载的文件大小不能超过 [`downloads`](downloads) 目录所在磁盘的空间大小。


### Q3： tracker 是什么？

在 BT 下载中的一个重要概念是 P2P。

P2P 是 peer-to-peer 的缩写，网络中的一个 peer（正在下载资源的客户端） 如何才能找到另外志同道合的 peer，Tracker 扮演着至关重要的月老作用：Tracker 是一个 HTTP 或者 UDP 服务器，作用是帮助 peer 找到其他拥有相同资源的 peer。

后来有了 DHT 网络之后，Tracker 的作用逐渐弱化，但是 Tracker 代表的这种中心化一定程度上相对 DHT 代表的去中心化效率还是比较高的。

> 详见《[BT 增强建议之 Tracker](https://0ranga.com/2018/08/27/bt-tracker/)》


### Q4： 忘记 qBitTorrent 的登录密码怎么办？

进入 docker_torrent 容器，修改 `/config/qBittorrent/qBittorrent.conf` 文件，删除 `WebUI/Password_PBKDF2` 配置项，然后重启进程即可还原为默认密码 `adminadmin`。


### Q5： 可以用手机管理 qBitTorrent 吗？

使用 [transdrone](https://cn.computerspywarescanner.com/art9494-transdrone-remotely-control-multiple-torrent-clients-from-android) 即可。

