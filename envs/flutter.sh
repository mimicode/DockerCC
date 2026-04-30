#!/bin/bash
set -e

FLUTTER_VERSION="3.38.5"
FLUTTER_MIRROR="https://storage.flutter-io.cn/flutter_infra_release/releases/stable/linux"

echo ">>> 安装 Flutter ${FLUTTER_VERSION}..."

# 下载 Flutter SDK
wget -q "${FLUTTER_MIRROR}/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -O /tmp/flutter.tar.xz

# 解压到 /opt/flutter
tar xf /tmp/flutter.tar.xz -C /opt
rm /tmp/flutter.tar.xz

# 设置国内镜像源
echo 'export FLUTTER_HOME=/opt/flutter' > /etc/profile.d/flutter.sh
echo 'export PATH=/opt/flutter/bin:$PATH' >> /etc/profile.d/flutter.sh
echo 'export PUB_HOSTED_URL=https://pub.flutter-io.cn' >> /etc/profile.d/flutter.sh
echo 'export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn' >> /etc/profile.d/flutter.sh

echo ">>> Flutter ${FLUTTER_VERSION} 安装完成"
