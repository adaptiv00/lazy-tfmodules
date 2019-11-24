#!/usr/bin/env bash

# sshpass installed with docker

# sudo apt-get update -qq >/dev/null && sudo apt-get install -y -qq sshpass >/dev/null
for host in "$@"
do
    echo " -- connecting to: $host"
    sshpass -p $APP_PASS ssh-copy-id -o StrictHostKeyChecking=no $APP_USER@$host
done
