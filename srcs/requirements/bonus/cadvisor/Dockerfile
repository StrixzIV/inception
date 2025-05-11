FROM debian:bullseye

EXPOSE 8080

RUN apt update && apt upgrade -y
RUN apt install -y wget
RUN apt clean && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/google/cadvisor/releases/download/v0.52.1/cadvisor-v0.52.1-linux-amd64
RUN mv cadvisor-v0.52.1-linux-amd64 cadvisor
RUN chmod +x cadvisor

CMD ["./cadvisor"]
