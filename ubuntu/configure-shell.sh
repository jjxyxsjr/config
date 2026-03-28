#!/usr/bin/env bash
# 配置 Shell 环境 (Zsh + Oh My Zsh)
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---------- 安装 Zsh ----------
echo ">>> 安装 Zsh..."
sudo apt install -y zsh

# ---------- 安装 Oh My Zsh ----------
echo ">>> 安装 Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ---------- 安装常用插件 ----------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo ">>> 安装 zsh-autosuggestions..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

echo ">>> 安装 zsh-syntax-highlighting..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo ">>> 安装 Powerlevel10k 主题..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# ---------- 安装 fzf ----------
echo ">>> 安装 fzf..."
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
fi

# ---------- 安装 zoxide ----------
echo ">>> 安装 zoxide (智能 cd)..."
if ! command -v zoxide &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# ---------- 安装 starship (备选 prompt) ----------
echo ">>> 安装 starship..."
if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ---------- 部署配置文件 ----------
echo ">>> 部署 Shell 配置文件..."
SHELL_CONF_DIR="$REPO_DIR/shell"

if [ -f "$SHELL_CONF_DIR/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
    cp "$SHELL_CONF_DIR/.zshrc" "$HOME/.zshrc"
    echo ".zshrc 已部署。"
fi

if [ -f "$SHELL_CONF_DIR/.p10k.zsh" ]; then
    cp "$SHELL_CONF_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    echo ".p10k.zsh 已部署。"
fi

# ---------- 切换默认 Shell ----------
echo ">>> 将默认 Shell 切换为 Zsh..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

echo ">>> Shell 环境配置完成。"
