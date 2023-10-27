#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0
	# foreground colors
    echo "Special: "
    for spec in $(seq 7); do
        echo -ne "\e[${spec}mspec:$spec\e[0m "
    done
    echo -e "\e[0m\n"

    echo "Foreground: "
    for fg in $(seq 30 37); do
        echo -ne "\e[${fg}mfg:$fg\e[0m "
    done
    echo -e "\e[0m\n"

    echo "Dark foreground (Special ;2): "
    for fg in $(seq 30 37); do
        echo -ne "\e[${fg};2mfg:$fg\e[0m "
    done
    echo -e "\e[0m\n"

    echo "Light foreground: "
    for fg in $(seq 90 97); do
        echo -ne "\e[${fg}mfg:$fg\e[0m "
    done
    echo -e "\e[0m\n"

    echo "Bold foreground: "
    for fg in $(seq 30 37); do
        echo -ne "\e[${fg};1mfg:$fg\e[0m "
    done
    echo -e "\e[0m\n"

    echo "Bold dark foreground: "
    for fg in $(seq 30 37); do
        echo -ne "\e[${fg};1;2mfg:$fg\e[0m "
    done
    echo -e "\e[0m\n"

    echo "Background: "
    for bg in $(seq 40 47); do
        echo -ne "\e[${bg}mbg:$bg\e[0m "
    done
    echo -e "\e[0m\n"

    echo -e "\e[0m"
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
        PROMPT_COMMAND='echo -ne "\033]0;$(basename "${PWD/#$HOME/\~}")\007"'
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
        PS1='\[\033[0m\]~ $(t="$(echo -ne $?)" ;printf "%s%3d" "$(if [ $t != 0 ]; then echo -ne "\[\033[01;31m\]"; else echo -ne "\[\033[01;32m\]"; fi)" "$t") \[\033[01;32m\][\u@\h\[\033[01;37m\] \W$(if t=$(git branch --show-current 2>/dev/null); then echo " \[\033[2;91m\]\[\033[1;31m\]$t$(if [ ! -z "$(git diff)" ]; then echo " \[\033[33m\]"$(git diff --stat | tail -n 1| sed "s/[a-z ()]//g;s/[0-9][0-9]*,//g;s/\([0-9]*\)\([+-]\)/\2\1/g"); fi;)"; fi)\[\033[01;32m\]]\$\[\033[00;1;3m\] '
        PS0='\033[0m'
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
                -DDLLVM_PARALLEL_LINK_JOBS=8 \
                -DCMAKE_BUILD_TYPE=Debug \
                -DBUILD_SHARED_LIBS=ON \
                $@
            ;;
        sync_time)
            timedatectl set-ntp true
            ;;
        defnet)
            sudo virsh net-start default
            ;;
        kbrate)
            setxkbmap gb -option compose:ralt
            xset r rate 399 50
            ;;
        init-mk)
            cat > Makefile <<EOF
CC = cc

SRC = main.o

all: \$(SRC)
	\$(CC) -pedantic -Wall -Werror -Wextra \$(SRC) -g -fsanitize=address -o main

%.o: %.c
	\$(CC) -std=c99 -pedantic -Werror -Wall -Wextra -Wvla $< -c -g -fsanitize=address

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

complete -W "cmake-llvm kbrate init-mk test-command defnet sync_time" quick_script

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
source /usr/share/bash-completion/completions/make
source /usr/share/bash-completion/completions/nbfc
source /usr/share/bash-completion/completions/nbfc_service
source $HOME/.nix-profile/etc/profile.d/nix.sh
export EDITOR=nvim
export PATH="/home/remi/bin/idea-IU-223.8214.52/bin:$PATH"
export PATH="/usr/lib/jvm/java-17-openjdk/bin:$PATH"
alias cdr='if gitpath=`git rev-parse --show-toplevel`; then cd $gitpath; fi'

alias vim=nvim

eval "$(ssh-agent -s)" >/dev/null
trap "ssh-agent -k" EXIT

alias tcdocker='docker run --rm -it -v $PWD:/tc --workdir /tc registry.lrde.epita.fr/tc-sid'
alias nsight='computeprof'

alias clear='echo -ne "\e[H\e[2J\e[3J";:'
