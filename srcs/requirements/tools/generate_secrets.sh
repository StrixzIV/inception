#!/bin/bash

# Configs
INTRA_LOGIN="jikaewsi"
MAX_PASSWORD_ATTEMPT=3

function generate_password_secrets() {

	local n_attempt=0

    local user=$1
	local target_path=$2

	local password=""
	local password_confirm=""

	while [[ $try -lt $MAX_PASSWORD_ATTEMPT ]]; do

        echo -n "Enter the password for $user: "
        read -s password
        echo
        echo -n "Confirm the password for $user: "
        read -s password_confirm
        echo

        if [[ "$password" == "$password_confirm" ]]; then
            echo "$password" > "$target_path"
            echo "$user=$password" >> ./srcs/.env
            echo "Password has been write to srcs/.env and $target_path."
            break

        else
            echo "Passwords mismatch, please try again."
            ((n_attempt++))
        fi

        if [[ $n_attempt -eq $MAX_PASSWORD_ATTEMPT ]]; then
            echo "You have reached the maximum number of attempts."
            exit 1
        fi

	done

}

function make_password_file() {

    local user=$1
	local target_path=$2

    if [ -f $target_path ]; then
        echo "$target_path already exists."
    else
        generate_password_secrets $user $target_path
    fi

}


if [ -d ./secrets/ssl ]; then
	echo "SSL certificats & keys has already been generated."
else

	echo "Generating self-signed SSL certificate & keys...";

	mkdir -p ./secrets/ssl
	chmod 700 ./secrets/ssl

	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout ./secrets/ssl/nginx-selfsigned.key \
		-out ./secrets/ssl/nginx-selfsigned.crt \
		-subj "/C=TH/ST=Bangkok/L=Bangkok/O=42Bangkok/OU=42/CN=$(INTRA_LOGIN).42.fr"

	echo "Done! SSL certificats & keys are located at secrets/."

fi

if [ -f "srcs/.env" ]; then
    echo "srcs/.env already exists."
else
    cp srcs/.env.example srcs/.env
fi

make_password_file "MYSQL_ROOT_PASSWORD" "./secrets/mysql-root-password.txt"
make_password_file "MYSQL_PASSWORD" "./secrets/mysql-user-password.txt"
make_password_file "WORDPRESS_ADMIN_PASSWORD" "./secrets/wordpress-admin-password.txt"
make_password_file "WORDPRESS_USER_PASSWORD" "./secrets/wordpress-user-password.txt"
