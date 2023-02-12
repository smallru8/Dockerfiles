FROM rockylinux:9.1
MAINTAINER smallru8

ENV LDAP_BASE_DN1=
ENV LDAP_BASE_DN2=
ENV LDAP_ROOT_PWD=

ENV DB_IP=127.0.0.1
ENV DB_NAME=db
ENV DB_PORT=3306
ENV DB_USER=username
ENV DB_PASSWD=d=password

RUN dnf update -y
RUN dnf install -y wget tar libtool-ltdl libtool-ltdl-devel unixODBC.x86_64 curl
WORKDIR "/tmp"
RUN wget https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.3.tgz
RUN tar zxvf openldap-2.6.3.tgz
WORKDIR "/tmp/openldap-2.6.3"
RUN ./configure --enable-sql --enable-ppolicy --enable-overlays --enable-modules
RUN make depend
RUN make
WORKDIR "/tmp/openldap-2.6.3/servers"
RUN make install
WORKDIR "/tmp/openldap-2.6.3/contrib/slapd-modules/passwd/pbkdf2"
RUN make
RUN make install
RUN { echo "[MariaDB]" ; echo "Description     = ODBC for MariaDB"; echo "Driver          = /usr/lib/libmaodbc.so"; echo "Driver64        = /usr/lib64/libmaodbc.so"; echo "FileUsage       = 1"; } >> /etc/odbcinst.ini
RUN echo "[ldap]" >> /etc/odbc.ini
RUN echo "Description=LDAP" >> /etc/odbc.ini
RUN echo "Trace=OFF" >> /etc/odbc.ini
RUN echo "TraceFile=stderr" >> /etc/odbc.ini
RUN echo "Driver=MariaDB" >> /etc/odbc.ini
RUN echo SERVER=${DB_IP} >> /etc/odbc.ini
RUN echo PORT=${DB_PORT} >> /etc/odbc.ini
RUN echo DATABASE=${DB_NAME} >> /etc/odbc.ini
RUN echo USER=${DB_USER} >> /etc/odbc.ini
RUN echo PASSWORD=${DB_PASSWD} >> /etc/odbc.ini
RUN echo "OPTION=4194304" >> /etc/odbc.ini
WORKDIR "/usr/local/etc/openldap"
RUN rm -rf slapd.conf
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/sldapd.conf
RUN echo suffix          \"dc=${LDAP_BASE_DN1},dc=${LDAP_BASE_DN2}\" >> /usr/local/etc/openldap/slapd.conf
RUN echo rootdn          \"cn=root,dc=${LDAP_BASE_DN1},dc=${LDAP_BASE_DN2}\" >> /usr/local/etc/openldap/slapd.conf
RUN echo rootpw          ${LDAP_ROOT_PWD} >> /usr/local/etc/openldap/slapd.conf
RUN echo dbname          ldap >> /usr/local/etc/openldap/slapd.conf
RUN echo dbuser          ${DB_USER} >> /usr/local/etc/openldap/slapd.conf
RUN echo dbpasswd        ${DB_PASSWD} >> /usr/local/etc/openldap/slapd.conf
WORKDIR "/tmp"
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/backsql_create.sql
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/testdb_create.sql
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/testdb_data.sql
RUN isql ldap < backsql_create.sql
RUN isql ldap < testdb_create.sql
RUN isql ldap < testdb_data.sql
WORKDIR "/usr/local/libexec/"

RUN echo "ip=$(curl -k -s https://checkip6.spdyn.de)" >> run.sh
RUN echo "while [ \"$ip\" == \"\" ]" >> run.sh
RUN echo "do" >> run.sh
RUN echo "sleep 5" >> run.sh
RUN echo "ip=$(curl -k -s https://checkip6.spdyn.de)" >> run.sh
RUN echo "done" >> run.sh

RUN echo "rm -rf /usr/local/etc/openldap/schema/sku_github.schema" >> run.sh

RUN echo "wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/LDAP/sku_github.schema -P /usr/local/etc/openldap/schema/" >> run.sh
RUN echo "/usr/local/libexec/slapd" >> run.sh

CMD ["sh","/usr/local/libexec/run.sh"]

EXPOSE 389
EXPOSE 389/udp
