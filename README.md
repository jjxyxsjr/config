# config

> 个人电脑、IDE、CLI 工具与 Ubuntu 系统的统一配置与脚本。

## 目录结构

```
config/
├── ubuntu/                  # Ubuntu 系统初始化脚本
│   ├── setup.sh             # 一键初始化入口脚本
│   ├── packages.sh          # 常用系统软件包安装
│   ├── dev-tools.sh         # 开发工具（Node/Python/Docker/Go/Rust）
│   ├── configure-shell.sh   # Shell 环境配置（Zsh + Oh My Zsh）
│   └── post-install.sh      # 后续配置（字体/VS Code/系统优化）
│
├── shell/                   # Shell 配置文件
│   ├── .zshrc               # Zsh 主配置（Oh My Zsh + Powerlevel10k）
│   ├── .bashrc              # Bash 备用配置
│   └── .aliases             # 通用命令别名
│
├── git/                     # Git 配置
│   ├── .gitconfig           # 全局 Git 配置（别名、颜色、工具）
│   └── .gitignore_global    # 全局忽略规则
│
├── vscode/                  # VS Code 配置
│   ├── settings.json        # 编辑器设置
│   ├── keybindings.json     # 自定义快捷键
│   └── extensions.txt       # 推荐扩展列表
│
└── deploy.sh                # 一键符号链接部署脚本
```

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/jjxyxsjr/config.git ~/.config-repo
cd ~/.config-repo
```

### 2. Ubuntu 全新系统初始化

```bash
bash ubuntu/setup.sh
```

该脚本会依次：
- 更新系统软件包
- 安装常用工具（curl、git、vim 等）
- 安装开发语言环境（Node.js / Python / Docker / Go / Rust）
- 配置 Zsh + Oh My Zsh + Powerlevel10k
- 部署 Git 和 VS Code 配置

### 3. 仅部署配置文件（已有系统）

```bash
bash deploy.sh            # 部署全部配置
bash deploy.sh --shell    # 仅部署 Shell 配置
bash deploy.sh --git      # 仅部署 Git 配置
bash deploy.sh --vscode   # 仅部署 VS Code 配置
```

脚本使用符号链接方式部署，已有文件会自动备份到 `~/.config-backup/`。

### 4. 安装 VS Code 扩展

```bash
cat vscode/extensions.txt | grep -v '^[#\[]' | grep -v '^$' | \
    xargs -I {} code --install-extension {}
```

## 配置说明

### Shell

- **主题**: [Powerlevel10k](https://github.com/romkatv/powerlevel10k)（需配合 MesloLGS NF 字体）
- **插件**: `zsh-autosuggestions` `zsh-syntax-highlighting` 等常用插件
- **工具**: `fzf`（模糊搜索）、`zoxide`（智能跳转）

### Git

修改 `git/.gitconfig` 中的用户信息：

```ini
[user]
    name  = Your Name
    email = your.email@example.com
```

### VS Code

配置使用 **One Dark Pro Darker** 主题 + **Material Icon Theme** 图标，
默认开启 Format on Save，各语言使用独立的格式化工具。

## 注意事项

- 首次运行 `ubuntu/setup.sh` 需要 `sudo` 权限
- Docker 安装完成后需重新登录以使 `docker` 组权限生效
- 如使用代理，可在 `git/.gitconfig` 中取消 `[http] proxy` 的注释
