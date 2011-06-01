# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=100000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

autoload -Uz compinit promptinit vcs_info
compinit
promptinit
# End of lines added by compinstall
zstyle ':completion::complete:*' use-cache 1
setopt correctall
setopt extendedglob

preexec() {
if [[ "$TERM" == "screen.linux" || "$TERM" == "screen" ]]; then
    echo -ne "\ek"`pwd | grep -o "[^/]*/[^/]*$"`"\e\\"
fi
}
prompt="%F{cyan}%n@%m %F{blue}%~ %(?.%F{green}:).%F{red}:()%f "

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
alias ls="ls --color"
alias grep="grep --color"
alias man="LANG= man"

