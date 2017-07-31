# add colours to commands
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias grep='grep --colour=auto'
alias ls='ls --color=auto'

# ls aliases
alias l='ls -CF'
alias ll='ls -lhF'
alias la='ls -lAh'

# general system commands
alias ren='mv'
alias symlink='ln -s'
alias d='exit; logout'
alias cd..='cd ..'
alias ..='cd ..'
alias where='command -v'

# small utilities
alias myip='curl http://ipecho.net/plain; echo'
alias delempty='find . -type d -empty -print -delete'
alias findq='find 2>/dev/null'
alias hyperget='aria2c -s 999 -j 999 -x 16 -k 1M'

# device-specific aliases
if [[ $(uname -o) = Android ]]; then
    . .bash_aliases_android
else
    case $HOSTNAME in
        WalkmanLM17)
            . .bash_aliases_walkmanlm17
            ;;
        WalkmanPI)
            . .bash_aliases_walkmanpi
            ;;
        Richards-MacBook.local)
            . .bash_aliases_macbook
    esac
fi

# functions
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

function allsum {
    md5sum "$*" &
    sha1sum "$*" &
    sha256sum "$*" &
    sha512sum "$*" &
    cat
}

function about {
    if where $* 1>/dev/null; then
        la `where $*`
    else
        echo "Command \"$*\" not found!"
    fi
}

function seqget {
    # usage: seqget URL START END
    # URL must have a %% in it to be replaced with number

    for i in `seq $2 $3`; do
        tmpURL=$1
        wget -nv "${tmpURL//%%/$i}"
    done
}

function clipboard {
    if command -v xclip 1>/dev/null; then
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
    # usage: ytget YouTubeID
    wget "https://i.ytimg.com/vi/$*/maxresdefault.jpg" -O "$*_maxresdefault.jpg" || wget "https://i.ytimg.com/vi/$*/hqdefault.jpg" -O "$*_hqdefault.jpg"
}
