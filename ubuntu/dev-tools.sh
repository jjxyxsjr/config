#!/usr/bin/env bash
# 安装开发工具：Node.js、Python、Docker、Go 等
set -euo pipefail

# ---------- Node.js (via nvm) ----------
echo ">>> 安装 nvm 和 Node.js..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
nvm alias default node

# ---------- Python (via pyenv) ----------
echo ">>> 安装 pyenv 和 Python..."
if ! command -v pyenv &>/dev/null; then
    sudo apt install -y \
        make libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev llvm libncursesw5-dev \
        xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    curl https://pyenv.run | bash
fi
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv install 3.12 --skip-existing
pyenv global 3.12
pip install --upgrade pip pipenv black isort flake8

# ---------- Docker ----------
echo ">>> 安装 Docker..."
if ! command -v docker &>/dev/null; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER"
    echo "Docker 已安装，请重新登录以使 docker 组权限生效。"
fi

# ---------- Go ----------
echo ">>> 安装 Go..."
GO_VERSION="1.22.2"
if ! command -v go &>/dev/null || [[ "$(go version 2>/dev/null)" != *"go${GO_VERSION}"* ]]; then
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
    echo "Go ${GO_VERSION} 已安装到 /usr/local/go"
fi

# ---------- Rust ----------
echo ">>> 安装 Rust..."
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi
rustup update stable

echo ">>> 开发工具安装完成。"
