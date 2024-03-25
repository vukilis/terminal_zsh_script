# Screenshot

![terminal_zsh_script](https://raw.githubusercontent.com/vukilis/terminal_zsh_script/main/script.png)

## terminal-zsh-script

**My favorite terminals and zsh config.**

* Terminator
* Alacrity
* Kitty
* xfce terminal

## Distribution Support

* Arch
* Debian
* Fedora
* opensSUSE

## Requirements

* AUR (for arch user)

```bash
git clone "https://aur.archlinux.org/yay.git"
cd yay
makepkg -si --noconfirm
yay -Sy
```

## How To Use

* If you use **bash** shell, incompatible to ZSH

```bash
git clone https://github.com/vukilis/terminal_zsh_script
cd terminal-zsh-script
./terminal-setup.sh
```

* If you use **ZSH** shell, compatible to ZSH

```zsh
git clone https://github.com/vukilis/terminal_zsh_script
cd terminal-zsh-script
./terminal-setup-zsh.sh
```

## What Script Do?

### - terminal-setup.sh

* Ask what terminal you want to install
* Ask what is your system based on
* Install selected terminal
* Setup terminal configuration file
* Start zsh-setup based on your system

### - [arch/debian/fedora/openSUSE]-zsh-setup.sh

* auto install dependencies:
  > zsh  
  > zsh-syntax-highlighting  
  > autojump  
  > zsh-autosuggestions  
  > powerlevel10k
* make file zshhistory
* set powerlevel10k theme
* switch from BASH to ZSH
* install DroidSansMono font
* setup files: **.p10k.zsh, .zshrc, .aliasrc**

## After script end

```bash
reboot, logout or restart terminal
```

## Config files of terminals

* **Terminator:** Create or open **/.config/terminator/config**
* **Alacritty:** Create or open **~/.config/alacritty/alacritty.yml**
* **Kitty:** Create or open **~/.config/kitty/kitty.conf**  
* **xfce terminal**: Create or open ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml

`Recommended font: MesloLGS NF Regular`
