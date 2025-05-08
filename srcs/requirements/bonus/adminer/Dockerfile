FROM debian:bullseye

RUN apt update && apt upgrade -y
RUN apt install -y php7.4-fpm \
                php7.4-cli \
                php7.4-mbstring \
                php7.4-xml \
                php7.4-curl \
                php7.4-json \
                php7.4-tokenizer \
                php7.4-mysql \
                php7.4-pgsql \
                php7.4-sqlite3 \
                php7.4-odbc \
                php7.4-pdo \
                wget

RUN apt clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash adminer

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/adminer.sh /

RUN chmod +x ./adminer.sh 

RUN mkdir -p /var/www/adminer
RUN wget -O /var/www/adminer/index.php "https://www.adminer.org/latest.php"
RUN chmod 755 /var/www/adminer && chown -R adminer:adminer /var/www/adminer/

RUN mkdir -p /run/php/
RUN chown -R adminer:adminer /run/php

RUN ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm

ENTRYPOINT ["/adminer.sh"]
