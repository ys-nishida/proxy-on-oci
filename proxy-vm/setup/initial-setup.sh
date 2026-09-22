#!/bin/bash
# IP 付与し直しは、コンソールから手動で実施する事

# 初期セットアップ
apt-get update

# dpcker engine install
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install tools
sudo apt install -y apache2-utils net-tools

# timezone set
sudo timedatectl set-timezone Asia/Tokyo

# cron 設定 import
sudo cp ./cron-proxy-schedule /etc/cron.d/proxy-schedule
sudo chmod 644 /etc/cron.d/proxy-schedule
sudo usermod -aG docker ubuntu

# squid user 設定 : Basic 認証を有効にすると、PWが平文でインターネットに流れてしまい、逆に脆弱になるリスク
# cp ./squid-passwd ../docker-squid/conf/squid_passwd

# OS FWの解放 位置に注意！以下でREJECTの前に入っているかどうかを確認すること
# sudo iptables -L
# squid 用
sudo iptables -I INPUT 4 -m state --state NEW -p tcp --dport 10080 -j ACCEPT
sudo iptables -I INPUT 4 -m state --state NEW -p tcp --dport 443 -j ACCEPT
