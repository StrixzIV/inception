FROM debian:bullseye

EXPOSE 6379

RUN apt update && apt upgrade -y
RUN apt install -y redis-server
RUN apt clean && rm -rf /var/lib/apt/lists/*

COPY tools/redis.sh /
COPY conf/redis.conf /etc/redis

RUN chmod +x /redis.sh

ENTRYPOINT ["/redis.sh"]
