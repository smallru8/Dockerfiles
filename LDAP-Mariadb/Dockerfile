FROM rockylinux:9.1
MAINTAINER smallru8

ENV LDAP_BASE_DN=""
ENV LDAP_ROOT_PWD=""

ENV DB_IP=""
ENV DB_NAME=""
ENV DB_PORT=3306
ENV DB_USER=""
ENV DB_PASSWD=""

RUN dnf update -y
RUN dnf install -y dnf-plugins-core
RUN dnf -y config-manager --set-enabled crb
RUN dnf install -y wget libtool-ltdl unixODBC.x86_64 gcc unixODBC-devel.x86_64 openssl.x86_64 openssl-devel.x86_64 mariadb-connector-odbc
RUN dnf --enablerepo=resilientstorage install -y libtool-ltdl-devel
WORKDIR "/tmp"
RUN wget https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.3.tgz
RUN tar zxvf openldap-2.6.3.tgz
WORKDIR "/tmp/openldap-2.6.3"
RUN ./configure --enable-sql --enable-ppolicy --enable-overlays --enable-modules 
RUN make depend
RUN make
WORKDIR "/tmp/openldap-2.6.3/servers"
RUN make install
WORKDIR "/tmp/openldap-2.6.3/libraries"
RUN make install
WORKDIR "/tmp/openldap-2.6.3/contrib/slapd-modules/passwd/pbkdf2"
RUN make
RUN make install
#RUN { echo "[MariaDB]" ; echo "Description     = ODBC for MariaDB"; echo "Driver          = /usr/lib/libmaodbc.so"; echo "Driver64        = /usr/lib64/libmaodbc.so"; echo "FileUsage       = 1"; } >> /etc/odbcinst.ini
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
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/slapd.conf
RUN echo "suffix          \"${LDAP_BASE_DN}\"" >> /usr/local/etc/openldap/slapd.conf
RUN echo "rootdn          \"cn=root,dc=${LDAP_BASE_DN1},dc=${LDAP_BASE_DN2}\"" >> /usr/local/etc/openldap/slapd.conf
RUN echo "rootpw          ${LDAP_ROOT_PWD}" >> /usr/local/etc/openldap/slapd.conf
RUN echo "dbname          ldap" >> /usr/local/etc/openldap/slapd.conf
RUN echo "dbuser          ${DB_USER}" >> /usr/local/etc/openldap/slapd.conf
RUN echo "dbpasswd        ${DB_PASSWD}" >> /usr/local/etc/openldap/slapd.conf

WORKDIR "/usr/local/etc/openldap/dbschema"
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/backsql_create.sql
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/testdb_create.sql
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/testdb_data.sql

WORKDIR "/usr/local/libexec/"

RUN echo "ip=\$(curl -k -s https://checkip4.spdyn.de)" >> run.sh
RUN echo "while [ \"\$ip\" == \"\" ]" >> run.sh
RUN echo "do" >> run.sh
RUN echo "sleep 5" >> run.sh
RUN echo "ip=\$(curl -k -s https://checkip4.spdyn.de)" >> run.sh
RUN echo "done" >> run.sh

RUN echo "isql ldap < /usr/local/etc/openldap/dbschema/backsql_create.sql" >> run.sh
RUN echo "isql ldap < /usr/local/etc/openldap/dbschema/testdb_create.sql" >> run.sh
RUN echo "isql ldap < /usr/local/etc/openldap/dbschema/testdb_data.sql" >> run.sh

RUN echo "rm -rf /usr/local/etc/openldap/schema/sku_github.schema" >> run.sh

RUN echo "wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/LDAP/sku_github.schema -P /usr/local/etc/openldap/schema/" >> run.sh
RUN echo "/usr/local/libexec/slapd" >> run.sh

CMD ["sh","/usr/local/libexec/run.sh"]

EXPOSE 389
EXPOSE 389/udp
