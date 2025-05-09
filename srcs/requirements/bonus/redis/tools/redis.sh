#!/bin/bash

set -e

mkdir -p data
chown redis:redis data/

echo "Starting redis-server..."
exec redis-server /etc/redis/redis.conf --protected-mode no
