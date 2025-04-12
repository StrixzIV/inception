#!/bin/bash

mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='';"
mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS test;"
mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"

mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
