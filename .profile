source ${HOME}/.dotfiles/.env_default
source ${HOME}/.sdkman/bin/sdkman-init.sh

export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOROOT:$GOPATH/bin
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="/opt/homebrew/bin:$PATH"
eval "$(pyenv init -)"

for file in .{functions,aliases,exports}; do
   file="$HOME/.dotfiles/$file"
   [ -r "$file" ] && [ -f "$file" ] && source "$file";
done
unset file
[ -r "${HOME}/.extra" ] && [ -f "${HOME}/.extra" ] && source "${HOME}/.extra";


export GIT_EDITOR=vim

source "$HOME/.cargo/env"
