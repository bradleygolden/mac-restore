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
  git
  vim
  macvim --overide-system-vim
  tmux
  mackup
  rcm
  zsh
)

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup

# Apps
apps=(
  google-drive
  google-chrome
  flash
  silverlight
  vlc
  dash
  slack
  spotify
  iterm2
  atom
  microsoft-office
  microsoft-lync
  amazon-music
  flux
  kindle
  dash
  java
  android-studio
  xamarin
  xamarin-android
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

# Configure zsh
sudo mv /etc/zshenv /etc/zprofile
cat /etc/shells | grep zsh || which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)

# Use keychain for storing passwords
git config --global credential.helper osxkeychain

# You might not see colors without this
git config --global color.ui true

# Create development environment
mkdir ~/Development

# Clone all public repos into the development environment
username=bradleygolden
echo "cloning repos..."
curl -o ~/Development —u $username -s https://api.github.com/users/$username/repos?per_page=200 | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

# Restore previous configurations using mackup
# Make sure your storage service is installed first
# If it's not, this will fail and will need to be ran later

# First copy the mackup.cfg file to the correct directory
cp ~/Development/mac-restore/.mackup.cfg ~

# Run the restore for saved configurations
mackup restore
