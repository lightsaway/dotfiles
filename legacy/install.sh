#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles installer (Homebrew path, macOS)
# Idempotent — safe to re-run at any time
# =============================================================================

# Resolve to repo root (this script lives in legacy/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOT_FOLDER="${HOME}/.dotfiles"
DOT_BCKP_FOLDER="${DOT_FOLDER}/backup"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { printf "${GREEN}[✓] %s${NC}\n" "$1"; }
warn()  { printf "${YELLOW}[!] %s${NC}\n" "$1"; }
error() { printf "${RED}[✗] %s${NC}\n" "$1"; }
step()  { printf "\n${GREEN}==> %s${NC}\n" "$1"; }

# =============================================================================
# 1. Ensure dotfiles are linked to ~/.dotfiles
# =============================================================================
step "Linking dotfiles"

if [ ! -d "$DOT_FOLDER" ] && [ ! -L "$DOT_FOLDER" ]; then
  ln -s "$SCRIPT_DIR" "$DOT_FOLDER"
  info "Linked $SCRIPT_DIR -> $DOT_FOLDER"
elif [ "$(readlink -f "$DOT_FOLDER" 2>/dev/null || echo "$DOT_FOLDER")" = "$SCRIPT_DIR" ]; then
  info "Already linked"
else
  warn "$DOT_FOLDER exists and points elsewhere — skipping"
fi

# =============================================================================
# 2. Homebrew
# =============================================================================
step "Homebrew"

if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Source brew for current session (Apple Silicon)
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  info "Homebrew already installed"
fi

info "Updating Homebrew..."
brew update
brew upgrade

info "Installing from .brewfile..."
brew bundle --file="$SCRIPT_DIR/.brewfile"

# =============================================================================
# 3. Backup existing configs (only real files, not our symlinks)
# =============================================================================
step "Backing up existing configs"

mkdir -p "$DOT_BCKP_FOLDER"
BCKP_SFX="$(date +%Y%m%d_%H%M%S)"

for file in .zshrc .profile .bash_profile .vimrc .gitconfig; do
  target="${HOME}/${file}"
  if [ -f "$target" ] && [ ! -L "$target" ]; then
    cp "$target" "${DOT_BCKP_FOLDER}/${file}.${BCKP_SFX}"
    info "Backed up $file"
  fi
done

# =============================================================================
# 4. Oh-My-Zsh
# =============================================================================
step "Oh-My-Zsh"

export ZSH="${DOT_FOLDER}/oh-my-zsh"
export ZSH_CUSTOM="${ZSH}/custom"

if [ ! -d "$ZSH" ]; then
  info "Installing oh-my-zsh..."
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
else
  info "Oh-my-zsh already installed"
fi

# Plugins (clone only if missing)
_omz_plugin() {
  local name="$1" repo="$2"
  local dest="${ZSH_CUSTOM}/plugins/${name}"
  if [ ! -d "$dest" ]; then
    git clone "$repo" "$dest"
    info "Installed zsh plugin: $name"
  else
    info "zsh plugin already installed: $name"
  fi
}

_omz_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
_omz_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"

# =============================================================================
# 5. SDKMAN
# =============================================================================
step "SDKMAN"

if [ ! -d "${HOME}/.sdkman" ]; then
  info "Installing SDKMAN..."
  curl -s "https://get.sdkman.io?rcupdate=false" | bash
else
  info "SDKMAN already installed"
fi

# =============================================================================
# 6. Rust
# =============================================================================
step "Rust"

if ! command -v rustup &>/dev/null; then
  info "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
else
  info "Rust already installed ($(rustc --version 2>/dev/null || echo 'unknown'))"
fi

# =============================================================================
# 7. Symlink all config files
# =============================================================================
step "Symlinking configs"

_link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return  # Already correct
  fi
  ln -sf "$src" "$dst"
  info "Linked $(basename "$dst")"
}

# Shell
_link "${DOT_FOLDER}/.profile"        "${HOME}/.profile"
_link "${DOT_FOLDER}/.bash_profile"   "${HOME}/.bash_profile"
_link "${DOT_FOLDER}/.zshrc"          "${HOME}/.zshrc"

# Git
_link "${DOT_FOLDER}/git/config"      "${HOME}/.gitconfig"

# Vim
_link "${DOT_FOLDER}/vim/vimrc"       "${HOME}/.vimrc"
_link "${DOT_FOLDER}/vim/coc-settings.json" "${HOME}/.vim/coc-settings.json"

# Scala / Ammonite
mkdir -p "${HOME}/.ammonite"
_link "${DOT_FOLDER}/predef.sc"       "${HOME}/.ammonite/predef.sc"

# Terminal emulators
_link "${DOT_FOLDER}/terminals/ghostty/config"   "${HOME}/.config/ghostty/config"
_link "${DOT_FOLDER}/terminals/tmux/tmux.conf"    "${HOME}/.config/tmux/tmux.conf"
_link "${DOT_FOLDER}/terminals/zellij/config.kdl" "${HOME}/.config/zellij/config.kdl"

# Starship prompt
_link "${DOT_FOLDER}/terminals/starship.toml"     "${HOME}/.config/starship.toml"

# Atuin (shell history)
_link "${DOT_FOLDER}/terminals/atuin/config.toml" "${HOME}/.config/atuin/config.toml"

# =============================================================================
# 8. Register shells
# =============================================================================
step "Shell registration"

_register_shell() {
  local shell_path="$1"
  if [ -x "$shell_path" ] && ! grep -qF "$shell_path" /etc/shells 2>/dev/null; then
    echo "$shell_path" | sudo tee -a /etc/shells >/dev/null
    info "Registered $shell_path"
  fi
}

# Apple Silicon paths
_register_shell "/opt/homebrew/bin/bash"
_register_shell "/opt/homebrew/bin/zsh"
# Intel paths
_register_shell "/usr/local/bin/bash"
_register_shell "/usr/local/bin/zsh"

# =============================================================================
# 9. Vim plugins
# =============================================================================
step "Vim plugins"

if command -v vim &>/dev/null; then
  info "Installing/updating vim plugins..."
  vim -es -u "${HOME}/.vimrc" +PlugClean! +PlugInstall +qa 2>/dev/null || true
  info "Vim plugins synced"
fi

# =============================================================================
# 10. Misc
# =============================================================================
[ ! -f "${HOME}/.hushlogin" ] && touch "${HOME}/.hushlogin"

# =============================================================================
# Done
# =============================================================================
printf "\n"
info "All done! Restart your shell: exec \$SHELL -l"
