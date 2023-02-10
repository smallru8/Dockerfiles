FROM haproxy:2.7-alpine

USER root
RUN apk update && apk add wget
USER haproxy
WORKDIR /var/lib/haproxy
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/HAproxy/start.sh
RUN chmod +x start.sh
CMD ["sh","start.sh"]
