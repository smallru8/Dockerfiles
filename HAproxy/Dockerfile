FROM haproxy:2.7-alpine

USER root
RUN apk update && apk add wget

WORKDIR /var/lib/haproxy
RUN wget -O /usr/local/etc/haproxy/haproxy.cfg https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/hap/haproxy.cfg
