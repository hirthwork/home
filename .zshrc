# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=${HISTSIZE}
bindkey -e

if ! pgrep -u $USER -x ssh-agent>/dev/null
then
    ssh-agent>/tmp/sshinit$USER && . /tmp/sshinit$USER>/dev/null && rm /tmp/sshinit$USER
fi
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extendedglob

autoload -Uz compinit zkbd colors
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
        name=`echo $1|sed 's/^sudo[ ]*//'`
        if ! echo "$name"|grep -qE "^(emerge|wine|layman|tail|sleep|qfile|list|screen|mutt|mcabber|man|less|vimpager)"
        then
            get_short_pwd
            name=`echo $name|sed 's/ .*//'`\ @\ $short_pwd
        elif echo "$name"|grep -q "^mutt"
        then
            name=mail\ @\ `echo $name|sed 's/^[^/]*[/]//;s/[/].*//'`
        elif echo "$name"|grep -q "^mcabber"
        then
            name=xmpp\ @\ `echo $name|sed 's/^[^/]*[/]//;s/[/].*//'`
        fi
        echo -ne "\ek"$name"\e\\"
    fi
}

precmd() {
    chpwd
}

prompt="%F{green}%n@%m %B%F{cyan}%~ %(?.%F{green}:).%F{red}:()%f%b "

prompt_opts=( cr percent )

[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]] && zkbd
source ${ZDOTDIR:-$HOME}/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
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
export BROWSER=elinks
export PAGER=vimpager
export MANPAGER=vimmanpager
export LANG=ru_RU.UTF-8
export GTK_IM_MODULE=xim
alias update-tags="ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=yes --languages=c++ . && cscope -Rqbk"
alias grep="grep --color"
alias ls="ls --color"
alias man="LANG= man"
alias gimp="gimp -s"
alias -s exe=wine
alias -s {htm,html}=firefox
alias -s {pdf,djvu}=evince
alias -s {doc,rtf}=abiword
alias -s {csv,xls}=gnumeric
alias -s dia=dia

