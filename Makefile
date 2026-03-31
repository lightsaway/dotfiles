.PHONY: help install bootstrap update brew-sync brew-cleanup brew-outdated vim-plugins link clean

DOTFILES := $(HOME)/.dotfiles
BREWFILE := $(DOTFILES)/.brewfile

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# =============================================================================
# Setup
# =============================================================================

install: ## Run legacy installer (Homebrew path)
	@bash $(DOTFILES)/legacy/install.sh

bootstrap: ## Run Nix bootstrap (recommended for new machines)
	@bash $(DOTFILES)/bootstrap.sh

# =============================================================================
# Homebrew
# =============================================================================

brew-sync: ## Install/upgrade packages from .brewfile
	brew update
	brew upgrade
	brew bundle --file=$(BREWFILE)

brew-cleanup: ## Remove formulae/casks not in .brewfile + garbage collect
	brew bundle cleanup --file=$(BREWFILE) --force
	brew autoremove
	brew cleanup --prune=all

brew-outdated: ## Show outdated packages
	@brew outdated

brew-diff: ## Show what's installed but not in .brewfile (dry run)
	@brew bundle cleanup --file=$(BREWFILE)

# =============================================================================
# Nix
# =============================================================================

nix-switch: ## Rebuild and activate Nix configuration (macOS)
	darwin-rebuild switch --flake $(DOTFILES)#atoshi-mac

nix-switch-linux: ## Rebuild and activate Nix configuration (Linux)
	home-manager switch --flake $(DOTFILES)#atoshi-linux

nix-update: ## Update all Nix flake inputs to latest
	nix flake update --flake $(DOTFILES)
	@echo "Run 'make nix-switch' to apply updates"

nix-gc: ## Garbage collect old Nix generations
	nix-collect-garbage -d

# =============================================================================
# Maintenance
# =============================================================================

update: brew-sync brew-cleanup vim-plugins ## Update everything (brew + vim plugins)
	@echo "All updated!"

vim-plugins: ## Install/update vim plugins
	vim -es -u $(HOME)/.vimrc +PlugClean! +PlugInstall +PlugUpdate +qa 2>/dev/null || true
	@echo "Vim plugins synced"

link: ## Re-symlink all config files
	@bash -c 'source $(DOTFILES)/legacy/install.sh 2>/dev/null' || true

omz-update: ## Update oh-my-zsh and plugins
	git -C $(DOTFILES)/oh-my-zsh pull
	git -C $(DOTFILES)/oh-my-zsh/custom/plugins/zsh-autosuggestions pull
	git -C $(DOTFILES)/oh-my-zsh/custom/plugins/zsh-syntax-highlighting pull
	@echo "Oh-my-zsh updated"

clean: ## Full cleanup (brew + nix gc + vim)
	brew autoremove
	brew cleanup --prune=all
	-nix-collect-garbage -d 2>/dev/null
	@echo "Cleaned up"
