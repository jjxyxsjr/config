# ~/.bashrc — 个人 Bash 配置（在不使用 Zsh 时作为备用）
# =========================================================

# 如果不是交互式 shell 则退出
[[ $- != *i* ]] && return

# ---------- 提示符 ----------
# 简洁的双行提示符
PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\n\$ '

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
[[ -f ~/.aliases ]] && source ~/.aliases

# ---------- 历史记录 ----------
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend

# ---------- 自动补全 ----------
if ! shopt -oq posix; then
    if   [[ -f /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    fi
fi

# ---------- 工具初始化 ----------
# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# fzf
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# starship
command -v starship &>/dev/null && eval "$(starship init bash)"
