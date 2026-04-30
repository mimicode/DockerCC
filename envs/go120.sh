#!/bin/bash
set -e

GO_VERSION="1.20"
MIRROR="https://golang.google.cn/dl/"

echo ">>> 安装 Go ${GO_VERSION}..."
wget -q "${MIRROR}go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz

# 写入 profile.d，entrypoint 会自动 source
echo 'export PATH=/usr/local/go/bin:$PATH' > /etc/profile.d/go.sh
echo 'export GOPATH=/go' >> /etc/profile.d/go.sh
echo 'export GOPROXY=https://goproxy.cn,direct' >> /etc/profile.d/go.sh

echo ">>> Go ${GO_VERSION} 安装完成"
