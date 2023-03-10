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
RUN echo 'inited=$(cat /usr/local/libexec/inited)' >> /usr/local/libexec/run.sh
RUN echo 'if [ "$inited" != "1" ]; then' >> /usr/local/libexec/run.sh
RUN echo 'echo "[ldap]" >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo "Description=LDAP" >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo "Trace=OFF" >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo "TraceFile=stderr" >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo "Driver=MariaDB" >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo SERVER=${DB_IP} >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo PORT=${DB_PORT} >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo DATABASE=${DB_NAME} >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo USER=${DB_USER} >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo PASSWORD=${DB_PASSWD} >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
RUN echo 'echo "OPTION=4194304" >> /etc/odbc.ini' >> /usr/local/libexec/run.sh
WORKDIR "/usr/local/etc/openldap"
RUN rm -rf slapd.conf
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/slapd.conf
RUN echo 'echo "suffix          \"${LDAP_BASE_DN}\"" >> /usr/local/etc/openldap/slapd.conf' >> /usr/local/libexec/run.sh
RUN echo 'echo "rootdn          \"cn=root,${LDAP_BASE_DN}\"" >> /usr/local/etc/openldap/slapd.conf' >> /usr/local/libexec/run.sh
RUN echo 'echo "rootpw          ${LDAP_ROOT_PWD}" >> /usr/local/etc/openldap/slapd.conf' >> /usr/local/libexec/run.sh
RUN echo 'echo "dbname          ldap" >> /usr/local/etc/openldap/slapd.conf' >> /usr/local/libexec/run.sh
RUN echo 'echo "dbuser          ${DB_USER}" >> /usr/local/etc/openldap/slapd.conf' >> /usr/local/libexec/run.sh
RUN echo 'echo "dbpasswd        ${DB_PASSWD}" >> /usr/local/etc/openldap/slapd.conf' >> /usr/local/libexec/run.sh

WORKDIR "/usr/local/etc/openldap/dbschema"
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/backsql_create.sql
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/testdb_create.sql
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/testdb_data.sql
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/testdb_metadata.sql


WORKDIR "/usr/local/libexec/"
RUN wget https://raw.githubusercontent.com/smallru8/Dockerfiles/main/LDAP-Mariadb/conf.d/add_trigger.sh
RUN echo "sh /usr/local/libexec/add_trigger.sh" >> run.sh
RUN echo 'echo 1 >> inited' >> run.sh
RUN echo 'fi' >> run.sh

RUN echo "ip=\$(curl -k -s https://checkip4.spdyn.de)" >> run.sh
RUN echo "while [ \"\$ip\" == \"\" ]" >> run.sh
RUN echo "do" >> run.sh
RUN echo "sleep 5" >> run.sh
RUN echo "ip=\$(curl -k -s https://checkip4.spdyn.de)" >> run.sh
RUN echo "done" >> run.sh

RUN echo "isql ldap < /usr/local/etc/openldap/dbschema/backsql_create.sql" >> run.sh
RUN echo "isql ldap < /usr/local/etc/openldap/dbschema/testdb_create.sql" >> run.sh
#RUN echo "isql ldap < /usr/local/etc/openldap/dbschema/testdb_data.sql" >> run.sh
RUN echo "isql ldap < /usr/local/etc/openldap/dbschema/testdb_metadata.sql" >> run.sh

RUN echo "rm -rf /usr/local/etc/openldap/schema/sku_github.schema" >> run.sh

RUN echo "wget https://filedn.com/l9k5h2JrTgHFHmuFMPx0O6X/s2p/LDAP/sku_github.schema -P /usr/local/etc/openldap/schema/" >> run.sh
RUN echo "ulimit -n 8192 && /usr/local/libexec/slapd -d -256" >> run.sh

CMD ["sh","/usr/local/libexec/run.sh"]

EXPOSE 389
EXPOSE 389/udp
