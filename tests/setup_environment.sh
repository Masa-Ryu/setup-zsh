#!/usr/bin/env bash
docker-compose up -d
chmod -x setup.sh
docker cp setup.sh zsh_installer_test:/root/
docker exec -it -u root zsh_installer_test bash /root/setup.sh
