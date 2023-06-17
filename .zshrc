[[ -e ~/.profile ]] && source ${HOME}/.profile

ZSH_THEME="refined"
plugins=(git kubectl docker dotenv docker-compose tmux yarn npm autojump zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word

#autojump fix
[[ -s `brew --prefix`/etc/autojump.sh ]] && source `brew --prefix`/etc/autojump.sh


eval $(thefuck --alias)

