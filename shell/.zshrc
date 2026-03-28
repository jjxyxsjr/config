# ~/.zshrc — 个人 Zsh 配置
# =========================================================

# ---------- Oh My Zsh ----------
export ZSH="$HOME/.oh-my-zsh"

# 主题 (Powerlevel10k)
ZSH_THEME="powerlevel10k/powerlevel10k"

# 插件
plugins=(
    git
    z
    docker
    docker-compose
    npm
    node
    python
    pip
    rust
    golang
    kubectl
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ---------- Powerlevel10k ----------
# 若 ~/.p10k.zsh 存在则加载
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ---------- 环境变量 ----------
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export EDITOR=vim
export VISUAL=vim

# Go
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

# Rust / Cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &>/dev/null && eval "$(pyenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]]         && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# 本地 bin
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ---------- Aliases ----------
source ~/.aliases

# ---------- 工具初始化 ----------
# zoxide (智能 cd)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# fzf
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# starship (若不使用 p10k，取消下行注释并注释掉 ZSH_THEME)
# command -v starship &>/dev/null && eval "$(starship init zsh)"

# ---------- 历史记录 ----------
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
