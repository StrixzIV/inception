#!/bin/bash

set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

echo "Setting up FTP server..."
echo "USER: $FTP_USER"

echo "Rendering /etc/vsftpd.conf from template..."
envsubst < /etc/vsftpd.conf.template > /etc/vsftpd.conf

if ! id "$FTP_USER" &>/dev/null; then
    adduser --disabled-password --gecos "" "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    usermod -aG www-data $FTP_USER
fi

chown -R $FTP_USER:$FTP_USER /var/www/html
chmod -R 775 /var/www/html
chmod g+s /var/www/html

echo "$FTP_USER" | tee -a /etc/vsftpd.userlist > /etc/vsftpd.chroot_list
usermod -d /var/www/html $FTP_USER

echo "Starting vsftpd..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
