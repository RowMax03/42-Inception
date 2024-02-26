FROM debian:11

RUN apt-get update
RUN apt-get install -y mariadb-server
RUN apt-get install -y mariadb-client
RUN rm -rf /var/lib/apt/lists/*

# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld


ARG MYSQL_ROOT_PASSWORD

ENV MYSQL_ROOT_PASSWORD=$DB_ROOT_PW

# Copy entrypont script to rootdir
COPY tools/network.cnf /etc/mysql/conf.d/
COPY tools/entrypoint.sh /entrypoint.sh

COPY conf/wordpress.sql /tmp/wordpress.sql
RUN chmod 777 /tmp/wordpress.sql

EXPOSE 3306

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
