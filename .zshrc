[[ -e ~/.profile ]] && source ${HOME}/.profile

ZSH_THEME="refined"
plugins=(git kubectl docker dotenv docker-compose tmux yarn npm zsh-autosuggestions autojump)

source $ZSH/oh-my-zsh.sh

#autojump fix
[[ -s `brew --prefix`/etc/autojump.sh ]] && source `brew --prefix`/etc/autojump.sh

fpath=(/usr/local/share/zsh-completions $fpath)
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval $(thefuck --alias)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/anton.serhiienko/.sdkman"
[[ -s "/Users/anton.serhiienko/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/anton.serhiienko/.sdkman/bin/sdkman-init.sh"
