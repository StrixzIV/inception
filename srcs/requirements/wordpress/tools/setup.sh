#!/bin/bash

if mysqladmin ping -h mariadb --silent; then

	echo "Succesfully connected to MariaDB. Initating Wordpress setup..."

	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php

	if ! wp core is-installed --allow-root --path=/var/www/html; then
		wp core install --allow-root \
			--url=$WORDPRESS_URL \
			--title=$WORDPRESS_TITLE \
			--admin_user=$WORDPRESS_ADMIN_USER \
			--admin_password=$WORDPRESS_ADMIN_PASSWORD \
			--admin_email=$WORDPRESS_ADMIN_EMAIL \
			--path=/var/www/html
	else
		echo "WordPress is already installed. Skiping Wordpress MySQL setup..."
	fi

	if wp user list --allow-root --field=user_login | grep -q "^$WORDPRESS_USER$"; then
		echo "User '$WORDPRESS_USER' already exists. Skiping Wordpress test user setup..."
	else

		wp user create --allow-root \
			$WORDPRESS_USER $WORDPRESS_USER_EMAIL \
			--role=author \
			--user_pass=$WORDPRESS_USER_PASSWORD \
			--path=/var/www/html

		echo "User '$WORDPRESS_USER' has been created."

	fi

	wp plugin update --all --allow-root --path=/var/www/html
	chown -R www-data:www-data /var/www/html
	/usr/sbin/php-fpm7.4 -F

else
	echo "Cannot connect to MariaDB. Please try again."
    sleep 5
	exit 1
fi
