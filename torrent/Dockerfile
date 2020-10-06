# https://hub.docker.com/r/linuxserver/qbittorrent
FROM linuxserver/qbittorrent
MAINTAINER EXP

ENV PUID=1000
ENV PGID=1000
ENV TZ=Aisa/Shanghai
ENV UMASK_SET=022
ENV WEBUI_PORT=8080

RUN mkdir -p /downloads/incomplete/ && \
    mkdir -p /config/qBittorrent/
    
ADD ./qBittorrent_new.conf /config/qBittorrent/qBittorrent_new.conf

EXPOSE 8080
EXPOSE 9000
EXPOSE 6881
EXPOSE 6881/udp
WORKDIR /config

CMD [ "/usr/bin/qbittorrent-nox", "--webui-port=8080" ]
