/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # install homebrew
brew install zsh # install zsh
brew cask install iterm2 # install iterm2
chsh -s zsh # set zsh as the default shell
exec zsh
brew install zsh-syntax-highlighting zsh-completions zsh-autosuggestions kube-ps1 # install completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # install oh-my-zsh
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font # install better font
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k # install oh-my-zsh theme
p10k configure
