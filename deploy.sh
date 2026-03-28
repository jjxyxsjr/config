#!/usr/bin/env bash
# deploy.sh — 将配置文件一键部署到当前用户 Home 目录
# 用法: bash deploy.sh [选项]
#   --all       部署全部配置（默认）
#   --shell     仅部署 Shell 配置
#   --git       仅部署 Git 配置
#   --vscode    仅部署 VS Code 配置

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup/$(date +%Y%m%d%H%M%S)"

# 颜色
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }

# 安全地创建符号链接（先备份）
link_file() {
    local src="$1"
    local dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$dst" "$BACKUP_DIR/"
        warn "已备份 $dst -> $BACKUP_DIR/"
    fi
    ln -sfn "$src" "$dst"
    success "链接: $dst -> $src"
}

deploy_shell() {
    info "部署 Shell 配置..."
    link_file "$REPO_DIR/shell/.zshrc"   "$HOME/.zshrc"
    link_file "$REPO_DIR/shell/.bashrc"  "$HOME/.bashrc"
    link_file "$REPO_DIR/shell/.aliases" "$HOME/.aliases"
}

deploy_git() {
    info "部署 Git 配置..."
    link_file "$REPO_DIR/git/.gitconfig"        "$HOME/.gitconfig"
    link_file "$REPO_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
    git config --global core.excludesfile "$HOME/.gitignore_global"
}

deploy_vscode() {
    info "部署 VS Code 配置..."
    local vscode_user_dir
    if   [[ "$OSTYPE" == darwin* ]]; then
        vscode_user_dir="$HOME/Library/Application Support/Code/User"
    elif [[ "$OSTYPE" == linux* ]]; then
        vscode_user_dir="$HOME/.config/Code/User"
    else
        warn "未识别的操作系统，跳过 VS Code 配置部署。"
        return
    fi
    mkdir -p "$vscode_user_dir"
    link_file "$REPO_DIR/vscode/settings.json"    "$vscode_user_dir/settings.json"
    link_file "$REPO_DIR/vscode/keybindings.json" "$vscode_user_dir/keybindings.json"
}

# ---- 解析参数 ----
MODE="${1:---all}"

case "$MODE" in
    --shell)   deploy_shell   ;;
    --git)     deploy_git     ;;
    --vscode)  deploy_vscode  ;;
    --all|*)
        deploy_shell
        deploy_git
        deploy_vscode
        ;;
esac

echo ""
info "配置部署完成！若有备份文件，请查看: $BACKUP_DIR"
