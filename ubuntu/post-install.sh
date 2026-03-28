#!/usr/bin/env bash
# 后续配置：字体、系统优化、常用 GUI 应用等
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---------- 安装 Nerd Fonts ----------
echo ">>> 安装 MesloLGS Nerd Font (Powerlevel10k 推荐)..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
FONT_BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
for font in \
    "MesloLGS NF Regular.ttf" \
    "MesloLGS NF Bold.ttf" \
    "MesloLGS NF Italic.ttf" \
    "MesloLGS NF Bold Italic.ttf"; do
    if [ ! -f "$FONT_DIR/$font" ]; then
        curl -fLo "$FONT_DIR/$font" "${FONT_BASE_URL}/${font// /%20}"
    fi
done
fc-cache -fv "$FONT_DIR"

# ---------- 配置 Git ----------
echo ">>> 部署 Git 配置..."
GIT_CONF_DIR="$REPO_DIR/git"
if [ -f "$GIT_CONF_DIR/.gitconfig" ]; then
    cp "$GIT_CONF_DIR/.gitconfig" "$HOME/.gitconfig"
    echo ".gitconfig 已部署。"
fi
if [ -f "$GIT_CONF_DIR/.gitignore_global" ]; then
    cp "$GIT_CONF_DIR/.gitignore_global" "$HOME/.gitignore_global"
    git config --global core.excludesfile "$HOME/.gitignore_global"
    echo ".gitignore_global 已部署。"
fi

# ---------- 系统优化 ----------
echo ">>> 系统优化配置..."
# 禁用 apt 自动更新（可选，防止后台占用资源）
# sudo systemctl disable apt-daily.service apt-daily-upgrade.service 2>/dev/null || true

# 提高文件描述符上限
if ! grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf 2>/dev/null; then
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi

# ---------- 安装 VS Code ----------
echo ">>> 安装 VS Code..."
if ! command -v code &>/dev/null; then
    wget -qO /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo apt install -y /tmp/vscode.deb
    rm /tmp/vscode.deb
fi

# ---------- 安装 VS Code 扩展 ----------
VSCODE_EXTENSIONS_FILE="$REPO_DIR/vscode/extensions.txt"
if command -v code &>/dev/null && [ -f "$VSCODE_EXTENSIONS_FILE" ]; then
    echo ">>> 安装 VS Code 扩展..."
    while IFS= read -r ext; do
        # 跳过空行和注释行
        [[ -z "$ext" || "$ext" == \#* ]] && continue
        code --install-extension "$ext" --force
    done < "$VSCODE_EXTENSIONS_FILE"
fi

echo ">>> 后续配置完成。"
