#!/usr/bin/env zsh
clear

# --- 1. HELP & INFO FUNCTIONS ---
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

# --- 2. ARGUMENT PARSING ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-H) show_help; exit 0 ;;
        --author|-A) show_author; exit 0 ;;    
        --version|-V) show_version; exit 0 ;;
        *) echo "Invalid option: $1"; show_help; exit 1 ;;
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

# --- 3. CUSTOM MENU FUNCTION ---
function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift; shift
    local options=("$@") cur=1 count=$# index=0
    echo -n "$prompt\n\n"
    menu_rows=$#
    total_rows=$(($menu_rows + 1))
    while true; do
        index=1 
        for o in "${options[@]}"; do
            if [[ "$index" == "$cur" ]]; then echo -e "\033[38;5;41m➤ \033[0m\033[38;5;35m$o\033[0m"
            else echo "  $o"; fi
            index=$(( $index + 1 ))
        done
        printf "\n\033[s"
        read -s -r -k key
        if [[ $key == k ]]; then (( cur > 1 )) && cur=$(( cur - 1 ))
        elif [[ $key == j ]]; then (( cur < count )) && cur=$(( cur + 1 ))
        elif [[ "${key}" == $'\n' || $key == '' ]]; then break; fi
        printf "\033[u"
        for ((i = 0; i < $total_rows; i++)); do printf "\033[2k\r\033[F"; done
    done
    eval $outvar="'${options[$cur]}'"
}

# --- 4. INSTALLATION HELPERS ---
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
alacrittyInstallFedora(){
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

# --- 5. DYNAMIC INSTALLATION ENGINE ---
# Declare array and choose terminal
run_installation_logic() {
    local term=$1
    local selected_distro=$2
    local actual_distro=$(checkDistroName)

    if [[ "$actual_distro" != *"$selected_distro"* ]]; then
        echo -e "Detected by script: \e[31m$actual_distro (Please select $actual_distro!)\e[0m"
        return 1
    fi
    echo -e "Detected by script: \e[32m$actual_distro\e[0m"

    local term_func=$(echo "$term" | tr '[:upper:]' '[:lower:]')
    [[ "$term_func" == "alacrity" ]] && term_func="alacritty"
    local distro_func=$selected_distro

    echo -e "Installing $term for $selected_distro..."

    "checkCurl$selected_distro"     
    
    "${term_func}Install$distro_func" 
    
    "$(echo $selected_distro | tr '[:upper:]' '[:lower:]')Theme" 

    echo -e "\n\e[32mInstallation Complete!\e[0m"
    exit 0
}

# --- 6. MAIN MENU LOGIC ---
declare -a terminals basedOS
terminals=("Alacrity" "Kitty" "Terminator" "xfce" "✖")
basedOS=("Arch" "Debian" "Fedora" "openSUSE" "↩")

echo -e "For more information check $0 --help\n"
echo -e "» Navigation keys: [j⬇|k⬆]\n"

while true; do
    choose_from_menu "Choose terminal to install:" selected_term "${terminals[@]}"
    
    [[ "$selected_term" == "✖" ]] && { echo -e "\e[31mGoodbye :(\e[0m"; exit; }

    while true; do
        echo ""
        choose_from_menu "What is your distro based on ($selected_term):" selected_distro "${basedOS[@]}"
        
        [[ "$selected_distro" == "↩" ]] && break 

        run_installation_logic "$selected_term" "$selected_distro"
    done
done