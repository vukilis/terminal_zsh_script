#!/bin/bash
# lsb_release -is || cat /etc/*release || uname -om ) 2>/dev/null | head -n1
title="Terminal installation"
prompt="Choose terminal to install: "
terminals=("Terminator" "Alacrity" "Kitty")
basedOn="What is your distro based on: "
basedOS=("debian" "arch")

echo -e "$title\n"
PS3="$prompt"

checkDistroName(){
    echo -e "System name is: $( (lsb_release -is || cat /etc/*release || uname -o ) 2>/dev/null | head -n1 ) \n"
}

debianTheme(){
    bash debian-setup.sh
}
archTheme(){
    bash arch-setup.sh
}

checkCurlDebian(){
    PKG="curl"
    check=$(dpkg-query -W --showformat='${Status}\n' $PKG | grep "Already installed")
    echo Checking for $PKG: $check
    if [ "" = "$check" ]; then
        echo "No $PKG. Setting up $PKG."
        sudo apt install -y $PKG
    fi
}
checkCurlArch(){
    PKG="curl";
    check="$(sudo pacman -Qs --color always "${PKG}" | grep "local" | grep "${PKG} ")"
    if [ -n "${check}" ] ; then
        echo "${PKG} is installed"
    elif [ -z "${check}" ] ; then
        echo "${PKG} is NOT installed"
        sudo pacman -Sy $PKG
    fi;
}

terminatorInstallDebian(){
    sudo apt install -y terminator
    mkdir $HOME/.config/terminator/
    cp config/terminator.conf $HOME/.config/terminator/config
}
terminatorInstallArch(){
    sudo pacman -S terminator --noconfirm
    mkdir $HOME/.config/terminator/
    cp config/terminator.conf $HOME/.config/terminator/config
}
alacrittyInstallDebian(){
    sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
    source $HOME/.cargo/env 
    sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 -y
    git clone https://github.com/jwilm/alacritty.git
    cd alacritty
    cargo build --release
    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    sudo mkdir -p /usr/local/share/man/man1
    gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
    cd ..
    mkdir $HOME/.config/alacritty/
    cp config/alacritty.yml $HOME/.config/alacritty/alacritty.yml
}
alacrittyInstallArch(){
    # sudo pacman -S alacritty --noconfirm
    sudo curl https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env 
    pacman -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python
    git clone https://github.com/jwilm/alacritty.git
    cd alacritty
    cargo build --release
    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
    sudo mkdir -p /usr/local/share/man/man1
    gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
    cd ..
    mkdir $HOME/.config/alacritty/
    cp config/alacritty.yml $HOME/.config/alacritty/alacritty.yml
}
# xfce4TerminalInstallDebian(){
#     sudo apt-get update
#     sudo apt-get install xfce4-terminal -y
# }
# xfce4TerminalInstallArch(){
#     yay -S xfce4-terminal --noconfirm
# }
# zavrsiti config
kittyInstallDebian(){
    sudo apt install -y kitty
    mkdir $HOME/.config/kitty/
    cp config/kitty.conf $HOME/.config/kitty/kitty.conf
            #for now disabled ~ reason term: xterm
    # curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    # launch=n
    # ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
    # cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
    # sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop
    # echo 'Please check your ~/.profile file and uncomment PATH: "$HOME/.local/bin:"\n'
}
kittyInstallArch(){
    yay -S kitty --noconfirm
    mkdir $HOME/.config/kitty/
    cp config/kitty.conf $HOME/.config/kitty/kitty.conf
}

# checkBin(){
#     DIR=~/.local/bin
#     if [ ! -d $DIR ]; then
#         echo "Warning: '$DIR' NOT found. '$DIR' will be made..."
#         mkdir $DIR
#         echo "----------------------------------------------------------------------------\n"
#     else
#         echo "'$DIR' found and now copying files, please wait ...\n"
#     fi
# }

select terminal in "${terminals[@]}" "Quit"; do 
    case "$REPLY" in
    1) echo -e "You choose to install $terminal\n" # Terminator
        PS3="$basedOn"
        select based in "${basedOS[@]}"; do 
            case "$REPLY" in
            1) echo "Your system is based on $based"
                checkDistroName
                terminatorInstallDebian
                debianTheme
                break;;
            2) echo "Your system is based on $based"
                checkDistroName
                terminatorInstallArch
                archTheme
                break;;
            *) echo "- $REPLY is invalid option. Try another one. -";continue;;
            esac
        done
        break;;
    2) echo "You choose to install $terminal"  # Alacritty
        PS3="$basedOn"
        select based in "${basedOS[@]}"; do 
            case "$REPLY" in
            1) echo "Your system is based on $based"
                checkDistroName
                alacrittyInstallDebian
                debianTheme 
                break;;
            2) echo "Your system is based on $based"
                checkDistroName
                alacrittyInstallArch
                archTheme
                break;;
            *) echo "- $REPLY is invalid option. Try another one. -";continue;;
            esac
        done
        # sudo apt install -y alacritty
        break;;
    3) echo -e "You choose to install $terminal\n" # Kitty
        PS3="$basedOn"
        select based in "${basedOS[@]}"; do 
            case "$REPLY" in
            1) echo "Your system is based on $based"
                checkDistroName
                checkCurlDebian
                kittyInstallDebian
                debianTheme
                break;;
            2) echo "Your system is based on $based"
                checkDistroName
                checkCurlArch
                kittyInstallArch
                archTheme
                break;;
            *) echo "- $REPLY is invalid option. Try another one. -";continue;;
            esac
        done
        break;;
    $((${#terminals[@]}+1))) echo "Goodbye!"; break;;
    *) echo "- $REPLY is invalid option. Try another one. -";continue;;
    esac
done