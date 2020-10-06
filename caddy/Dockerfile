FROM caddy
MAINTAINER EXP

ARG CADDY_USER=admin
ARG CADDY_PASS=123456


ADD ./Caddyfile /usr/local/caddy/Caddyfile
RUN sed -i "s/USERNAME/${CADDY_USER}/g" /usr/local/caddy/Caddyfile
RUN sed -i -e "s/PASSWORD/"`caddy hash-password --plaintext ${CADDY_PASS}`"/g" /usr/local/caddy/Caddyfile

RUN mkdir /downloads/


EXPOSE 9090
WORKDIR /usr/local/caddy/

CMD [ "/usr/bin/caddy", "run" ]
