

source .env_default
source .aliases
source .functions

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

#
# Brew
#
if ! type "brew" > /dev/null; then
  printf "${YELLOW}No brew present....Installing${NORMAL}\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  printf "${GREEN}updating brew${NORMAL}\n"
  # Make sure we’re using the latest Home.
   brew update

  # Upgrade any already-brewed formulae.
   brew upgrade
fi

if [ $(pwd) != "${DOT_FOLDER}" ];then
  printf "${YELLOW}Current folder is not in place, doing symlink${NORMAL}\n"
  ln -s $(pwd) ${DOT_FOLDER}
fi

mkdir -p ${DOT_BCKP_FOLDER}
BCKP_SFX=$(date +%s%3N)

printf "${GREEN}backing up OSX configuration${NORMAL}\n"
defaults read > ${DOT_BCKP_FOLDER}/.default-settings.osx.${BCKP_SFX}

for file in .{zshrc,profile,bash_profile}; do
  printf "${GREEN}backing up $file ${NORMAL}\n"
  [[ -e ${HOME}/${file} ]] && cp ${HOME}/${file} ${DOT_BCKP_FOLDER}/${file}.${BCKP_SFX}
done
unset file

printf "${GREEN}backing up brew bottles ${NORMAL}\n"
brew bundle dump --file=${DOT_BCKP_FOLDER}/Brewfile.${BCKP_SFX}

printf "${GREEN}Installing brew bottles${NORMAL}\n"
brew bundle --file=.brewfile -q -vd

printf "${YELLOW}Below are things that are not in brewfile${NORMAL}\n"
brew bundle cleanup --force --file=.brewfile


# Add entries to shells
#
printf "${GREEN}Modifying /etc/shells entries${NORMAL}\n"
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
fi;

if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
fi;

#
# install oh-my-zsh
#
printf "${GREEN}Installing oh-my-zsh${NORMAL}\n"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ] ; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ] ; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions



#
# install sdk-man
#
printf "${GREEN}Installing sdk-man${NORMAL}\n"
curl -s https://get.sdkman.io | bash

printf "${GREEN}Installing rust${NORMAL}\n"
curl https://sh.rustup.rs -sSf | sh

#
# ammonite
#
mkdir -p ${HOME}/.ammonite

#
# Symlinking
#
ln -fs ${DOT_FOLDER}/.profile ${HOME}/.profile
ln -fs ${DOT_FOLDER}/.bash_profile ${HOME}/.bash_profile
ln -fs ${DOT_FOLDER}/.zshrc ${HOME}/.zshrc
ln -fs ${DOT_FOLDER}/.vimrc ${HOME}/.vimrc
ln -fs ${DOT_FOLDER}/.gitconfig ${HOME}/.gitconfig
ln -fs ${DOT_FOLDER}/predef.sc ${HOME}/.ammonite/predef.sc

ln -fs ${DOT_FOLDER}/k9s/hotkey.yml ${HOME}/.k9s/hotkey.yml

printf "${GREEN}Reloading shell${NORMAL}\n"
reload

#
# .hushlogin
#
[ ! -f ${HOME}/.hushlogin ] && touch ${HOME}/.hushlogin

#
# OSX settings
# TODO: test
# source .settings.osx


printf "${GREEN}Git configuration${NORMAL}\n"
