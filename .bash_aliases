alias la='ls -lAh'
alias ren='mv'
alias symlink='ln -s'
alias d='exit; logout'
alias cd..='cd ..'
alias ..='cd ..'
alias where='command -v'

alias myip='curl http://ipecho.net/plain; echo'
alias delempty='find . -type d -empty -print -delete'
alias findq='find 2>/dev/null'
alias chromecast='pulseaudio-dlna'
alias hyperget='aria2c -s 999 -j 999 -x 16 -k 1M'

alias pi='ssh pi@WalkmanPI.local'
alias gitcommit='git commit -S'
alias aptupdate='apt update && apt upgrade -y; apt dist-upgrade -y; apt install -y; apt install -f -y; apt check -y; apt autoremove -y; apt autoclean'
alias mcsrv='cd /srv/Minecraft/FTBInfinityServer; bash ServerStart.sh'
alias mcsrv2='cd /srv/Minecraft/FTBBeyondServer; bash ServerStart.sh'
alias mctmux='tmux new-session -s FTBBeyond "cd /srv/Minecraft/FTBBeyondServer; bash ServerStart.sh; bash"'
alias benlan='tmux new-session -s BenLan "cd /srv/Minecraft/PrivateSurvivalBenLan; bash ServerStart.sh; bash"'

alias adb=/home/walkman/bin/platform-tools/adb
alias dmtracedump=/home/walkman/bin/platform-tools/dmtracedump
alias etc1tool=/home/walkman/bin/platform-tools/etc1tool
alias fastboot=/home/walkman/bin/platform-tools/fastboot
alias hprof-conv=/home/walkman/bin/platform-tools/hprof-conv
alias sqlite3=/home/walkman/bin/platform-tools/sqlite3
alias abe='java -jar "/media/walkman/Buffalo HD-PZU3/Media/Software/Android Apps/android-backup-extractor-20160710-bin/abe.jar"'
alias helium="bash /home/walkman/bin/helium/run.sh"
alias adbreboot="sudo adb kill-server; sudo killall adb 2>/dev/null; sudo /home/walkman/bin/platform-tools/adb start-server"

function autoclone {
    git config --global core.autocrlf false
    git clone --recursive https://github.com/$1
    git config --global core.autocrlf true
    cd "${1##*/}"
    git config --local core.autocrlf false
}

function md5sum2 {
    for i in "$*"; do
        # echo -e "\n `md5sum $i`" &
        md5sum "$i" &
    done
    cat
}

function sha1sum2 {
    for i in "$*"; do
        # echo -e "\n `sha1sum $i`" &
        sha1sum "$i" &
    done
    cat
}

function allsum {
    # echo -e "\n `md5sum $i`" &
    md5sum "$*" &
    sha1sum "$*" &
    sha256sum "$*" &
    sha512sum "$*" &
    cat
}

function seqget {
    # usage: seqget URL START END
    # URL must have a %% in it to be replaced with number

    for i in `seq $2 $3`; do
        tmpURL=$1
        wget -nv "${tmpURL//%%/$i}"
    done
}

function about {
    if where $* 1>/dev/null; then
        la `where $*`
    else
        echo "Command \"$*\" not found!"
    fi
}

alias cb=clipboard
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

function ytget {
    # usage: ytget YouTubeID
    wget "https://i.ytimg.com/vi/$*/maxresdefault.jpg" -O "$*_maxresdefault.jpg" || wget "https://i.ytimg.com/vi/$*/hqdefault.jpg" -O "$*_hqdefault.jpg"
}
