FROM debian:bullseye

RUN apt update && apt upgrade -y
RUN apt install -y vsftpd gettext ftp
RUN apt clean && rm -rf /var/lib/apt/lists/*

COPY tools/ftp.sh /
COPY conf/vsftpd.conf.template /etc/vsftpd.conf.template

RUN chmod +x /ftp.sh
RUN mkdir -p /var/run/vsftpd/empty
RUN chmod 755 /var/run/vsftpd/empty

ENTRYPOINT ["/ftp.sh"]
