clear
echo "--------------------------------------"
echo "-----       ZSH INSTALATION      -----"
echo "--------------------------------------"

apt install -y zsh zsh-syntax-highlighting autojump zsh-autosuggestions
touch "$HOME/.cache/zshhistory"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
chsh $USER -s /bin/zsh
#echo $SHELL

echo "--------------------------------------"
echo "-----         ZSH SETUP          -----"
echo "--------------------------------------"

sudo cp -r DroidSansMono /usr/share/fonts/DroidSansMono
fc-cache -f -v
cp .p10k.zsh $HOME/.p10k.zsh
cp .zshrc $HOME/.zshrc
cp .aliasrc $HOME/.aliasrc
source ~/.zshrc
source ~/.p10k.zsh

echo "--------------------------------------"
echo "-----            END             -----"
echo "--------------------------------------"
echo "REBOOT PC"
