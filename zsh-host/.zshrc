export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="gallois"

plugins=(git)

source $ZSH/oh-my-zsh.sh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# --- 1. Autocomplete & Suggestions (Added) ---
# Check if file exists before sourcing to prevent errors if you haven't cloned it yet
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Config: Accept suggestion with Ctrl+Space
bindkey '^ ' autosuggest-accept
# Config: Case insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

# --- 2. Starship & Tools ---
eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
alias cd="z"

# --- 3. Environment & Paths ---
source "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# --- 4. Syntax Highlighting (MUST BE LAST) ---
# This must be at the very end to wrap all other widgets correctly
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias lg="lazygit"
alias ldk="lazydocker"

