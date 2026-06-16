# ============================================================
# Docker Hub 反向代理 — OpenResty
# ============================================================
# 构建方式（使用与 docker-compose.yaml 一致的版本）：
#   docker build -t dhcr-proxy:1.29.2.3-1 .
#
# 若需指定不同的 OpenResty 基础镜像版本：
#   docker build \
#     --build-arg OPENRESTY_VERSION=1.29.2.3-1 \
#     --build-arg ALPINE_ARCH=amd64 \
#     -t dhcr-proxy:1.29.2.3-1 .
# ============================================================

ARG OPENRESTY_VERSION=1.31.1.1-1
ARG ALPINE_ARCH=amd64

FROM openresty/openresty:${OPENRESTY_VERSION}-alpine-slim-${ALPINE_ARCH}

# 在 FROM 之后重新声明 ARG，使其对以下指令可见
ARG OPENRESTY_VERSION
ARG ALPINE_ARCH

LABEL org.opencontainers.image.title="Docker Hub Proxy (dhcr-proxy)"
LABEL org.opencontainers.image.description="Docker Hub 反向代理，解决网络访问问题"
LABEL org.opencontainers.image.version="${OPENRESTY_VERSION}"
LABEL org.opencontainers.image.source="https://github.com/YOUR_USERNAME/dockerhub-proxy"

# 拷贝 Nginx 配置
COPY src/nginx.conf /etc/nginx/conf.d/default.conf

# 验证配置语法
RUN nginx -t

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
