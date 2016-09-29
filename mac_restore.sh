#!bin/bash

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install more recent version of Bash
brew install bash

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Install fonts
brew tap caskroom/fonts

# Set path to use new binaries
echo export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH" >> ~/.bash_profile

brew cleanup

# Binaries
binaries=(
  python
  python3
  git
  vim
  zsh
  node
)

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup

# install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Apps
apps=(
  google-drive
  google-chrome
  firefox
  flash
  silverlight
  vlc
  iterm2
  atom
  flux
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

# Configure zsh
sudo mv /etc/zshenv /etc/zprofile
cat /etc/shells | grep zsh || which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Use keychain for storing passwords
git config --global credential.helper osxkeychain

# You might not see colors without this
git config --global color.ui true

# Create development environment
mkdir ~/Development
