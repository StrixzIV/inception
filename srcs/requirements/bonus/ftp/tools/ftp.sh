#!/bin/bash

set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

echo "USER: $FTP_USER"
echo "PASS: $FTP_PASSWORD"

service vsftpd start

# Create user for FTP + add ownership for wordpress
adduser $FTP_USER --disabled-password
echo "$FTP_USER:$FTP_PASSWORD" | /usr/sbin/chpasswd
echo "$FTP_USER" | tee -a /etc/vsftpd.userlist 

mkdir /home/$FTP_USER/ftp

chown nobody:nogroup /home/$FTP_USER/ftp
chmod a-w /home/$FTP_USER/ftp

mkdir /home/$FTP_USER/ftp/files
chown $FTP_USER:$FTP_USER /home/$FTP_USER/ftp/files

service vsftpd stop

/usr/sbin/vsftpd