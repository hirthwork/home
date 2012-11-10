# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
bind 'set match-hidden-files off'
alias man='LANG= man'
alias mplayer='mplayer -zoom -quiet -vo x11'
alias update-tags="ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=yes --languages=c++ . && cscope -Rqbk"
case $TERM in
    *screen*)
        PS1[1]='\033k$(pwd|grep -o "[^/]*/[^/]*$")\033\134\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \[\033[01;32m\]:) \[\033[00m\]'
        PS1[2]='\033k$(pwd|grep -o "[^/]*/[^/]*$")\033\134\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \[\033[01;31m\]:( \[\033[00m\]'
    ;;
    *)
        PS1[1]='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \[\033[01;32m\]:) \[\033[00m\]'
        PS1[2]='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \[\033[01;31m\]:( \[\033[00m\]'
    ;;
esac
export PROMPT_COMMAND='[ $? = 0 ] && PS1=${PS1[1]} || PS1=${PS1[2]}'
PS1='${PS[1]}'
export EDITOR=vim
export PAGER=vimpager
export MANPAGER=vimmanpager
export GTK_IM_MODULE=xim
