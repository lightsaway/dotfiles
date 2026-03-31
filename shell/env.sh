#!/usr/bin/env bash
# Consolidated environment variables and PATH management

# Dotfiles location
export DOT_FOLDER="${HOME}/.dotfiles"
export DOT_BCKP_FOLDER="${DOT_FOLDER}/backup"

# XDG Base Directories
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

# Editor
export GIT_EDITOR=vim
export EDITOR=vim

# Go
export GOPATH="${HOME}/golang"
# GOROOT is set automatically by the go binary; only set if using brew-installed go
if command -v brew &>/dev/null && [[ -d "$(brew --prefix go 2>/dev/null)/libexec" ]]; then
  export GOROOT="$(brew --prefix go)/libexec"
fi

# Python (managed by uv)
# uv handles Python versions, venvs, and packages
# Install a Python version: uv python install 3.12
# Create a project: uv init myproject
# Add a dependency: uv add requests

# Oh-my-zsh (until migrated to Nix)
export ZSH="${DOT_FOLDER}/oh-my-zsh"
export ZSH_CUSTOM="${ZSH}/custom"

# PATH construction (order matters: first entry wins)
# Nix paths are managed by Nix itself and prepended automatically

typeset -U PATH  # deduplicate PATH entries (zsh)

# User-local binaries
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Cargo/Rust
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# Go
[[ -d "$GOPATH/bin" ]] && export PATH="$GOPATH/bin:$PATH"
[[ -d "$GOROOT/bin" ]] && export PATH="$GOROOT/bin:$PATH"

# uv (Python toolchain)
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Homebrew (macOS)
if [[ "$(uname -s)" == "Darwin" ]]; then
	[[ -d "/opt/homebrew/bin" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
	[[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:$PATH"
fi

# SDKMAN (loaded conditionally)
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Source aliases and functions based on OS
_DOTFILES_SHELL="${DOT_FOLDER}/shell"

[[ -f "${_DOTFILES_SHELL}/aliases/common.sh" ]] && source "${_DOTFILES_SHELL}/aliases/common.sh"
[[ -f "${_DOTFILES_SHELL}/functions/common.sh" ]] && source "${_DOTFILES_SHELL}/functions/common.sh"

case "$(uname -s)" in
	Darwin)
		[[ -f "${_DOTFILES_SHELL}/aliases/darwin.sh" ]] && source "${_DOTFILES_SHELL}/aliases/darwin.sh"
		[[ -f "${_DOTFILES_SHELL}/functions/darwin.sh" ]] && source "${_DOTFILES_SHELL}/functions/darwin.sh"
		;;
	Linux)
		[[ -f "${_DOTFILES_SHELL}/aliases/linux.sh" ]] && source "${_DOTFILES_SHELL}/aliases/linux.sh"
		;;
esac
unset _DOTFILES_SHELL
