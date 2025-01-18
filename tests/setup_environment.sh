#!/usr/bin/env bash
docker-compose up -d
chmod -x setup.sh
docker cp setup.sh ubuntu:/root/
docker exec -it -u root ubuntu bash /root/setup.sh
