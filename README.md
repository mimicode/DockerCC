# Docker Claude Code

用 Docker 容器隔离运行 Claude Code CLI，消除 `--dangerously-skip-permissions` 的安全顾虑，同时通过包装脚本实现与原生 `claude` 命令一致的使用体验。

## 特性

- **安全隔离** - Claude Code 运行在容器内，宿主机文件只暴露工作目录和配置目录
- **零配置复用** - 通过目录挂载复用本地 Claude 配置（settings.json、CLAUDE.md、memory）
- **环境可组合** - 按需构建不同开发环境的镜像（Go / PHP / Node.js）
- **国内镜像加速** - 所有下载源使用国内镜像，避免网络问题

## 项目结构

```
DockerCC/
├── Dockerfile       # 镜像构建文件
├── entrypoint.sh   # 自动加载环境变量
├── dclaude         # Linux/Mac Shell 脚本
├── dclaude.bat     # Windows 批处理脚本
├── envs/           # 可选环境安装脚本
│   ├── go120.sh    # Go 1.20
│   ├── php74.sh    # PHP 7.4 + Composer
│   └── nodejs.sh   # pnpm + yarn + bun
└── README.md
```

## 快速开始

### 1. 使用脚本

**Windows:**
```cmd
:: 直接运行（首次自动构建镜像）
D:\desk\DockerCC\dclaude.bat

:: 指定环境
D:\desk\DockerCC\dclaude.bat -e go120
D:\desk\DockerCC\dclaude.bat -e php74
D:\desk\DockerCC\dclaude.bat -e nodejs

:: 组合环境
D:\desk\DockerCC\dclaude.bat -e go120,nodejs

:: 透传 claude 参数
D:\desk\DockerCC\dclaude.bat -e go120 -- --model claude-opus-4-7
```

**Linux/Mac:**
```bash
chmod +x dclaude

./dclaude
./dclaude -e go120
./dclaude -e php74
./dclaude -e nodejs
./dclaude -e go120,nodejs
```

> 首次运行时会自动构建镜像，后续运行直接使用已构建的镜像。

### 3. 环境详情

| 环境 | 标签 | 工具 | 版本 |
|------|------|------|------|
| 基础 | latest | claude-code | 2.1.123 |
| Go | go120 | go, gofmt | 1.20 |
| PHP | php74 | php, composer | 7.4 / 2.9 |
| Node.js | nodejs | pnpm, yarn, bun | 10.33 / 1.22 / 1.3 |

## 工作原理

```
宿主机                          容器
~/.claude/  ──── 挂载 ──────► /home/claude/.claude/
/your/project/ ── 挂载 ──────► /workspace/

ANTHROPIC_API_KEY ── 透传 ──► 环境变量
```

- `/workspace` - 挂载当前工作目录，Claude 只能操作此目录
- `~/.claude` - 挂载为读写，配置复用且可写 memory
- `--dangerously-skip-permissions` - 容器内跳过，隔离已提供安全保障
- `--user` - 以宿主机用户运行，写入文件属主正确
- `--rm` - 退出即销毁容器，不留痕迹

## 环境变量

| 变量 | 说明 |
|------|------|
| `ANTHROPIC_API_KEY` | Claude API Key，自动透传到容器 |

## 安全边界

容器只暴露 2 个目录：
- 工作目录（当前 pwd）
- Claude 配置目录（~/.claude）

其他宿主机文件完全隔离，不可访问。

## 已知限制

- Docker 守护进程需在宿主机运行（Windows/Mac 需 Docker Desktop）
- 首次运行环境时自动构建镜像（约 1-2 分钟）

## 许可证

MIT
