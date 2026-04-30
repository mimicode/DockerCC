#!/bin/bash
# entrypoint.sh - 自动加载环境后执行命令

# 加载 /etc/profile.d/ 下所有环境脚本
if [ -d /etc/profile.d ]; then
    for f in /etc/profile.d/*.sh; do
        if [ -r "$f" ]; then
            . "$f"
        fi
    done
fi

# 加载用户 bashrc（如果有自定义环境）
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# 执行传入的命令
exec "$@"
