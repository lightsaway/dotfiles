source ${HOME}/.dotfiles/.env_default

export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOROOT:$GOPATH/bin
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

for file in .{functions,aliases,exports,extra}; do
   file="$HOME/.dotfiles/$file"
   [ -r "$file" ] && [ -f "$file" ] && source "$file";
done
unset file