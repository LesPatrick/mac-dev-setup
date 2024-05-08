#!/bin/bash

# Create a folder who contains downloaded things for the setup
INSTALL_FOLDER=~/.macsetup
mkdir -p $INSTALL_FOLDER
MAC_SETUP_PROFILE=$INSTALL_FOLDER/macsetup_profile

# install brew
if ! hash brew
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  cp .zshrc_init "$HOME/.zshrc"
  source "$HOME/.zshrc"
  brew update
else
  printf "\e[93m%s\e[m\n" "You already have brew installed."
fi

# CURL / WGET
brew install curl
brew install wget

{
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/curl/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"'
}>>$MAC_SETUP_PROFILE

# git
brew install git                                                                                      # https://formulae.brew.sh/formula/git
# Adding git aliases (https://github.com/thomaspoignant/gitalias)
cp .gitconfig ~/.gitconfig

# ZSH
brew install zsh zsh-completions                                                                      # Install zsh and zsh completions
sudo chmod -R 755 /usr/local/share/zsh
sudo chown -R root:staff /usr/local/share/zsh
{
  echo "if type brew &>/dev/null; then"
  echo "  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH"
  echo "  autoload -Uz compinit"
  echo "  compinit"
  echo "fi"
} >>$MAC_SETUP_PROFILE

# Install oh-my-zsh on top of zsh to getting additional functionality
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Terminal replacement https://www.iterm2.com
brew install --cask iterm2
# could be useful https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md

# Browser
brew install --cask google-chrome

# Music / Video
brew install --cask vlc

# Communication
brew install --cask slack

# IDE
brew install --cask visual-studio-code
code --install-extension humao.rest-client
code --install-extension esbenp.prettier-vscode

brew install xcodes

# Tools
brew install keka
brew install --cask proxyman

## python
echo "export PATH=\"/usr/local/opt/python/libexec/bin:\$PATH\"" >> $MAC_SETUP_PROFILE
brew install python
pip install --user pipenv
pip install --upgrade setuptools
pip install --upgrade pip
brew install pyenv rbenv xcodes asdf nvm
# shellcheck disable=SC2016

cp .zshrc "$HOME/.zshrc"

source "$HOME/.zshrc"

echo "!!! Remember to change name and email in .gitconfig !!!"
