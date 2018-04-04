[[ -e ~/.profile ]] && source ${HOME}/.profile
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/anton.serhiienko/.sdkman"
[[ -s "/Users/anton.serhiienko/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/anton.serhiienko/.sdkman/bin/sdkman-init.sh"
