FROM haproxy:2.7-alpine

USER root
RUN apk update && apk add wget curl

WORKDIR /var/lib/haproxy
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/cloudflare_ddns.sh
RUN chmod +x cloudflare_ddns.sh
RUN echo "*/5 * * * * sh /var/lib/haproxy/cloudflare_ddns.sh" >> /var/spool/cron/crontabs/root
RUN crond
RUN wget -O /usr/local/etc/haproxy/haproxy.cfg https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/hap/haproxy.cfg
