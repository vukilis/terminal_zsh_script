# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# colors, a lot of colors!
function clicolors() {
    i=1
    for color in {000..255}; do;
        c=$c"$FG[$color]$color✔$reset_color  ";
        if [ `expr $i % 8` -eq 0 ]; then
            c=$c"\n"
        fi
        i=`expr $i + 1`
    done;
    echo $c | sed 's/%//g' | sed 's/{//g' | sed 's/}//g' | sed '$s/..$//';
    c=''
}

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Custom Variables
EDITOR=vi

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zshhistory
setopt appendhistory

#aliases and shortcuts
[ -f "$HOME/.aliasrc" ] && source "$HOME/.aliasrc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# set PATH so it includes user's private bin if it exists #
# export PATH="$HOME/.local/bin:$PATH"
if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Xterm with support for 256 colors enabled
export TERM=xterm-256color

# clean up duplicates from PATH #
PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')


bindkey -e

# Ctrl + left/right arrow keys
#debian, opensuse, fedora
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# if compatibility issue 
#bindkey "^R" zsh-history-substring-search
#bindkey '^R' history-incremental-search-backward
#bindkey '^K' kill-line
#bindkey '^A' beginning-of-line
#bindkey '^E' end-of-line

# Detect Operating System
if [[ -f /etc/os-release ]]; then
    OS_ID=$(grep -oP '^ID=\K.*' /etc/os-release | tr -d '"')
fi

if [[ "$OS_ID" == "arch" ]]; then
    # --- Arch Linux Paths ---
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
elif [[ "$OS_ID" == "debian" || "$OS_ID" == "ubuntu" || "$OS_ID" == "neon" ]]; then
    # --- Debian / Ubuntu / KDE Neon Paths ---
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh	
fi

source /usr/share/autojump/autojump.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

if [ -e /home/website/.nix-profile/etc/profile.d/nix.sh ]; then . /home/website/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export PATH="$HOME/.asdf/shims:$PATH"

# --- GLOBAL COMMAND TIME LOGGER ---
# 1. Record start time and the command name
preexec() {
    timer=${timer:-$SECONDS}
    last_cmd="$1"
}

# 2. Calculate duration and save to file when command finishes
precmd() {
    if [ $timer ]; then
        local elapsed=$(( SECONDS - timer ))
        # Don't log very fast commands (less than 1s) to keep file clean
        # Remove the 'if' line below if you want to log EVERYTHING
        if [ $elapsed -gt 0 ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S'),$last_cmd,$elapsed" >> ~/.cmd_history_log
        fi
        unset timer
    fi
}

# Show top 10 longest running commands in minutes
cmd-stats() {
    echo -e "\e[32mTop 10 Longest Commands (Minutes):\e[0m"
    printf "%-20s | %-30s | %-10s\n" "Date" "Command" "Minutes"
    echo "----------------------------------------------------------------------"
    # Sort by seconds (3rd column), then use AWK to convert $3 to minutes
    sort -t',' -nk3 -r ~/.cmd_history_log | head -n 10 | awk -F',' '{
        printf "%-20s | %-30s | %-10.2f min\n", $1, $2, $3/60
    }'
}

# Calculate total time spent on all logged commands
cmd-total() {
    local log_file="$HOME/.cmd_history_log"
    if [ ! -f "$log_file" ]; then
        echo "No log file found at $log_file"
        return
    fi

    local total_seconds=$(awk -F',' '{sum+=$3} END {print sum}' "$log_file")
    
    # Simple conversion to pure minutes
    local total_minutes=$(echo "scale=2; $total_seconds / 60" | bc)
    
    # H:M:S breakdown
    local h=$(( total_seconds / 3600 ))
    local m=$(( (total_seconds % 3600) / 60 ))
    local s=$(( total_seconds % 60 ))

    echo -e "\e[32m========================================\e[0m"
    echo -e "  TOTAL TIME SPENT IN TERMINAL"
    echo -e "\e[32m========================================\e[0m"
    echo -e "Total: \e[1m$total_minutes Minutes\e[0m"
    echo -e "($h hours, $m minutes, $s seconds)"
    echo -e "\e[32m========================================\e[0m"
}

# Show total time spent per command type in minutes
cmd-usage() {
    echo -e "\e[34mTime spent per command (Top 5 in Minutes):\e[0m"
    awk -F',' '{
        split($2, cmd, " ");
        sum[cmd[1]]+=$3
    }
    END {
        for (i in sum) printf "%-15s %.2f minutes\n", i, sum[i]/60
    }' ~/.cmd_history_log | sort -rnk2 | head -n 5
}
