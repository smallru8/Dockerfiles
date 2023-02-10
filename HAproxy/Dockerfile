FROM haproxy:2.7-alpine

USER root
RUN apk update && apk add wget curl bash dos2unix
RUN apk add --no-cache --upgrade grep

WORKDIR /var/lib/haproxy
RUN wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/cloudflare_ddns.sh
RUN chmod +x cloudflare_ddns.sh
RUN echo "*/5 * * * * /bin/bash /var/lib/haproxy/cloudflare_ddns.sh" >> /var/spool/cron/crontabs/root
RUN wget -O /usr/local/etc/haproxy/haproxy.cfg https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/hap/haproxy.cfg
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/HAproxy/run.sh
RUN echo "nameserver 2001:4860:4860::8844" >> /etc/resolv.conf

CMD ["/bin/bash","run.sh"]
