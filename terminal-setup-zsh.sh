#!/usr/bin/env zsh
clear

# echo "-------------------------------------"
# echo "-------   HELP INFORMATION    -------"
# echo "-------------------------------------"

show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -H, --help       Display this help message"
    echo "  -A, --author     Display author information"
    echo "  -V, --version    Display version information"
    echo ""
    echo "Controls:"
    echo "To navigate through menu use buttons [j⬇|k⬆]"
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
# echo "----------   CUSTOM MENU    ----------"
# echo "--------------------------------------"

# zsh script which offers interactive selection menu
#
# based on the answer by Guss on https://askubuntu.com/a/1386907/1771279
# and 
# lukeflo on https://codeberg.org/lukeflo/shell-scripts/src/branch/main/zshmenu.sh

function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    # count had to be assigned the pure number of arguments
    local options=("$@") cur=1 count=$# index=0
    local esc=$(echo -en "\033") # cache ESC as test doesn't allow esc codes
    echo -n "$prompt\n\n"
    # measure the rows of the menu, needed for erasing those rows when moving
    # the selection
    menu_rows=$#
    total_rows=$(($menu_rows + 1))
    while true
    do
        index=1 
        for o in "${options[@]}"
        do
            if [[ "$index" == "$cur" ]]
            then echo -e "\033[38;5;41m➤ \033[0m\033[38;5;35m$o\033[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            index=$(( $index + 1 ))
        done
        printf "\n"
        # set mark for cursor
        printf "\033[s"
        # read in pressed key (differs from bash read syntax)
        read -s -r -k key
        if [[ $key == k ]] # move up
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 1 ] && cur=1 # make sure to not move out of selections scope
        elif [[ $key == j ]] # move down
        then cur=$(( $cur + 1 ))
            [ "$cur" -gt $count ] && cur=$count # make sure to not move out of selections scope
        elif [[ "${key}" == $'\n' || $key == '' ]] # zsh inserts newline, \n, for enter - ENTER
        then break  
        fi
        # move back to saved cursor position
        printf "\033[u"
        # erase all lines of selections to build them again with new positioning
        for ((i = 0; i < $total_rows; i++)); do
            printf "\033[2k\r"
            printf "\033[F"
        done
    done
    # pass choosen selection to main body of script
    eval $outvar="'${options[$cur]}'"
}
# explicitly declare selections array makes it safer
# declare -a selections
# selections=(
# " Selection A"
# " Selection B"
# " Selection C"
# " Selection D"
# " Selection E"
# )

# call function with arguments: 
# $1: Prompt text. newline characters are possible
# $2: Name of variable which contains the selected choice
# $3: Pass all selections to the function
# choose_from_menu "Please make a choice:" selected_choice "${selections[@]}"
# echo "Selected choice: $selected_choice"

# echo "--------------------------------------"
# echo "-----   TERMINAL INSTALLATION    -----"
# echo "--------------------------------------"

echo -e "For more information check $0 --help\n"
title="Terminal installation"
nkeys="» Navigation keys: [j⬇|k⬆]"
# echo -e "$title\n"
echo -e "$nkeys\n"

checkDistroName(){
    echo -e "$( (lsb_release -is || cat /etc/*release || uname -o ) 2>/dev/null | head -n1 )\n"
}

debianTheme(){
    bash ./scriptsdebian-zsh-setup.sh
}
archTheme(){
    bash ./scriptsarch-zsh-setup.sh
}
openSUSETheme(){
    bash ./scriptsopenSUSE-zsh-setup.sh
}
fedoraTheme(){
    bash ./scriptsfedora-zsh-setup.sh
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

# Declare array and choose terminal
declare -a terminals basedOS
terminals=(
    "Alacrity"
    "Kitty"
    "Terminator"
    "xfce"
    "✖"
)

basedOS=(
    "Arch"
    "Debian"
    "Fedora"
    "openSUSE"
    "↩"
)

# za /bin/bash odraditi ?!

while true; do
    choose_from_menu "Choose terminal to install:" selected_choice "${terminals[@]}"
    if [[ "$selected_choice" == "✖" ]]; then
        echo "\e[31mGoodbye :(\e[0m"
        exit
    elif [[ "$selected_choice" == "Alacrity" ]]; then
        echo -e "You chose to install \e[32m$selected_choice\e[0m"
        while true; do
            echo ""
            choose_from_menu "What is your distro based on:" selected_choice "${basedOS[@]}"
            # if [[ "$selected_choice" == "back" ]]; then
            #     echo "\e[32m$selected_choice\e[0m"
            #     break
            if [[ "$selected_choice" == "Arch" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlArch
                    alacrittyInstallArch
                    archTheme
                    exit
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "Debian" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlDebian
                    alacrittyInstallDebian
                    debianTheme 
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "Fedora" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlFedora
                    alacrittyInstallFeodra
                    fedoraTheme
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "openSUSE" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlOpenSUSE
                    alacrittyInstallopenSUSE
                    openSUSETheme
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            else
                break
            fi
        done
    elif [[ "$selected_choice" == "Kitty" ]]; then
        echo -e "You chose to install \e[32m$selected_choice\e[0m"
        while true; do
            echo ""
            choose_from_menu "What is your distro based on:" selected_choice "${basedOS[@]}"
            if [[ "$selected_choice" == "Arch" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlArch
                    kittyInstallArch
                    archTheme
                    exit
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "Debian" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlDebian
                    kittyInstallDebian
                    debianTheme 
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "Fedora" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlFedora
                    kittyInstallFedora
                    fedoraTheme
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "openSUSE" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlOpenSUSE
                    kittyInstallopenSUSE
                    openSUSETheme   
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            else
                break
            fi
        done
    elif [[ "$selected_choice" == "Terminator" ]]; then
        echo -e "You chose to install \e[32m$selected_choice\e[0m"
        while true; do
            echo ""
            choose_from_menu "What is your distro based on:" selected_choice "${basedOS[@]}"
            if [[ "$selected_choice" == "Arch" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlArch
                    terminatorInstallArch
                    archTheme
                    exit
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "Debian" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlDebian
                    terminatorInstallDebian
                    debianTheme 
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "Fedora" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlFedora
                    terminatorInstallFedora
                    fedoraTheme
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "openSUSE" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlOpenSUSE
                    terminatorInstallopenSUSE
                    openSUSETheme   
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            else
                break
            fi
        done
    elif [[ "$selected_choice" == "xfce" ]]; then
        echo -e "You chose to install \e[32m$selected_choice\e[0m"
        while true; do
            echo ""
            choose_from_menu "What is your distro based on:" selected_choice "${basedOS[@]}"
            if [[ "$selected_choice" == "Arch" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlArch
                    xfceInstallArch
                    archTheme
                    exit
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "Debian" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlDebian
                    xfceInstallDebian
                    debianTheme 
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "Fedora" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlFedora
                    xfceInstallFedora
                    fedoraTheme
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            elif [[ "$selected_choice" == "openSUSE" ]]; then
                echo "Your system is based on: $selected_choice"
                if [[ "$(checkDistroName)" == *"$selected_choice"* ]]; then
                    echo "Detected by script: \e[32m$(checkDistroName)\e[0m"
                    checkCurlOpenSUSE
                    xfceInstallopenSUSE
                    openSUSETheme   
                else
                    echo "Detected by script: \e[31m$(checkDistroName) (Please select $(checkDistroName)!)\e[0m"
                    continue
                fi
                exit
            else
                break
            fi
        done
    else
        break
    fi
done