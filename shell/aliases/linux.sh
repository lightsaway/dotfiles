#!/usr/bin/env bash
# Linux-specific aliases

# System updates (apt-based, adjust for your distro)
alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

# Clipboard (requires xclip)
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias c="tr -d '\n' | xclip -selection clipboard"

# Open files with default application
alias open='xdg-open'

# Network
alias localip="hostname -I | awk '{print \$1}'"
alias ips="ip -o addr show | awk '/inet / {print \$2, \$4}'"
alias ifactive="ip link show up"

# Flush DNS cache (systemd-resolved)
alias flush="sudo systemd-resolve --flush-caches 2>/dev/null || sudo resolvectl flush-caches 2>/dev/null"

# Lock screen (common DEs)
alias afk="loginctl lock-session 2>/dev/null || xdg-screensaver lock 2>/dev/null"

# Empty trash
alias emptytrash="rm -rf ~/.local/share/Trash/*"

# VSCode
alias vsc="code"
