FROM debian:bullseye

EXPOSE 6969

RUN apt update && apt upgrade -y
RUN apt install -y python3
RUN apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

COPY html /var/www/html
COPY assets /var/www/html/assets

ENTRYPOINT ["python3", "-m" , "http.server", "6969"]
