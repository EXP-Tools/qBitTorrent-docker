FROM linuxserver/qbittorrent
MAINTAINER EXP

RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && \
    apt-get update -y

RUN mkdir -p /downloads/ && \
    mkdir -p /torrent/config/qBittorrent/

EXPOSE 8080
WORKDIR /

CMD [ "/usr/bin/qbittorrent-nox", "--webui-port=8080" ]
