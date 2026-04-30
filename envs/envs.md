# 新增环境指南

本文档说明如何为 DockerCC 项目添加新的开发环境。

## 添加步骤

### 1. 创建环境脚本

在 `envs/` 目录下创建 `{环境名}.sh` 脚本。

**命名规则：**
- 脚本名即为环境名（小写）
- 构建时通过 `-e {环境名}` 指定

**脚本要求：**
- 安装的工具必须放到 `/usr/local/bin` 或 `/usr/bin`（已在 PATH 中）
- 使用 `set -e` 确保安装失败时构建失败
- 清理临时文件以减小镜像体积
- 使用国内镜像源加速下载

**示例模板：**

```bash
#!/bin/bash
set -e

echo ">>> 安装 {环境名}..."

# 下载并安装（放到 /usr/local/bin）
wget -q https://example.com/tool -O /tmp/tool
install /tmp/tool /usr/local/bin/tool
rm /tmp/tool

# 或使用 apt 安装（自动在 PATH）
apt-get install -y --no-install-recommends your-package

echo ">>> {环境名} 安装完成"
```

### 2. 构建并测试

```bash
# 构建
docker build --build-arg INSTALL_ENVS=yourenv -t claude-cc:yourenv .

# 测试（直接运行命令验证）
docker run --rm claude-cc:yourenv your-command --version
```

### 3. 更新 README

在 `README.md` 和本文档中添加新环境说明。

## 示例：添加 Python 环境

### 1. 创建脚本 `envs/python.sh`

```bash
#!/bin/bash
set -e

echo ">>> 安装 Python 环境..."

# Python 已存在于基础镜像，安装额外工具
pip install --no-cache-dir pipenv poetry

echo ">>> Python 环境安装完成"
```

### 2. 构建测试

```bash
docker build --build-arg INSTALL_ENVS=python -t claude-cc:python .
docker run --rm claude-cc:python python --version
```

## 镜像命名规则

当使用 `-e` 参数时，镜像标签自动生成为：

| INSTALL_ENVS | 镜像标签 |
|--------------|---------|
| `go120` | claude-cc:go120 |
| `go120,nodejs` | claude-cc:go120-nodejs |
| `php74,nodejs,go120` | claude-cc:php74-nodejs-go120 |

## 最佳实践

1. **优先使用 apt 安装** - 系统包管理器安装的包自动在 PATH 中
2. **下载安装到 /usr/local/bin** - 这个目录已在 PATH 中
3. **使用国内镜像** - 加速下载，避免网络问题
4. **清理临时文件** - `rm -rf /tmp/*` 减小镜像体积
5. **设置 PATH 环境变量** - 如需特殊路径，在 Dockerfile 中添加 `ENV PATH=...`
