## Screenshot
![Image of Yaktocat](https://raw.githubusercontent.com/vukilis/terminal_zsh_script/main/script.png)

# terminal-zsh-script

**My favourite terminals and zsh config**

## Requirements
 - AUR (for arch user)
```
git clone "https://aur.archlinux.org/yay.git"
cd yay
makepkg -si --noconfirm
yay -Sy
```

# How To Use
```
git clone https://github.com/vukilis/terminal_zsh_script
cd terminal-zsh-script
bash terminal-setup.sh
```

## What Script Do?
### - terminal-setup.sh
- Ask what terminal you want to install
- Ask what is your system based on
- Install selected terminal
- Setup terminal configuration file
- Start zsh-setup based on your system

### - arch-zsh-setup.sh & debian-zsh-setup.sh
- auto install dependencies: 
  > zsh  
  > zsh-syntax-highlighting  
  > autojump  
  > zsh-autosuggestions  
  > powerlevel10k
- make file zshhistory
- set powerlevel10k theme
- switch from BASH to ZSH
- install DroidSansMono font 
- setup files: **.p10k.zsh, .zshrc, .aliasrc**

## After script end
```
reboot, logout or restart terminal
```
## Config files of terminals
- **Terminator:** Create or open **/.config/terminator/config**
- **Alacritty:** Create or open **~/.config/alacritty/alacritty.yml**
- **Kitty:** Create or open **~/.config/kitty/kitty.conf**  

`Recommended font: MesloLGS NF Regular`

## If you want only zsh config
**Check this [script](https://github.com/vukilis/ZSH_terminal)**