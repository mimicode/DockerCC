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

# 将 settings.json 中的 127.0.0.1/localhost 替换为 host.docker.internal
if [ -f "$HOME/.claude/settings.json" ]; then
    _BASE_URL=$(node -e "
      try {
        const s = JSON.parse(require('fs').readFileSync('$HOME/.claude/settings.json','utf8'));
        const url = (s.env && s.env.ANTHROPIC_BASE_URL) || s.ANTHROPIC_BASE_URL;
        if (url) {
          console.log(url.replace(/127\.0\.0\.1|localhost/g, 'host.docker.internal'));
        }
      } catch(e) {}
    " 2>/dev/null)
    if [ -n "$_BASE_URL" ]; then
        export ANTHROPIC_BASE_URL="$_BASE_URL"
    fi
fi

# 执行传入的命令
exec "$@"
