#!/bin/bash

N_ATTEMPTS=0
N_ATTEMPTS_MAX=10
ATTEMPT_INTERVALS=5
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)

mysqld --skip-networking &

connect_no_password() {
	mariadb -u root -e "SELECT 1;" > /dev/null 2>&1
}

connect_with_password() {
    mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1
}

db_init_check_no_password() {
	mariadb -u root -e "USE $MYSQL_DATABASE;" > /dev/null 2>&1
}

db_init_check_with_password() {
    mariadb -u root -p "$MYSQL_ROOT_PASSWORD" -e "USE $MYSQL_DATABASE;" > /dev/null 2>&1
}

until connect_no_password || connect_with_password; do

    N_ATTEMPTS=$((N_ATTEMPTS+1))

    if [ $attempt -ge $MAX_ATTEMPTS ]; then
		echo "Cannot connect to MariaDB after $MAX_ATTEMPTS attempts. Exiting..."
		exit 1
	fi

    echo "Starting connection to MariaDB... (Attempt $N_ATTEMPTS/$MAX_ATTEMPTS)."
    sleep $ATTEMPT_INTERVALS

done

echo "Initializing MariaDB..."

if db_init_check_no_password || db_init_check_with_password; then
    echo "$MYSQL_DATABASE already exists. Skipping initialization..."
else
    echo "Executing initialization script..."
    bash /usr/local/bin/initialize_db.sh
fi


echo "Initialization complete. Restarting MariaDB..."
mysqladmin -u root -p "$MYSQL_ROOT_PASSWORD" shutdown

echo "MariaDB is ready!"
mysqld
