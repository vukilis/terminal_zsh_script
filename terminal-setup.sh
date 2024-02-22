#!/bin/bash
clear

echo "--------------------------------------"
echo "-----   TERMINAL INSTALLATION    -----"
echo "--------------------------------------"

title="Terminal installation"
prompt="Choose terminal to install: "
terminals=("Terminator" "Alacrity" "Kitty" "xfce")
basedOn="What is your distro based on: "
basedOS=("Debian" "Arch" "openSUSE" "Fedora")

echo -e "$title\n"
PS3="$prompt"

checkDistroName(){
    echo -e "System name is: $( (lsb_release -is || cat /etc/*release || uname -o ) 2>/dev/null | head -n1 ) \n"
}

debianTheme(){
    bash debian-zsh-setup.sh
}
archTheme(){
    bash arch-zsh-setup.sh
}
openSUSETheme(){
    bash openSUSE-zsh-setup.sh
}
fedoraTheme(){
    bash fedora-zsh-setup.sh
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
checkCurlOpenSUSE(){
    PKG="curl";
    if [ ! command -v $PKG &> /dev/null ]; then
        echo "curl is not installed. Installing..."
        sudo zypper install -y curl
        echo "curl has been installed."
    else
        echo "curl is already installed."
    fi
}
checkCurlFedora(){
    PKG="curl";
    if ! command -V $PKG &> /dev/null
    then
        echo "curl is not installed. Installing..."
        sudo dnf install -y curl
        echo "curl has been installed."
    else
        echo "curl is already installed."
    fi
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
terminatorInstallopenSUSE(){
    sudo zypper --non-interactive install terminator
    mkdir $HOME/.config/terminator/
    cp config/terminator.conf $HOME/.config/terminator/config
}
terminatorInstallFedora(){
    sudo dnf install -y terminator
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
    cp config/alacritty.toml $HOME/.config/alacritty/alacritty.toml
}
alacrittyInstallArch(){
    # sudo pacman -S alacritty --noconfirm
    sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
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
    cp config/alacritty.toml $HOME/.config/alacritty/alacritty.toml
}
alacrittyInstallopenSUSE(){
    sudo zypper --non-interactive install alacritty
    mkdir $HOME/.config/alacritty/
    cp config/alacritty.toml $HOME/.config/alacritty/alacritty.toml
}
alacrittyInstallFeodra(){
    sudo dnf install -y alacritty
    mkdir $HOME/.config/alacritty/
    cp config/alacritty.toml $HOME/.config/alacritty/alacritty.toml
}

kittyInstallDebian(){
    sudo apt install -y kitty
    mkdir $HOME/.config/kitty/
    cp config/kitty.conf $HOME/.config/kitty/kitty.conf
}
kittyInstallArch(){
    yay -S kitty --noconfirm
    mkdir $HOME/.config/kitty/
    cp config/kitty.conf $HOME/.config/kitty/kitty.conf
}
kittyInstallopenSUSE(){
    sudo zypper --non-interactive install kitty
    mkdir $HOME/.config/kitty/
    cp config/kitty.conf $HOME/.config/kitty/kitty.conf
}
kittyInstallFedora(){
    sudo dnf install -y kitty
    mkdir $HOME/.config/kitty/
    cp config/kitty.conf $HOME/.config/kitty/kitty.conf
}

xfceInstallDebian(){
    sudo apt install -y xfce4-terminal
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
    cp config/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
}
xfceInstallArch(){
    sudo pacman -S xfce4-terminal --noconfirm # yay -S fce4-terminal
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
    cp config/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
}
xfceInstallopenSUSE(){
    sudo zypper --non-interactive install xfce4-terminal
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
    cp config/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
}
xfceInstallFedora(){
    sudo dnf install -y xfce4-terminal
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
    cp config/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
}


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
            3) echo "Your system is based on $based"
                checkDistroName
                terminatorInstallopenSUSE
                openSUSETheme
                break;;
            4) echo "Your system is based on $based"
                checkDistroName
                terminatorInstallFedora
                fedoraTheme
                break;;
            *) echo "- $REPLY is invalid option. Try another one. -";continue;;
            esac
        done
        break;;
    2) echo -e "You choose to install $terminal\n"  # Alacritty
        PS3="$basedOn"
        select based in "${basedOS[@]}"; do 
            case "$REPLY" in
            1) echo "Your system is based on $based"
                checkDistroName
                checkCurlDebian
                alacrittyInstallDebian
                debianTheme 
                break;;
            2) echo "Your system is based on $based"
                checkDistroName
                checkCurlArch
                alacrittyInstallArch
                archTheme
                break;;
            3) echo "Your system is based on $based"
                checkDistroName
                checkCurlOpenSUSE
                alacrittyInstallopenSUSE
                openSUSETheme
                break;;
            4) echo "Your system is based on $based"
                checkDistroName
                checkCurlFedora
                alacrittyInstallFeodra
                fedoraTheme
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
                kittyInstallDebian
                debianTheme
                break;;
            2) echo "Your system is based on $based"
                checkDistroName
                kittyInstallArch
                archTheme
                break;;
            3) echo "Your system is based on $based"
                checkDistroName
                kittyInstallopenSUSE
                openSUSETheme
                break;;
            4) echo "Your system is based on $based"
                checkDistroName
                kittyInstallFedora
                fedoraTheme
                break;;
            *) echo "- $REPLY is invalid option. Try another one. -";continue;;
            esac
        done
        break;;
    4) echo -e "You choose to install $terminal\n" # xfce
        PS3="$basedOn"
        select based in "${basedOS[@]}"; do 
            case "$REPLY" in
            1) echo "Your system is based on $based"
                checkDistroName
                xfceInstallDebian
                debianTheme
                break;;
            2) echo "Your system is based on $based"
                checkDistroName
                xfceInstallArch
                archTheme
                break;;
            3) echo "Your system is based on $based"
                checkDistroName
                xfceInstallopenSUSE
                openSUSETheme
                break;;
            4) echo "Your system is based on $based"
                checkDistroName
                xfceInstallFedora
                fedoraTheme
                break;;
            *) echo "- $REPLY is invalid option. Try another one. -";continue;;
            esac
        done
        break;;
    $((${#terminals[@]}+1))) echo "Goodbye!"; break;;
    *) echo "- $REPLY is invalid option. Try another one. -";continue;;
    esac
done

echo "--------------------------------------"
echo "-----    INSTALLATION FINISH     -----"
echo "--------------------------------------"