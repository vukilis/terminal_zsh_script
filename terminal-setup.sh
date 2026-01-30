#!/bin/bash
clear

# echo "-------------------------------------"
# echo "-------   HELP INFORMATION    -------"
# echo "-------------------------------------"

show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -H, --help       Display this help message"
    echo "  -A, --author     Display author information"
    echo "  -V, --version    Display version information"
}
show_version() {
    echo "terminal-zsh-script Version 2.0"
}

show_author() {
    echo -e "AUTHOR: 
    Vuk1lis
WEBSITE: 
    https://vukilis.github.io/website/
GITHUB: 
    https://github.com/vukilis
NAME: 
    terminal-zsh-script
VERSION: 
    2.0"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help | -H)
            show_help
            exit 0
            ;;
        --author | -A)
            show_author
            exit 0
            ;;    
        --version | -V)
            show_version
            exit 0
            ;;
        *)
            echo "Invalid option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# echo "--------------------------------------"
# echo "-----   TERMINAL INSTALLATION    -----"
# echo "--------------------------------------"

title="Terminal installation"
prompt="Choose terminal to install: "
terminals=("Terminator" "Alacrity" "Kitty" "xfce")
basedOn="What is your distro based on: "
basedOS=("Debian" "Arch" "openSUSE" "Fedora")

echo -e "For more information check $0 --help\n"
echo -e "$title\n"
PS3="$prompt"

# checkDistroName(){
#     echo -e "$( (lsb_release -is || cat /etc/*release || uname -o ) 2>/dev/null | head -n1 )\n"
# }

checkDistroName() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        # Check ID and ID_LIKE first
        case "$ID $ID_LIKE" in
            *arch*) echo "Arch" ;;
            *debian*|*ubuntu*) echo "Debian" ;;
            *fedora*|*rhel*|*centos*) echo "Fedora" ;;
            *suse*|*opensuse*) echo "openSUSE" ;;
            *)
                # Fallback: Check for the package manager
                if [ -f /usr/bin/pacman ]; then echo "Arch"
                elif [ -f /usr/bin/apt ]; then echo "Debian"
                elif [ -f /usr/bin/dnf ]; then echo "Fedora"
                elif [ -f /usr/bin/zypper ]; then echo "openSUSE"
                else echo "unknown"
                fi
                ;;
        esac
    fi
}

debianTheme(){
    bash ./scripts/debian-zsh-setup.sh
}
archTheme(){
    bash ./scripts/arch-zsh-setup.sh
}
openSUSETheme(){
    bash ./scripts/openSUSE-zsh-setup.sh
}
fedoraTheme(){
    bash ./scripts/fedora-zsh-setup.sh
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
    cp config/terminator/terminator.conf $HOME/.config/terminator/config
}
terminatorInstallArch(){
    sudo pacman -S terminator --noconfirm
    mkdir $HOME/.config/terminator/
    cp config/terminator/terminator.conf $HOME/.config/terminator/config
}
terminatorInstallopenSUSE(){
    sudo zypper --non-interactive install terminator
    mkdir $HOME/.config/terminator/
    cp config/terminator/terminator.conf $HOME/.config/terminator/config
}
terminatorInstallFedora(){
    sudo dnf install -y terminator
    mkdir $HOME/.config/terminator/
    cp config/terminator/terminator.conf $HOME/.config/terminator/config
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
    cp config/alacritty/alacritty.toml $HOME/.config/alacritty/alacritty.toml
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
    cp config/alacritty/alacritty.toml $HOME/.config/alacritty/alacritty.toml
}
alacrittyInstallopenSUSE(){
    sudo zypper --non-interactive install alacritty
    mkdir $HOME/.config/alacritty/
    cp config/alacritty/alacritty.toml $HOME/.config/alacritty/alacritty.toml
}
alacrittyInstallFeodra(){
    sudo dnf install -y alacritty
    mkdir $HOME/.config/alacritty/
    cp config/alacritty/alacritty.toml $HOME/.config/alacritty/alacritty.toml
}

kittyInstallDebian(){
    sudo apt install -y kitty
    mkdir $HOME/.config/kitty/
    cp config/kitty/gtk-3.0 $HOME/gtk-3.0
    cp config/kitty/kitty-themes $HOME/.config/kitty
    cp config/kitty/kitty.conf $HOME/.config/kitty
    cp config/kitty/theme.conf $HOME/.config/kitty
}
kittyInstallArch(){
    yay -S kitty --noconfirm
    mkdir $HOME/.config/kitty/
    cp config/kitty/gtk-3.0 $HOME/gtk-3.0
    cp config/kitty/kitty-themes $HOME/.config/kitty
    cp config/kitty/kitty.conf $HOME/.config/kitty
    cp config/kitty/theme.conf $HOME/.config/kitty
}
kittyInstallopenSUSE(){
    sudo zypper --non-interactive install kitty
    mkdir $HOME/.config/kitty/
    cp config/kitty/gtk-3.0 $HOME/gtk-3.0
    cp config/kitty/kitty-themes $HOME/.config/kitty
    cp config/kitty/kitty.conf $HOME/.config/kitty
    cp config/kitty/theme.conf $HOME/.config/kitty
}
kittyInstallFedora(){
    sudo dnf install -y kitty
    mkdir $HOME/.config/kitty/
    cp config/kitty/gtk-3.0 $HOME/gtk-3.0
    cp config/kitty/kitty-themes $HOME/.config/kitty
    cp config/kitty/kitty.conf $HOME/.config/kitty
    cp config/kitty/theme.conf $HOME/.config/kitty
}

