FROM debian:bullseye

EXPOSE 443

RUN apt update && apt upgrade -y
RUN apt install nginx -y
RUN apt clean && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
