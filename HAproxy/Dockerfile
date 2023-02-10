FROM haproxy:2.7-alpine

USER root
RUN apk update && apk add wget
WORKDIR /usr/local/etc/haproxy/haproxy.cfg
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/HAproxy/haproxy.cfg
