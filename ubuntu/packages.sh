#!/usr/bin/env bash
# 安装常用软件包
set -euo pipefail

echo ">>> 安装常用工具包..."

# 系统工具
sudo apt install -y \
    curl \
    wget \
    git \
    unzip \
    zip \
    tar \
    htop \
    tree \
    tldr \
    jq

# 网络工具
sudo apt install -y \
    net-tools \
    nmap \
    traceroute \
    dnsutils

# 文件传输
sudo apt install -y \
    rsync \
    openssh-client \
    openssh-server

# 编辑器
sudo apt install -y \
    vim \
    neovim

# 构建工具 & 基础依赖
sudo apt install -y \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    xclip \
    xsel

echo ">>> 常用工具包安装完成。"

