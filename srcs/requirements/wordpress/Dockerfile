FROM debian:bullseye

USER root
EXPOSE 9000
WORKDIR /var/www/html

RUN apt update && apt upgrade -y
RUN apt install wget php php7.4-fpm php7.4-mysql mariadb-client -y
RUN apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php && \
    chown www-data:www-data /run/php && \
    chmod 755 /run/php

RUN wget https://wordpress.org/wordpress-6.6.2.tar.gz -P /tmp
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp/

RUN tar -xvf /tmp/wordpress-6.6.2.tar.gz -C /var/www/html && \
	mv /var/www/html/wordpress/* /var/www/html/ && \
	rm -rf /tmp/wordpress-6.6.2.tar.gz /var/www/html/wordpress && \
	chown -R www-data:www-data /var/www/html

RUN chmod +x /tmp/wp-cli.phar && mv /tmp/wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["/bin/bash", "/usr/local/bin/setup.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]
