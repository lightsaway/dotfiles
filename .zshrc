# Load shared profile (env vars, PATH, aliases, functions)
[[ -e ~/.profile ]] && source "${HOME}/.profile"

# =============================================================================
# Oh-My-Zsh
# =============================================================================
ZSH_THEME=""  # Prompt handled by Starship
plugins=(git kubectl docker dotenv docker-compose tmux)

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Re-source aliases after oh-my-zsh (it overrides ls, etc.)
[[ -f "${DOT_FOLDER}/shell/aliases/common.sh" ]] && source "${DOT_FOLDER}/shell/aliases/common.sh"

# =============================================================================
# Plugins (loaded separately from oh-my-zsh)
# =============================================================================

# zsh-autosuggestions
if [[ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]]; then
  source "${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "$(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting (must be last)
if [[ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]]; then
  source "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "$(brew --prefix 2>/dev/null)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# =============================================================================
# Prompt
# =============================================================================
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# =============================================================================
# Key bindings
# =============================================================================
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word

# =============================================================================
# Tool integrations
# =============================================================================

# Autojump (until migrated to zoxide)
if command -v brew &>/dev/null; then
  [[ -s "$(brew --prefix)/etc/autojump.sh" ]] && source "$(brew --prefix)/etc/autojump.sh"
fi

# Zoxide (modern autojump replacement)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# thefuck
if command -v thefuck &>/dev/null; then
  eval $(thefuck --alias)
fi

# fzf
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh 2>/dev/null)" || true
fi

# atuin (shell history)
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# =============================================================================
# PATH additions
# =============================================================================

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
if [[ -d "$HOME/.bun" ]]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# =============================================================================
# Aliases
# =============================================================================
[[ -x "$HOME/.claude/local/claude" ]] && alias claude="$HOME/.claude/local/claude"

# bun completions
[ -s "/Users/atoshi/.bun/_bun" ] && source "/Users/atoshi/.bun/_bun"
