#!/usr/bin/env bash

APP_USER="$1"
APP_PASS="$2"
APP_UID="$3"
APP_GID="$4"

# sudo userdel -r $APP_USER
if [[ "$USER" != "$APP_USER" ]]; then
    sudo groupadd -g $APP_GID $APP_USER
    sudo useradd -m -d /home/$APP_USER -s /bin/bash -u $APP_UID -g $APP_GID $APP_USER
    echo "$APP_USER:$APP_PASS" | sudo chpasswd
    sudo sed -i.bak 's/PasswordAuthentication/# PasswordAuthentication/g' /etc/ssh/sshd_config
    echo "PasswordAuthentication   yes" | sudo tee -a /etc/ssh/sshd_config
    sudo service sshd restart
    echo "$APP_USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$APP_USER
fi