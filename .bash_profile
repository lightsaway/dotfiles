# =============================================================================
# Bash profile (sources shared .profile)
# =============================================================================

[[ -f "${HOME}/.profile" ]] && source "${HOME}/.profile"

# Bash completion
if command -v brew &>/dev/null; then
  [[ -f "$(brew --prefix)/etc/bash_completion" ]] && source "$(brew --prefix)/etc/bash_completion"
  [[ -f "$(brew --prefix)/etc/bash_completion.d" ]] && source "$(brew --prefix)/etc/bash_completion.d"
fi

# Bash-specific history settings
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend 2>/dev/null
