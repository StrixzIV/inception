FROM debian:bullseye

USER root
EXPOSE 3306
VOLUME /var/lib/mysql

RUN apt update && apt upgrade -y
RUN apt install mariadb-server -y
RUN apt clean && rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/initialize_db.sh /usr/local/bin/
COPY ./tools/start_mariadb.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/initialize_db.sh /usr/local/bin/start_mariadb.sh

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod +x /var/run/mysqld

ENTRYPOINT [ "/usr/local/bin/start_mariadb.sh" ]