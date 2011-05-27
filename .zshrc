# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=100000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit promptinit
compinit
promptinit; prompt gentoo
# End of lines added by compinstall
autoload -Uz vcs_info
zstyle ':completion::complete:*' use-cache 1
setopt correctall
setopt extendedglob

local -a clr
local -A pc
local -A smile
#local _time _path _tail
clr[1]=${1:-'red'}
clr[2]=${2:-'cyan'}
clr[3]=${3:-'green'}
clr[4]=${4:-'blue'}
clr[5]=${5:-'white'}

pc['\[']="%F{$clr[1]}["
pc['\]']="%F{$clr[1]}]"
pc['<']="%F{$clr[1]}<"
pc['>']="%F{clr[1]}>"
pc['\(']="%F{clr[1]}("
pc['\)']="%F{clr[1]})"
pc['gs']="%F{clr[1]}-"

POSTEDIT="$reset_color"

_time=$pc['\[']%B%F{$clr[3]}%*$pc['\]']
_path=%B%F{$clr[4]}%~%(1/./.)
_tail="%F{$clr[2]}:\>%b%f"
_inputfmt=%F{$clr[5]}%b%f
_namehost=%F{$clr[3]}%n@%m
_smile=%(?.%F{$clr[3]}:\).%F{$clr[1]}:\()

preexec() {
if [[ "$TERM" == "screen.linux" || "$TERM" == "screen" ]]; then
    echo -ne "\ek"`pwd | grep -o "[^/]*/[^/]*$"`"\e\\"
fi
}
prompt="$_namehost $_path $_smile $_inputfmt"

RPS1="$_time %b%f"

prompt_opts=( cr percent )
precmd () { }

autoload zkbd
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
export PAGER=vimpager
export MANPAGER=vimmanpager
export LANG=ru_RU.UTF-8
export GTK_IM_MODULE=xim
alias update-tags="ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=yes --languages=c++ . && cscope -Rqbk"

