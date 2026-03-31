#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles bootstrap (Nix path, cross-platform)
# Idempotent — safe to re-run at any time
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="${HOME}/.dotfiles"

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
# 1. Link dotfiles to ~/.dotfiles
# =============================================================================
step "Linking dotfiles"

if [ ! -d "$DOTFILES" ] && [ ! -L "$DOTFILES" ]; then
  ln -s "$SCRIPT_DIR" "$DOTFILES"
  info "Linked $SCRIPT_DIR -> $DOTFILES"
elif [ "$(readlink -f "$DOTFILES" 2>/dev/null || echo "$DOTFILES")" = "$SCRIPT_DIR" ]; then
  info "Already linked"
else
  warn "$DOTFILES exists and points elsewhere — using it as-is"
  DOTFILES="$(readlink -f "$DOTFILES" 2>/dev/null || echo "$DOTFILES")"
fi

cd "$DOTFILES"

# =============================================================================
# 2. Install Nix
# =============================================================================
step "Nix"

if ! command -v nix &>/dev/null; then
  info "Installing Nix via Determinate Systems installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install

  # Source Nix for current session
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
  info "Nix installed"
else
  info "Nix already installed"
fi

# =============================================================================
# 3. Build and activate
# =============================================================================
step "Building configuration"

case "$(uname -s)" in
  Darwin)
    info "Detected macOS ($(uname -m))"
    if command -v darwin-rebuild &>/dev/null; then
      darwin-rebuild switch --flake .#atoshi-mac
    else
      info "First-time nix-darwin install..."
      nix run nix-darwin -- switch --flake .#atoshi-mac
    fi
    ;;

  Linux)
    ARCH="$(uname -m)"
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
      HM_CONFIG="atoshi-linux-arm"
    else
      HM_CONFIG="atoshi-linux"
    fi
    info "Detected Linux ($ARCH) — using config: $HM_CONFIG"

    if command -v home-manager &>/dev/null; then
      home-manager switch --flake ".#${HM_CONFIG}"
    else
      info "First-time home-manager install..."
      nix run home-manager -- switch --flake ".#${HM_CONFIG}"
    fi
    ;;

  *)
    error "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac

# =============================================================================
# 4. Vim plugins (CoC needs node, which Nix just installed)
# =============================================================================
# Note: On macOS, nix-darwin manages Homebrew declaratively.
# Any brew formula NOT listed in nix/hosts/darwin.nix is automatically
# uninstalled by `darwin-rebuild switch` (cleanup = "uninstall").
# No manual cleanup needed.
step "Vim plugins"

if command -v vim &>/dev/null; then
  info "Syncing vim plugins..."
  vim -es -u "${HOME}/.vimrc" +PlugClean! +PlugInstall +qa 2>/dev/null || true
  info "Vim plugins synced"
fi

# =============================================================================
# Done
# =============================================================================
printf "\n"
info "All done! Restart your shell: exec \$SHELL -l"
