#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
        PS1='~ $(t="$(echo -ne $?)" ;printf "%s%3d" "$(if [ $t != 0 ]; then echo -ne "\[\033[01;31m\]"; else echo -ne "\[\033[01;32m\]"; fi)" "$t") \[\033[01;32m\][\u@\h\[\033[01;37m\] \W$(if t=$(git branch --show-current 2>/dev/null); then echo " \[\033[2;91m\]\[\033[1;31m\]$t$(if [ ! -z "$(git diff)" ]; then echo " \[\033[33m\]"$(git diff --stat | tail -n 1| sed "s/[a-z ()]//g;s/[0-9][0-9]*,//g;s/\([0-9]*\)\([+-]\)/\2\1/g"); fi;)"; fi)\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

#alias cp="cp -i"                          # confirm before overwriting something
#alias df='df -h'                          # human-readable sizes
#alias free='free -m'                      # show sizes in MB
#alias np='nano -w PKGBUILD'
#alias more=less

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
    for file in $1; do
        if [ -f "$file" ] ; then
            case $file in
                *.tar.bz2)   tar xjf $file   ;;
                *.tar.gz)    tar xzf $file   ;;
                *.bz2)       bunzip2 $file   ;;
                *.rar)       unrar x $file     ;;
                *.gz)        gunzip $file    ;;
                *.tar)       tar xf $file    ;;
                *.tbz2)      tar xjf $file   ;;
                *.tgz)       tar xzf $file   ;;
                *.zip)       unzip $file     ;;
                *.Z)         uncompress $file;;
                *.7z)        7z x $file      ;;
                *)           echo "'$file' cannot be extracted via ex()" ;;
            esac
        else
            echo "'$file' is not a valid file"
        fi
    done
}

quick_script () {
    command="$1"
    shift
    case "$command" in
        cmake-llvm)
            cmake \
                -DLLVM_CCACHE_BUILD=ON \
                -DDLLVM_PARALLEL_LINK_JOBS=1 \
                -DCMAKE_BUILD_TYPE=Debug \
                -DBUILD_SHARED_LIBS=ON \
                $@
            ;;
        init-mk)
            cat > Makefile <<EOF
CC = g++

SRC = main.o

all: \$(SRC)
	\$(CC) -Wall -Werror -Wextra \$(SRC) -g -fsanitize=address -o main

%.o: %.cc
	\$(CC) -Wall -Werror -Wextra $< -c -g -fsanitize=address

clean:
	\$(RM) *.o
	\$(RM) main
EOF
            ;;
        test-command)
            echo -e -n $@
            ;;
    esac
}

complete -W "cmake-llvm init-mk test-command" quick_script

backup () {
    if [ $# != 1 ]; then
        echo "Usage: backup <file>"
    elif [ -f $1 ]; then
        cp $1 $1.bk
    else
        echo "'$1' is not a valid file"
    fi
}

source /usr/share/bash-completion/completions/git
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
source $HOME/.nix-profile/etc/profile.d/nix.sh
export PATH="/home/remi/bin/idea-IU-223.8214.52/bin:$PATH"
export PATH="/usr/lib/jvm/java-17-openjdk/bin/java:$PATH"
alias cdr='if gitpath=`git rev-parse --show-toplevel`; then cd $gitpath; fi'

alias vim=nvim