xfceInstallDebian(){
    sudo apt install -y xfce4-terminal
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
    cp config/xfce/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
}
xfceInstallArch(){
    sudo pacman -S xfce4-terminal --noconfirm # yay -S fce4-terminal
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
    cp config/xfce/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
}
xfceInstallopenSUSE(){
    sudo zypper --non-interactive install xfce4-terminal
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
    cp config/xfce/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
}
xfceInstallFedora(){
    sudo dnf install -y xfce4-terminal
    mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
    cp config/xfce/xfce4-terminal.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-terminal.xml
}


# Main Terminal Menu Prompt
PS3="Choose terminal to install: "

# Main Terminal Menu
PS3="Choose terminal to install: "

while true; do
    select terminal in "${terminals[@]}" "Quit"; do 
        case "$REPLY" in
            1|2|3|4) 
                echo -e "\nYou chose: \e[32m$terminal\e[0m"
                
                PS3="Select your Distro: "
                
                select based in "${basedOS[@]}" "Back"; do
                    case $REPLY in
                        $((${#basedOS[@]}+1)) | "Back")
                            echo -e "\e[33mReturning to main menu...\e[0m\n"
                            PS3="Choose terminal to install: "
                            REPLY="" 
                            break 2  
                            ;;
                        
                        1|2|3|4)
                            actual_distro=$(checkDistroName)
                            if [[ "$actual_distro" == *"$based"* ]]; then
                                echo -e "System Match: \e[32m$actual_distro\e[0m"
                                
                                case "$terminal" in
                                    "Terminator")
                                        [[ "$based" == "Debian" ]]   && { checkCurlDebian; terminatorInstallDebian; debianTheme; }
                                        [[ "$based" == "Arch" ]]     && { checkCurlArch; terminatorInstallArch; archTheme; }
                                        [[ "$based" == "openSUSE" ]] && { checkCurlOpenSUSE; terminatorInstallopenSUSE; openSUSETheme; }
                                        [[ "$based" == "Fedora" ]]   && { checkCurlFedora; terminatorInstallFedora; fedoraTheme; }
                                        ;;
                                    "Alacrity")
                                        [[ "$based" == "Debian" ]]   && { checkCurlDebian; alacrittyInstallDebian; debianTheme; }
                                        [[ "$based" == "Arch" ]]     && { checkCurlArch; alacrittyInstallArch; archTheme; }
                                        [[ "$based" == "openSUSE" ]] && { checkCurlOpenSUSE; alacrittyInstallopenSUSE; openSUSETheme; }
                                        [[ "$based" == "Fedora" ]]   && { checkCurlFedora; alacrittyInstallFeodra; fedoraTheme; }
                                        ;;
                                    "Kitty")
                                        [[ "$based" == "Debian" ]]   && { checkCurlDebian; kittyInstallDebian; debianTheme; }
                                        [[ "$based" == "Arch" ]]     && { checkCurlArch; kittyInstallArch; archTheme; }
                                        [[ "$based" == "openSUSE" ]] && { checkCurlOpenSUSE; kittyInstallopenSUSE; openSUSETheme; }
                                        [[ "$based" == "Fedora" ]]   && { checkCurlFedora; kittyInstallFedora; fedoraTheme; }
                                        ;;
                                    "xfce")
                                        [[ "$based" == "Debian" ]]   && { checkCurlDebian; xfceInstallDebian; debianTheme; }
                                        [[ "$based" == "Arch" ]]     && { checkCurlArch; xfceInstallArch; archTheme; }
                                        [[ "$based" == "openSUSE" ]] && { checkCurlOpenSUSE; xfceInstallopenSUSE; openSUSETheme; }
                                        [[ "$based" == "Fedora" ]]   && { checkCurlFedora; xfceInstallFedora; fedoraTheme; }
                                        ;;
                                esac
                                exit 0
                            else
                                echo -e "Detected by script: \e[31m$actual_distro (Please select $actual_distro!)\e[0m"
                            fi
                            ;;

                        *)
                            echo -e "- \e[31m$REPLY is invalid option. Try another one.\e[0m -"
                            ;;
                    esac
                done
                break 
                ;;

            $((${#terminals[@]}+1)) | "Quit") 
                echo "Goodbye!"
                exit 0
                ;;

            *) 
                echo -e "- \e[31m$REPLY is invalid option. Try another one.\e[0m -"
                ;;
        esac
    done
done

# echo "--------------------------------------"
# echo "-----    INSTALLATION FINISH     -----"
# echo "--------------------------------------"