#!/usr/bin/env bash
# Ubuntu 系统初始化安装脚本
# 用法: bash setup.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "  Ubuntu 系统初始化配置脚本"
echo "=========================================="

# 检查是否为 Ubuntu 系统
if ! grep -qi ubuntu /etc/os-release 2>/dev/null; then
    echo "警告: 当前系统可能不是 Ubuntu，继续执行..." >&2
fi

# 更新系统
echo ""
echo "[1/5] 更新系统软件包..."
sudo apt update && sudo apt upgrade -y

# 安装基础软件包
echo ""
echo "[2/5] 安装基础软件包..."
bash "$SCRIPT_DIR/packages.sh"

# 安装开发工具
echo ""
echo "[3/5] 安装开发工具..."
bash "$SCRIPT_DIR/dev-tools.sh"

# 配置 Shell
echo ""
echo "[4/5] 配置 Shell 环境..."
bash "$SCRIPT_DIR/configure-shell.sh"

# 后续配置
echo ""
echo "[5/5] 执行后续配置..."
bash "$SCRIPT_DIR/post-install.sh"

echo ""
echo "=========================================="
echo "  初始化完成！请重新启动终端以生效。"
echo "=========================================="
