# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=${HISTSIZE}
setopt INC_APPEND_HISTORY

bindkey -e

if which skotty >/dev/null
then
    eval $(skotty ssh env)
fi
if ssh-add -L 2>&1 | grep -Fq "Could not open a connection to your authentication agent."
then
    eval $(ssh-agent)
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
export PSSH_AUTH_SOCK=/tmp/pssh-agent.sock
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extendedglob

autoload -Uz compinit colors tetris
if [ "x$SKIP_ZKBD" = "x" ]
then
    autoload -Uz zkbd
fi
zle -N tetris
compinit
colors

short_pwd() {
    pwd|sed "s,$HOME,~,"|grep -o "\(^~\?/[^/]\+/[^/]\+\|[^/]*\(/[^/]*\)\?\)$"
}

preexec() {
    if [[ ! -o interactive ]]
    then
        return
    fi

    if [[ "$TERM" == "screen.linux" || "$TERM" == "screen" || "$TERM" == "screen.xterm-256color" ]]
    then
        sed 's/[[:space:]]\+/\t/g;s/[^\t]\+="[^"]*"\t//g;s/[^\t]\+=[^\t]*[\t]//g;s/[\t][-][^\t]*//g' <<< $1 | read first second third
        if [ $first \=\= sudo ]
        then
            first=$second
            second=$third
        fi

        case $first in
            mutt)
                name=mail@$(cut -d/ -f 2 <<< $second)
                ;;
            mcabber)
                name=xmpp@$(cut -d/ -f 2 <<< $second)
                ;;
            ./.irssi/start)
                name=irc
                ;;
            ssh)
                name=ssh@$(sed 's/.*@//;s/[.].*//' <<< $second)
                ;;
            ./.mutt/imapsync)
                name=imapsync
                ;;
            *)
                name=$(sed 's#.*/\(.\+\)$#\1#;s#^\(..........\).*#\1~#' <<< $first)@$(short_pwd)
                ;;
        esac
        echo -ne "\ek"$name"\e\\"
    fi
}

precmd() {
    if [[ ! -o interactive ]]
    then
        return
    fi

    if [[ "$TERM" == "screen.linux" || "$TERM" == "screen" || "$TERM" == "screen.xterm-256color" ]]
    then
        echo -ne "\ek"$(short_pwd)"\e\\"
    fi
}

prompt='%B%F{green}%n%b%F{yellow}@%B%F{red}%m%b %F{cyan}%~%F{red}%v %(?.%F{green}$.%F{red}%?)%f '
RPROMPT='%b%F{yellow}[%b%F{gray}%D{%T}%b%F{yellow}]'

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

export GDBHISTFILE=~/.gdb_history
export EDITOR=vim
export PAGER=less
export MANPAGER=less
if [ -z $GIT_SSH ] && ! which ssh >/dev/null 2>&1
then
    if which dbclient >/dev/null 2>&1
    then
        export GIT_SSH=dbclient
    fi
fi

alias grep="grep --color --exclude-dir=.svn --exclude-dir=.git"
alias fgrep="grep -F --color --exclude-dir=.svn --exclude-dir=.git"
alias ls="ls --color"
alias gimp="gimp -s"
alias diff="diff -d -u"
alias vim="vim -p -b"
alias less="less -E -n"
alias mpv="mpv --fs --osd-fractions"
alias cp="cp -i"
alias mv="mv -i"
alias pssh="$HOME/bin/pssh"

unset LESSOPEN

if which direnv >/dev/null 2>&1
then
    eval "$(direnv hook zsh)"
fi

if test -d "$HOME/.zshenv.d/"
then
    typeset -a zshenv_files
    find "$HOME/.zshenv.d/" -type f | while read f
    do
        zshenv_files+=$f
    done
    for f in $zshenv_files[@]
    do
        source $f
    done
fi

# The next line include pssh aliases.
if [ -f "$HOME/.pssh_aliases" ]; then source "$HOME/.pssh_aliases"; fi

# The next line updates PATH for mdb cli tools.
if [ -f "$HOME/mdb-scripts/path.zsh.inc" ]; then source "$HOME/mdb-scripts/path.zsh.inc"; fi

# The next line enables shell command completion for mdb cli tools.
if [ -f "$HOME/mdb-scripts/completion.zsh.inc" ]; then source "$HOME/mdb-scripts/completion.zsh.inc"; fi

# The next line updates PATH for Yandex Cloud CLI.
if [ -f "$HOME/yandex-cloud/path.bash.inc" ]; then source "$HOME/yandex-cloud/path.bash.inc"; fi

# The next line enables shell command completion for yc.
if [ -f "$HOME/yandex-cloud/completion.zsh.inc" ]; then source "$HOME/yandex-cloud/completion.zsh.inc"; fi

# The next line updates PATH for Yandex Cloud Private CLI.
if [ -f "$HOME/ycp/path.bash.inc" ]; then source "$HOME/ycp/path.bash.inc"; fi
