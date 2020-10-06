FROM linuxserver/qbittorrent
MAINTAINER EXP

RUN mkdir -p /downloads/ && \
    mkdir -p /torrent/config/qBittorrent/

EXPOSE 8080
EXPOSE 6881
EXPOSE 6881/udp
WORKDIR /

CMD [ "/usr/bin/qbittorrent-nox", "--webui-port=8080" ]
