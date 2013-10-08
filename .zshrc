# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=${HISTSIZE}
setopt APPEND_HISTORY

bindkey -e

if ssh-add -L 2>&1 | fgrep -q "Could not open a connection to your authentication agent."
then
    sshinit=$(mktemp)
    ssh-agent>$sshinit
    . $sshinit>/dev/null
    rm -f $sshinit
fi
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extendedglob

autoload -Uz compinit zkbd colors tetris
zle -N tetris
compinit
colors

local short_pwd
get_short_pwd() {
    short_pwd=`pwd|sed "s,$HOME,~,"|grep -o "[^/]*\(/[^/]*\)\?$"`
}

chpwd() {
    if [[ "$TERM" == "screen.linux" || "$TERM" == "screen" ]]
    then
        get_short_pwd
        echo -ne "\ek"$short_pwd"\e\\"
    fi
}

preexec() {
    if [[ "$TERM" == "screen.linux" || "$TERM" == "screen" ]]
    then
        name=`echo $1|sed 's/^ *sudo\([ ]\+[-][^ ]*\)*//;s/^\([a-zA-Z0-9_-]\+=\( \|"[^"]*"\)[ ]*\)\+//;s/[ ]*\([&][&]\|[|][|]\|[;]\).*//;s/^ \+//'|sed "s/sh -c \?'\([^']*\)'/\1/"`
        if ! echo "$name"|grep -qE "^(emerge|wine|layman|tail|sleep|qfile|list|screen|mutt|mcabber|man|less|vimpager|irssi)"
        then
            get_short_pwd
            name=`echo $name|sed 's/ .*//'`@$short_pwd
        elif echo "$name"|grep -q "^mutt"
        then
            name=mail@`echo $name|sed 's/^[^/]*[/]//;s/[/].*//'`
        elif echo "$name"|grep -q "^mcabber"
        then
            name=xmpp@`echo $name|sed 's/^[^/]*[/]//;s/[/].*//'`
        elif echo "$name"|grep -q "^irssi"
        then
            name=irc@`echo $name|sed 's/.*--connect=//;s/[.][^.]\+ .*//;s/.*[.]//'`
        fi
        echo -ne "\ek"$name"\e\\"
    fi
}

precmd() {
    chpwd
}

prompt='%B%F{green}%n%b%F{yellow}@%B%F{red}%m%b %F{cyan}%~%F{red}%v %(?.%F{green}$.%F{red}%?)%f '

[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]] && zkbd
source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" beep
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

cd
export EDITOR=vim
export BROWSER=w3m
if which vimpager >/dev/null 2>&1
then
    export PAGER=vimpager
fi
if which vimmanpager >/dev/null 2>&1
then
    export MANPAGER=vimmanpager
fi
if which w3mman >/dev/null 2>&1
then
    export MANPAGER=less
    alias man=w3mman
fi
export GTK_IM_MODULE=xim
export VDPAU_NVIDIA_NO_OVERLAY=1
alias update-tags="ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=yes --languages=c++ . && cscope -Rqbk"
alias grep="grep --color --exclude-dir=.svn --exclude-dir=.git"
alias ls="ls --color"
alias gimp="gimp -s"
alias diff="diff -d -u"
alias vim="vim -p -b"
alias less="less -E"
alias -s exe=wine
alias -s {bat,BAT}=dosbox
alias -s {htm,html}=firefox
alias -s {pdf,djvu}=evince
alias -s {doc,rtf}=abiword
alias -s {csv,xls}=gnumeric
alias -s dia=dia

