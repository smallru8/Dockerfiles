FROM rockylinux:9.1
MAINTAINER smallru8

ENV RADIUS_PASSWD=""
ENV RADIUS_ROOT_DN=""
ENV RADIUS_ROOT_PWD=""
ENV RADIUS_BASE_DN=""
ENV RADIUS_OBJCLASS=""

RUN dnf install -y freeradius freeradius-ldap freeradius-utils freeradius-krb5 wget
RUN cp /etc/raddb/clients.conf /etc/raddb/clients.conf.template
RUN rm -rf /etc/raddb/mods-enabled/eap

WORKDIR "/etc/raddb/policy.d"
RUN rm -rf eap
RUN rm -rf ldap
RUN wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/Download/radius_config/policy.d/ldap

WORKDIR "/etc/raddb/sites-enabled"
RUN rm -rf default
RUN rm -rf inner-tunnel
RUN wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/radius/default
RUN wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/radius/inner-tunnel

WORKDIR "/usr/local/libexec/"
RUN wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/radius/run.sh

CMD ["sh","/usr/local/libexec/run.sh"]

EXPOSE 1812/UDP
