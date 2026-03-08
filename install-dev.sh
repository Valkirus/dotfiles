#!/bin/bash
# ~/dotfiles/install-dev.sh

echo "Installing Universal Dev Tools..."

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

echo "=== Detecting Package Manager ==="
if command -v apt-get >/dev/null 2>&1; then
    echo "Debian/Ubuntu detected."
    export DEBIAN_FRONTEND=noninteractive
    $SUDO apt-get update
    $SUDO apt-get install -y curl wget git build-essential zsh ripgrep fd-find unzip tar stow
    # Ubuntu/Debian use fdfind instead of fd, so we symlink it
    $SUDO ln -sf $(command -v fdfind) /usr/local/bin/fd || true

elif command -v apk >/dev/null 2>&1; then
    echo "Alpine detected."
    $SUDO apk add --no-cache curl wget git build-base zsh ripgrep fd unzip tar coreutils gcompat stow

elif command -v dnf >/dev/null 2>&1; then
    echo "Fedora/RHEL detected."
    $SUDO dnf install -y curl wget git gcc gcc-c++ zsh ripgrep fd-find unzip tar stow

elif command -v pacman >/dev/null 2>&1; then
    echo "Arch Linux detected."
    $SUDO pacman -Sy --noconfirm curl wget git base-devel zsh ripgrep fd unzip tar stow

else
    echo "Unsupported package manager. Please manually install dependencies."
    exit 1
fi

echo "=== Installing Neovim ==="
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz
$SUDO tar -C /usr/local -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
$SUDO ln -sf /usr/local/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

echo "=== Installing Lazygit ==="
LAZYGIT_VERSION="0.40.2"
DIR="/tmp/lazygit"
mkdir -p $DIR
curl -L "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" -o $DIR/lazygit.tar.gz
tar xf $DIR/lazygit.tar.gz -C $DIR
$SUDO install $DIR/lazygit /usr/local/bin/
rm -rf $DIR

echo "=== Installing Starship ==="
curl -sS https://starship.rs/install.sh | sh -s -- --yes

echo "=== Stowing Configurations ==="
cd "$(dirname "$0")" || exit

# Prevent Stow directory folding by creating the base directories first!
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"

stow -v -t ~ nvim scripts zsh-dev git-dev

echo "=== Setting Zsh as default shell ==="
ZSH_PATH=$(command -v zsh)
if [ -n "$ZSH_PATH" ]; then
    # usermod bypasses PAM password prompts much better than chsh inside containers
    if command -v usermod >/dev/null 2>&1; then
        $SUDO usermod -s "$ZSH_PATH" "$(whoami)"
    else
        $SUDO chsh -s "$ZSH_PATH" "$(whoami)"
    fi
fi

echo "Universal dev environment fully installed and symlinked!"
