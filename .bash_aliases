#!/bin/bash

# add colours to commands
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias grep='grep --colour=auto'
alias ls='ls --color=auto'

# ls aliases
alias  l='ls -CF'
alias ll='ls -lFh'
alias la='ls -lAh'

# general system commands
alias ren='mv'
alias symlink='ln -s'
alias d='exit; logout'
alias cd..='cd ..'
alias ..='cd ..'
alias where='command -v'
alias gitcommit='git commit -S'

# small utilities
alias nano='nano -Eiw'
alias myip='curl http://ipecho.net/plain; echo'
alias delempty='find . -type d -empty -print -delete'
alias findq='find 2>/dev/null'
alias hyperget='aria2c -s 999 -j 999 -x 16 -k 1M'
alias vlcplay='cvlc --play-and-exit'

# SSH aliases
alias mcpc='walkmanpc'
alias walkmanpc='ssh walkman@WalkmanLM17.local'
alias pi='ssh pi@WalkmanPi.local'
alias macbook='ssh RichardCarter@Richards-MacBook.local'

#############
# Functions #
#############

# for checksumming multiple files at once
function md5sum2 {
    for i in "$*"; do
        # echo -e "\n `md5sum $i`" &
        md5sum "$i" &
    done
    cat
}

function sha1sum2 {
    for i in "$*"; do
        sha1sum "$i" &
    done
    cat
}

# for running multiple types of checksums at once on one file
function allsum {
    md5sum "$*" &
    sha1sum "$*" &
    sha256sum "$*" &
    sha512sum "$*" &
    cat
}

# DD-reporting, run dd and check on an interval
function ddr {
    dd $* &
    pid=$!
    while true; do
        sleep 10
        kill -USR1 $pid
        if [ "$?" == "1" ]; then
            break
        fi
    done
}

# extend "where" functionality, I find myself running "la `where <program>`" too often
function about {
    # use which instead of where as where gets aliases too, e.g. ls
    if which $* 1>/dev/null; then
        la `which $*`
    else
        echo "Command \"$*\" not found!"
    fi
}

function seqget {
    if [ -z "$*" ]; then
        echo "Usage: seqget URL START END"
        echo "URL must have a %% in it to be replaced with number"
        return
    fi

    for i in `seq $2 $3`; do
        tmpURL=$1
        wget -nv "${tmpURL//%%/$i}"
    done
}

# interact with the clipboard from the command-line. got from StackOverflow somewhere
function clipboard {
    if where xclip 1>/dev/null; then
        if [[ -p /dev/stdin ]] ; then
            # stdin is a pipe
            # stdin -> clipboard
            xclip -i -selection clipboard
        else
            # stdin is not a pipe
            # clipboard -> stdout
            xclip -o -selection clipboard
        fi
    else
        echo "Remember to install xclip"
    fi
}
alias cb=clipboard

function ytget {
    if [ -z "$*" ]; then
        echo "Usage: ytget YouTubeID"
        return
    fi
    YTID="$*"
    YTID=${YTID##*=}
    if ! wget "https://i.ytimg.com/vi/$YTID/maxresdefault.jpg" -O "${YTID}_maxresdefault.jpg"; then
        rm "${YTID}_maxresdefault.jpg"
        if ! wget "https://i.ytimg.com/vi/$YTID/hqdefault.jpg" -O "${YTID}_hqdefault.jpg"; then
            rm "${YTID}_hqdefault.jpg"
            if ! wget "https://i.ytimg.com/vi/$YTID/mqdefault.jpg" -O "${YTID}_mqdefault.jpg"; then
                rm "${YTID}_mqdefault.jpg"
            fi
        fi
    fi
}

function holdkey {
    if [ -z "$*" ]; then
        echo "Usage: holdkey KEY \"Window name to search\""
        echo "e.g. \`holdkey a \"Terraria: \"\`"
        echo "Use Ctrl-C to stop"
        return
    fi
    
    if ! where xdotool 1>/dev/null; then
        echo "xdotool not installed!"
        return
    fi
    
    winid=$(xdotool search --name "$2" | head -n1)
    while true; do
        xdotool keydown --window $winid "$1"
    done
}

###########################
# device-specific aliases #
###########################
case $HOSTNAME in
    WalkmanLM17)
        . ~/.bash_aliases_walkmanlm17
        ;;
    WalkmanPi)
        . ~/.bash_aliases_walkmanpi
        ;;
    Richards-MacBook.local)
        . ~/.bash_aliases_macbook
        ;;
    localhost)
        if [[ $(uname -o) = Android ]]; then
            . ~/.bash_aliases_androidtermux
        fi
        ;;
    sailfish)
        . ~/.bash_aliases_android
        ;;
esac
