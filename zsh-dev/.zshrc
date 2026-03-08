# ==============================================================================
# DEV CONTAINER ZSH ENVIRONMENT (Native, Zero-Dependency)
# ==============================================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups

alias lg="lazygit"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias ls="ls --color=auto"
alias ll="ls -la"
alias ..="cd .."

autoload -Uz vcs_info
precmd() { vcs_info }
# Format the branch name to look exactly like Oh My Zsh
zstyle ':vcs_info:git:*' formats ' %F{blue}git:(%b)%f'

setopt PROMPT_SUBST
# ${vcs_info_msg_0_} injects the Git branch formatting from above
PROMPT='%F{magenta}[📦 dev-container]%f %F{cyan}%~%f${vcs_info_msg_0_} %F{green}❯%f '
