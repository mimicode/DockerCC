#!/bin/bash
set -e

echo ">>> 安装 Node.js 扩展工具..."

# pnpm 和 yarn 安装到 /usr/local/bin（已在 PATH）
npm install -g pnpm yarn --registry=https://registry.npmmirror.com --force

# bun 下载到 /usr/local/bin
curl -fsSL "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-linux-x64.zip" -o /tmp/bun.zip
unzip -o /tmp/bun.zip -d /tmp/bun_extract
mv /tmp/bun_extract/bun-linux-x64/bun /usr/local/bin/bun
rm -rf /tmp/bun.zip /tmp/bun_extract

echo ">>> Node.js 扩展工具安装完成"
