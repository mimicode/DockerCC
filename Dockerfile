FROM public.ecr.aws/docker/library/node:22-slim

# 使用阿里云 Debian 镜像
RUN echo 'deb http://mirrors.aliyun.com/debian/ bookworm main' > /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/debian/ bookworm-updates main' >> /etc/apt/sources.list && \
    echo 'deb http://mirrors.aliyun.com/debian-security/ bookworm-security main' >> /etc/apt/sources.list

# 基础系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl wget ca-certificates unzip xz-utils && \
    rm -rf /var/lib/apt/lists/*

# 使用国内 npm 镜像
RUN npm config set registry https://registry.npmmirror.com

# 安装 claude-code
RUN npm install -g @anthropic-ai/claude-code

# 安装 entrypoint 脚本（自动 source /etc/profile.d/*.sh）
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 可选开发环境（构建时通过 --build-arg INSTALL_ENVS 指定）
ARG INSTALL_ENVS=""
COPY envs/ /tmp/envs/
RUN if [ -n "$INSTALL_ENVS" ]; then \
      for env in $(echo "$INSTALL_ENVS" | tr ',' ' '); do \
        if [ -f "/tmp/envs/${env}.sh" ]; then \
          bash /tmp/envs/${env}.sh; \
        fi; \
      done; \
    fi && rm -rf /tmp/envs

# 默认 PATH（包含 /usr/local/bin）
ENV PATH=/usr/local/bin:/usr/bin:/bin:$PATH

# 非 root 用户
RUN useradd -m -s /bin/bash claude
USER claude
WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["claude", "--dangerously-skip-permissions"]
