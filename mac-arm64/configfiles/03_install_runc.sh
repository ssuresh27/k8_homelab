# curl -LO https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.arm64
curl -LO https://github.com/opencontainers/runc/releases/download/v1.1.14/runc.arm64

sudo install -m 755 runc.arm64 /usr/local/sbin/runc