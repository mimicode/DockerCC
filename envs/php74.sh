#!/bin/bash
set -e

echo ">>> 安装 PHP 7.4 CLI..."

# 添加 Surý PHP 仓库
apt-get update
apt-get install -y apt-transport-https lsb-release ca-certificates curl wget
wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

apt-get update

# 安装 PHP 7.4 及扩展
apt-get install -y --no-install-recommends \
    php7.4-cli \
    php7.4-curl \
    php7.4-json \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    unzip

# 创建 /usr/bin/php 软链接
ln -sf /usr/bin/php7.4 /usr/bin/php

# 安装 Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 清理 apt 缓存
rm -rf /var/lib/apt/lists/*

echo ">>> PHP 7.4 安装完成"
