#!/usr/bin/env bash

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"

# Shortcuts
alias d="cd ~/Documents/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/projects"
alias g="git"
alias lg="lazygit"
alias k="kubectl"
alias h="history"
alias j_log_pretty="jq -r '[.level, .timestamp, .message] | join(\" | \")'"
alias pods="kubectl get pods"

# bat (cat replacement with syntax highlighting)
if [ -x "$(command -v bat)" ]; then
	alias cat="bat --paging=never"
fi

# Modern ls (eza) with fallback
if [ -x "$(command -v eza)" ]; then
	alias l="eza -lF"
	alias la="eza -laF"
	alias ls="eza"
	alias lt="eza --tree --level=2 --git-ignore"
	alias ll="eza -lahF --git --icons --group-directories-first"
else
	# Detect which `ls` flavor is in use
	if ls --color > /dev/null 2>&1; then # GNU `ls`
		colorflag="--color"
		export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
	else # macOS `ls`
		colorflag="-G"
		export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
	fi
	alias l="ls -lF ${colorflag}"
	alias la="ls -laF ${colorflag}"
	alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"
	alias ls="command ls ${colorflag}"
fi

# Modern CLI replacements
if [ -x "$(command -v dust)" ]; then alias du="dust"; fi
if [ -x "$(command -v duf)" ]; then alias df="duf"; fi
if [ -x "$(command -v procs)" ]; then alias ps="procs"; fi
if [ -x "$(command -v doggo)" ]; then alias dig="doggo"; fi

# Quick file search with fd
if [ -x "$(command -v fd)" ]; then alias f="fd"; fi

# Preview files with fzf + bat
if [ -x "$(command -v fzf)" ] && [ -x "$(command -v bat)" ]; then
	alias preview="fzf --preview 'bat --color=always {}'"
fi

# Serve current dir over HTTP
alias serve="python3 -m http.server"

# Git shortcuts
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline -20"
alias gp="git push"

# Docker shortcuts
alias dc="docker compose"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

# Copy working directory path
alias cpwd="pwd | tr -d '\n' | pbcopy"

# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable aliases to be sudo'ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# URL-encode strings
alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote_plus(sys.argv[1]))"'

# Intuitive map function
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

alias incognito="unset HISTFILE"

# Audio processing
alias wavDrop="find . -type f \( -iname '*.wav' -o -iname '*.WAV' \) -print -delete"
alias oggDrop="find . -type f \( -iname '*.ogg' -o -iname '*.OGG' \) -print -delete"
alias wav2mp3="find . -type f -name '*.wav' -exec bash -c 'ffmpeg -i \"\$1\" -c:a libmp3lame -qscale:a 2 \"\${1%.wav}.mp3\"' _ {} \;"
alias wav2ogg="find . -type f -name '*.wav' -exec bash -c 'ffmpeg -i \"\$1\" -c:a libvorbis -q:a 4 \"\${1%.wav}.ogg\"' _ {} \;"

# HTTP method aliases
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "${method}"="lwp-request -m '${method}'"
done

# Make Grunt print stack traces by default
command -v grunt > /dev/null && alias grunt="grunt --stack"
