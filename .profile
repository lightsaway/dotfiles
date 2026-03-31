# =============================================================================
# Shared profile (sourced by .bash_profile and .zshrc)
# =============================================================================

# Load consolidated environment (PATH, aliases, functions, OS detection)
[[ -f "${HOME}/.dotfiles/shell/env.sh" ]] && source "${HOME}/.dotfiles/shell/env.sh"

# Extra machine-specific config (not in git)
[[ -f "${HOME}/.extra" ]] && source "${HOME}/.extra"
