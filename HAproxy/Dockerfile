FROM alpine:3.17

# roughly, https://git.alpinelinux.org/aports/tree/main/haproxy/haproxy.pre-install?h=3.12-stable
RUN set -eux; \
	addgroup --gid 99 --system haproxy; \
	adduser \
		--disabled-password \
		--home /var/lib/haproxy \
		--ingroup haproxy \
		--no-create-home \
		--system \
		--uid 99 \
		haproxy \
	; \
	mkdir /var/lib/haproxy; \
	chown haproxy:haproxy /var/lib/haproxy

ENV HAPROXY_VERSION 2.7.2
ENV HAPROXY_URL https://www.haproxy.org/download/2.7/src/haproxy-2.7.2.tar.gz
ENV HAPROXY_SHA256 63bc6ec0302d0ebbe1fa769c19606640de834ac8cb07447b80799cb563dc0f3f

# see https://sources.debian.net/src/haproxy/jessie/debian/rules/ for some helpful navigation of the possible "make" arguments
RUN set -eux; \
	\
	apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		linux-headers \
		lua5.3-dev \
		make \
		openssl \
		openssl-dev \
		pcre2-dev \
		readline-dev \
		tar \
	; \
	\
	wget -O haproxy.tar.gz "$HAPROXY_URL"; \
	echo "$HAPROXY_SHA256 *haproxy.tar.gz" | sha256sum -c; \
	mkdir -p /usr/src/haproxy; \
	tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1; \
	rm haproxy.tar.gz; \
	\
	makeOpts=' \
		TARGET=linux-musl \
		USE_GETADDRINFO=1 \
		USE_LUA=1 LUA_INC=/usr/include/lua5.3 LUA_LIB=/usr/lib/lua5.3 \
		USE_OPENSSL=1 \
		USE_PCRE2=1 USE_PCRE2_JIT=1 \
		USE_PROMEX=1 \
		\
		EXTRA_OBJS=" \
		" \
	'; \
	\
	nproc="$(getconf _NPROCESSORS_ONLN)"; \
	eval "make -C /usr/src/haproxy -j '$nproc' all $makeOpts"; \
	eval "make -C /usr/src/haproxy install-bin $makeOpts"; \
	\
	mkdir -p /usr/local/etc/haproxy; \
	cp -R /usr/src/haproxy/examples/errorfiles /usr/local/etc/haproxy/errors; \
	rm -rf /usr/src/haproxy; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-network --virtual .haproxy-rundeps $runDeps; \
	apk del --no-network .build-deps; \
	\
# smoke test
	haproxy -v

# https://www.haproxy.org/download/1.8/doc/management.txt
# "4. Stopping and restarting HAProxy"
# "when the SIGTERM signal is sent to the haproxy process, it immediately quits and all established connections are closed"
# "graceful stop is triggered when the SIGUSR1 signal is sent to the haproxy process"
STOPSIGNAL SIGUSR1

USER root
RUN echo "nameserver 2001:4860:4860::8844" >> /etc/resolv.conf
RUN apk update && apk add wget curl bash dos2unix
RUN apk add --no-cache --upgrade grep

RUN wget -O /usr/local/etc/haproxy/haproxy.cfg https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/hap/haproxy.cfg

WORKDIR /var/lib/haproxy
RUN wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/cloudflare_ddns.sh
RUN chmod +x cloudflare_ddns.sh
RUN wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/hap/exit.sh
RUN chmod +x exit.sh
RUN echo "*/5 * * * * /bin/bash /var/lib/haproxy/cloudflare_ddns.sh" >> /var/spool/cron/crontabs/root
RUN echo "*/5 * * * * /bin/bash /var/lib/haproxy/exit.sh" >> /var/spool/cron/crontabs/root
RUN wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/hap/run.sh
RUN chmod +x run.sh

CMD ["/bin/bash","run.sh"]
