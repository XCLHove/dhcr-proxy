# dhcr-proxy — Docker Hub 反向代理

基于 OpenResty 的 Docker Hub 反向代理，解决拉取镜像时的网络访问问题。

## 快速开始

### Docker 命令

```bash
docker run -d \
  --name dhcr-proxy \
  -p 48080:80 \
  ghcr.io/xclhove/dhcr-proxy:1.31.1.1-1
```

### Docker Compose

```bash
# 从 GHCR 拉取已构建的镜像（推荐）
docker compose -f docker-compose.yaml up -d

# 开发模式：使用本地 nginx.conf 构建并启动
docker compose up -d
```

## 配置 Docker 客户端

启动代理后，配置 Docker 守护进程使用代理：

```json
{
  "registry-mirrors": ["https://example.com"]
}
```

写入 `/etc/docker/daemon.json`（Linux）或 Docker Desktop → Settings → Docker Engine（Windows/Mac），然后重启 Docker。

拉镜像测试：

```bash
docker pull nginx:alpine
```

## 目录结构

```
├── .github/workflows/build.yml   # CI/CD：推送 v* 标签自动构建推送到 GHCR
├── Dockerfile                     # 镜像构建文件
├── docker-compose.yaml            # 开发环境（原始 openresty + 本地配置挂载）
├── docker-compose.release.yaml    # 生产环境（从 GHCR 拉取）
├── src/
│   └── nginx.conf                 # OpenResty / Nginx 反向代理配置
└── .gitignore
```

## 本地构建

```bash
# 使用默认版本
docker build -t dhcr-proxy:1.31.1.1-1 .

# 指定 OpenResty 版本
docker build \
  --build-arg OPENRESTY_VERSION=1.31.1.1-1 \
  --build-arg ALPINE_ARCH=amd64 \
  -t dhcr-proxy:1.31.1.1-1 .
```

## 版本升级

当 OpenResty 发布新版本时，更新 Dockerfile 中的 `OPENRESTY_VERSION` 并打标签发布：

```bash
git tag v1.31.1.1-1
git push origin v1.31.1.1-1
```

GitHub Actions 会自动构建并推送镜像到 `ghcr.io/xclhove/dhcr-proxy:<版本号>`。
