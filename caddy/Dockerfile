FROM caddy:latest
MAINTAINER EXP

ARG USERNAME=admin
ARG PASSWORD=123456


ADD ./Caddyfile /usr/local/caddy/Caddyfile
RUN sed -i "s/USERNAME/${USERNAME}/g" /usr/local/caddy/Caddyfile
RUN sed -i -e "s/PASSWORD/"`caddy hash-password --plaintext ${PASSWORD}`"/g" /usr/local/caddy/Caddyfile

RUN mkdir /downloads/


EXPOSE 9090
WORKDIR /usr/local/caddy/

CMD [ "/usr/bin/caddy", "run" ]
