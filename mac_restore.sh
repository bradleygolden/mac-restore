#!bin/bash

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
fi

# install brew binaries/cask applications/app store applications
brew bundle --file=homebrew/Brewfile
brew cleanup

# setup pyenv
echo 'eval "$(pyenv init -)"' >> ~/.zshenv
echo "installing python versions..."
pyenv install 2.7.13
pyenv install 3.6.0
pyenv global system 2.7.13 3.6.0  # set python version defaults

# install necessary system wide pip packages
python3 -m pip install -r pip/requirements.txt

# setup atom
echo "installing atom plugins..."
apm install --packages-file atom/package-list.txt

# Create development folder
mkdir ~/Development
