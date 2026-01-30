#!/bin/bash

clear
echo "--------------------------------------"
echo "-----       ZSH INSTALATION      -----"
echo "--------------------------------------"

yay -S zsh zsh-syntax-highlighting autojump zsh-autosuggestions --noconfirm
touch "$HOME/.cache/zshhistory"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
sudo chsh $USER -s /bin/zsh
#echo $SHELL

echo "--------------------------------------"
echo "-----         ZSH SETUP          -----"
echo "--------------------------------------"

sudo cp -r fonts/DroidSansMono /usr/share/fonts/DroidSansMono
fc-cache -f -v
cp config/kitty/.p10k.zsh config/kitty/.zshrc config/kitty/.aliasrc $HOME

source ~/.zshrc
source ~/.p10k.zsh

echo "--------------------------------------"
echo "-----            END             -----"
echo "--------------------------------------"
echo "REBOOT PC"

