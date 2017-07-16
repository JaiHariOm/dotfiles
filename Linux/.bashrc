#sh{{{ default 
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm|xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# local$PATH
if [ -d "$HOME/.local/bin" ] ; then
         PATH="$HOME/.local/bin:$PATH"
fi

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
        . /etc/bash.bashrc
fi

# Get the aliases and functions
#if [ -f ~/.bashrc ]; then
#     . ~/.bashrc
#fi

# Neovim rantimepass

# default Editor

#export EDITOR=nvim

#if [ -x /usr/bin/mint-fortune ]; then
#     /usr/bin/mint-fortune
#fi

# }}}

#cheat-sheet
#set CHEAT_EDITOR=vim

#Ctrl+lでclear-screenできなくなったので、新たに指定する
bind -m vi-insert "\C-l":clear-screen

# {{{  set prompt 
#[[ "$PS1" ]] && /usr/games/fortune | /usr/games/cowsay -n

if [ "$color_prompt" = yes ]; then
    if [[ ${EUID} == 0 ]] ; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \n\$\[\033[00m\] '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \n\$\[\033[00m\] '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \w\a\]$PS1"
    ;;
*)
    ;;
esac

# }}}

# {{{ aliases  

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# }}}

# {{{ completion 
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# }}}

# {{{ ranger-----------------

#function ranger() {
#        if [ -z "$RANGER_LEVEL" ]; then
#           /usr/local/bin/ranger $@
#        else
#        exit
#        fi
#      }
   rg() {
    if [ -z "$RANGER_LEVEL" ]
    then
        ranger
    else
        exit
    fi
  }
# }}}

# {{{ $PATHの削除---こまんど=path_remove (削除したいpath)
#$ path_remove pathname
path_append ()  { path_remove $1; export PATH="$PATH:$1"; }
path_prepend () { path_remove $1; export PATH="$1:$PATH"; }
path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }
# }}}

# {{{ .pass & gpg
alias passr="PASSWORD_STORE_DIR=~/.paass/password-store PASSWORD_STORE_GIT=~/.pass/password-store pass"

alias passred="PASSWORD_STORE_DIR=~/.pass/red PASSWORD_STORE_GIT=~/.pass/red pass"

export GPGKEY=0xEC124516


# gpg-agent=========================

#envfile="$HOME/.gnupg/gpg-agent.env"
#if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
#    eval "$(cat "$envfile")"
#else
#    eval "$(gpg-agent --daemon --allow-preset-passphrase "$envfile")"
#fi
#export GPG_AGENT_INFO="$HOME/.gnupg/S.gpg-agent"


#Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
      gpg-connect-agent /bye >/dev/null 2>&1
fi

# Set SSH to use gpg-agent 
#unset SSH_AGENT_PID 
#if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then 
#    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh" 
#fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null
# }}}

# {{{
#==================================================================///
#                             MISC  
#==================================================================///
# Notes for video:  http://www.youtube.com/watch?v=N8CZhlIssdk

# add this to your ~/.bashrc or ~/.zshrc and reload your shell

#------------------------------------------

# find alternative apps if it is installed on your system
find_alt() { for i;do which "$i" >/dev/null && { echo "$i"; return 0;};done;return 1; }

# Use the first program that it detects in the array as the default app
export PKMGR=$(find_alt yaourt pacman aptitude apt-get yum zypper emerge)

#-------- Gotbletu Universal Package Manager {{{
#------------------------------------------------------
# legends# {{{
# https://wiki.archlinux.org/index.php/Pacman_Rosetta
# http://old-en.opensuse.org/Software_Management_Command_Line_Comparison
# https://bbs.archlinux.org/viewtopic.php?pid=1281605#p1281605
# Arch			-- pacman, yaourt
# Debian/Ubuntu		-- apt-get(apt), aptitude, dpkg
# Gentoo		-- eclean, emerge, equery, layman
# OpenSuse		-- zypper
# Red Hat/Fedora	-- package-cleanup, rpm, yum
# Suse			-- rug
# Not finish, only tested on Debian, Arch, Fedora so far

# cleanold; removes certain packages that can no longer be downloaded
# cleanall; remove all local cached packages
# list; show the content of an installed package
# localinstall; install package manually such as deb, rpm files downloaded
# own; find a command a package belongs to; ex: pkm-own convert
# purge; uninstall package and purge configuration files (not in /home)
# query; search for an already installed package
# refresh; update repository list
# upgrade; install the newest version from the repositories
# hold/unhold; stop/allow a package from being update
# }}}
# missing
# emerge: autoclean, purge, list, query
# rug: pkm-info, clean, autoremove, autoclean, purge, list, query
# zypper: pkm-info, autoremove, autoclean, purge, list, query
# yum: autoclean, purge
# {{{ apt-get
if [ "$PKMGR" = "apt-get" ]; then
        pkm-cleanallall() { sudo apt-get clean ;}
        pkm-cleanallold() { sudo apt-get autoclean ;}
	pkm-dependsreverse() { apt-cache rdepends "$@" ;}
	pkm-download() { wget $(apt-get --print-uris -y install "$@" | grep ^\'| cut -d\' -f2) ;}
	pkm-extract() { ar vx "$@" | tar -zxvf data.tar.gz ;}
	# same as; echo "pkgname hold" | dpkg --set-selections
	pkm-hold() { sudo apt-mark hold "$@" ;}
	pkm-hold-status() { dpkg --get-selections | awk "/${@:-hold}/" ;}
        pkm-info() { apt-cache show "$@" ;}
        pkm-install() { sudo apt-get install --no-install-recommends "$@" ;}
	pkm-list() { dpkg -L "$@" ;}
	pkm-listcache() { ls -1 /var/cache/apt/archives "$@" && \
		echo "pwd: /var/cache/apt/archives" ;}
        pkm-localinstall() { sudo dpkg -i "$@" ;}
	pkm-own() { dpkg -S $(which "$@") ;}
        pkm-purge() { sudo apt-get purge "$@" ;}
	pkm-query() { dpkg --get-selections | grep "$@" ;}
	pkm-refresh() { sudo apt-get update ;}
	pkm-remove() { sudo apt-get remove "$@" ;}
        pkm-remove-orphans() { sudo apt-get autoclean ;}
	pkm-search() { apt-cache search "$@" ;}
	pkm-unhold() { sudo apt-mark unhold "$@" ;}
	pkm-upgrade() { sudo apt-get update && sudo apt-get upgrade ;}
	# PPA on ubuntu base distro (not compatible with debian)
	ppa-add() { sudo add-apt-repository $@ ;}
	ppa-del() { sudo add-apt-repository -r $@ ;}
	ppa-key() { sudo apt-key add $@ ;}
	ppa-list() { ls /etc/apt/sources.list.d ;}
	ppa-purge() { sudo ppa-purge $@ ;}
	# auto get missing gpg keys from launchpad
	ppa-autokey() { sudo apt-get update 2> /tmp/keymissing; \
		for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); \
		do echo -e "\nProcessing key: $key"; gpg --keyserver pool.sks-keyservers.net \
		--recv $key && gpg --export --armor $key | sudo apt-key add -; done ;}
		# these are extra servers, just replace it if one is down
		# keyserver.ubuntu.com
		# pool.sks-keyservers.net
		# subkeys.pgp.net
		# pgp.mit.edu
		# keys.nayr.net
		# keys.gnupg.net
		# wwwkeys.en.pgp.net #(replace with your country code fr, en, de,etc)
	# }}}
# {{{ aptitude
elif [ "$PKMGR" = "aptitude" ]; then
        pkm-cleanallall() { sudo aptitude clean ;}
        pkm-cleanallold() { sudo aptitude autoclean ;}
	pkm-dependsreverse() { aptitude why "$@" ;}
	pkm-download() { aptitude download "$@" ;} # need a better 1; deb w/ depends
	pkm-extract() { ar vx "$@" | tar -zxvf data.tar.gz ;}
	pkm-hold() { echo "$1 hold" | sudo dpkg --set-selections && \
		dpkg --get-selections | awk "/$1/ && /hold/" ;}
	pkm-hold-status() { dpkg --get-selections | awk "/${@:-hold}/" ;}
        pkm-info() { aptitude show "$@" ;}
        pkm-install() { sudo aptitude install --without-recommends "$@" ;}
	pkm-list() { dpkg -L "$@" ;}
	pkm-listcache() { ls -1 /var/cache/apt/archives "$@" && \
		echo "pwd: /var/cache/apt/archives" ;}
        pkm-localinstall() { sudo dpkg -i "$@" ;}
	pkm-own() { dpkg -S $(which "$@") ;}
        pkm-purge() { sudo aptitude purge "$@" ;}
	pkm-query() { dpkg --get-selections | grep "$@" ;}
	pkm-refresh() { sudo aptitude update ;}
        pkm-remove() { sudo aptitude remove "$@" ;}
        pkm-remove-orphans() { sudo aptitude autoclean ;}
	pkm-search() { aptitude search "$*" ;}
		# fix  maybe with keyword $@ | sed / / ~d/ 
	pkm-search-description() { aptitude search ~d"$1"~d"$2"~d"$3"~d"$4"~d"$5"~d"$6"~d"$7" ;} 
	pkm-unhold() { echo "$1 install" | sudo dpkg --set-selections && \
		dpkg --get-selections | awk "/$1/ && /install/" ;}
	pkm-upgrade() { sudo aptitude update && sudo aptitude upgrade ;}
	# PPA on ubuntu base distro (not compatible with debian)
	ppa-add() { sudo add-apt-repository $@ ;}
	ppa-del() { sudo add-apt-repository -r $@ ;}
	ppa-key() { sudo apt-key add $@ ;}
	ppa-list() { ls /etc/apt/sources.list.d ;}
	ppa-purge() { sudo ppa-purge $@ ;}
	ppa-autokey() { sudo apt-get update 2> /tmp/keymissing; \
		for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); \
		do echo -e "\nProcessing key: $key"; gpg --keyserver pool.sks-keyservers.net \
		--recv $key && gpg --export --armor $key | sudo apt-key add -; done ;}
# }}}
# {{{ emerge
elif [ "$PKMGR" = "emerge" ]; then
        pkm-remove-orphans() { sudo emerge --depclean ;}
        pkm-cleanall() { sudo eclean distfiles ;}
        pkm-info() { emerge -S "$@" ;}
        pkm-install() { sudo emerge "$@" ;}
	pkm-refresh() { sudo layman -f ;}
        pkm-remove() { sudo emerge -C "$@" ;}
        pkm-search() { emerge -S "$@" ;}
        pkm-upgrade() { sudo emerge -u world ;}
# }}}
# {{{ pacman
elif [ "$PKMGR" = "pacman" ]; then
	pkm-build() { tar xvzf "$1" && cd "${1%%.tar.gz}" && makepkg -csi ;}
        pkm-cleanall() { sudo pacman -Sc ;}
        pkm-cleanold() { sudo pacman -Scc ;}
	if type -p downgrade > /dev/null; then
	# require: https://aur.archlinux.org/packages/downgrade/
		pkm-downgrade() { downgrade "$@" ;}
	fi
	pkm-download() { sudo pacman -Sw "$@" ;}
	pkm-info() { for arg in "$@"; do
		pacman -Qi $arg 2> /dev/null \
		|| pacman -Si $arg; done ;}
        pkm-install() { sudo pacman -S "$@" ;}
	pkm-key() { sudo pacman-key --init \
		&& sudo pacman-key --populate archlinux \
		&& sudo pacman-key --refresh-keys ;}
	pkm-list() { pacman -Qql "$@" ;}
	pkm-listcache() { ls -1 /var/cache/pacman/pkg "$@" && \
		echo "pwd: /var/cache/pacman/pkg" ;}
	pkm-localinstall() { sudo pacman --noconfirm -U "$@" ;}
	pkm-own() { pacman -Qo "$@" ;}
        pkm-purge() { sudo pacman -R "$@" ;}
        pkm-query() { pacman -Qqs "$@" ;}
        pkm-query-detail() { pacman -Qs "$@" ;}
	pkm-refresh() { sudo pacman -Syy ;}
        pkm-remove() { sudo pacman -Rcs "$@" ;}
	pkm-remove-nodepends() { sudo pacman -Rdd "$@" ;}
	pkm-remove-orphans() { sudo pacman -Rs $(pacman -Qqtd) ;}
	pkm-search() { pacman -Ss "$@" ;}
        pkm-upgrade() { sudo pacman -Syu ;}
# }}}
# {{{ rug
elif [ "$PKMGR" = "rug" ]; then
	pkm-install() { sudo rug install "$@" ;}
	pkm-refresh() { sudo rug refresh ;}
        pkm-remove() { sudo rug remove "$@" ;}
	pkm-search() { rug search "$@" ;}
	pkm-upgrade() { sudo rug update ;}
# }}}
# {{{ yaourt
elif [ "$PKMGR" = "yaourt" ]; then
	pkm-build() { tar xvzf "$1" && cd "${1%%.tar.gz}" && makepkg -csi ;}
	pkm-cleanall() { yaourt -Sc ;}
	pkm-cleanold() { yaourt -Scc ;}
	if type -p downgrade > /dev/null; then
	# require: https://aur.archlinux.org/packages/downgrade/
		pkm-downgrade() { downgrade "$@" ;}
	fi
	pkm-download() { sudo pacman -Sw "$@" ;} # need better shit to dl from aur also
	pkm-info() { for arg in "$@"; do
		yaourt -Qi $arg 2> /dev/null \
		|| yaourt -Si $arg; done ;}
	pkm-install() { yaourt --noconfirm -S "$@" ;} 
#https://wiki.archlinux.org/index.php/Pacman-key#Resetting_all_the_keys
	pkm-key() { sudo pacman-key --init \
		&& sudo pacman-key --populate archlinux \
		&& sudo pacman-key --refresh-keys ;}
	pkm-list() { yaourt -Qql "$@" ;}
	pkm-listcache() { ls -1 /var/cache/pacman/pkg "$@" && \
		echo "pwd: /var/cache/pacman/pkg" ;}
	pkm-localinstall() { sudo pacman --noconfirm -U "$@" ;}
	pkm-own() { pacman -Qo "$@" ;}
	pkm-purge() { yaourt -R "$@" ;}
	pkm-query() { pacman -Qqs "$@" ;}
	pkm-query-detail() { yaourt -Qs "$@" ;}
	pkm-refresh() { yaourt -Syy ;}
	pkm-remove() { yaourt -Rcs "$@" ;}
	pkm-remove-nodepends() { yaourt -Rdd "$@" ;}
	pkm-remove-orphans() { yaourt -Rs $(pacman -Qqtd) ;}
	pkm-search() { yaourt --noconfirm "$@" ;}
	pkm-upgrade() { yaourt --noconfirm -Syu ;}	# upgrade everything except aur package
	pkm-upgrade-aur() { yaourt --noconfirm -Sbua ;} # only upgrade aur package
# }}}
# {{{ yum
elif [ "$PKMGR" = "yum" ]; then
	pkm-cleanall() { sudo yum clean ;}
	pkm-depends() { sudo yum deplist "$@" ;}
	pkm-dependsreverse() { sudo yum resolvedep "$@" ;}
	pkm-info() { for arg in "$@"; do
		rpm -qi $arg 2> /dev/null || yum info $arg; done ;}
	pkm-install() { sudo yum install "$@" ;}
	pkm-list() { for arg in "$@"; do
		rpm -ql $arg 2> /dev/null || repoquery -ql --plugins $arg; done ;}
	pkm-localinstall() { sudo yum localinstall "$@" ;}
	pkm-own() { rpm -qf $(which "$@") ;}
	pkm-query() { rpm -q "$@" ;}
	pkm-refresh() { sudo yum clean expire-cache && sudo yum check-update ;}
	pkm-remove() { sudo yum remove "$@" ;}
	pkm-remove-orphans() { sudo package-cleanup --leaves ;}
	pkm-search() { yum search "$@" ;}
	pkm-upgrade() { sudo yum update ;}
# }}}
# {{{ zypper
elif [ "$PKMGR" = "zypper" ]; then
	pkm-cleanall() { sudo zypper clean ;}
	pkm-install() { sudo zypper install "$@" ;}
	pkm-refresh() { sudo zypper refresh ;}
	pkm-remove() { sudo zypper remove "$@" ;}
	pkm-search() { zypper search "$@" ;}
	pkm-upgrade() { sudo zypper update ;}
fi
# }}}
#}}} =====================================================================

export NVM_DIR="/home/user/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


#exec fish
export XDG_CONFIG_HOME=~/.config

#cheat-sheet
export CHEAT_EDITOR=nvim

#zfz
fh() {
	eval $(history | fzf +s | sed 's/ *[0-9]* *//')
}

bind '"\C-F":"fh\n"' # fzf history

set rtp+=~/.fzf

# cdを入力しなくてもいい
shopt -s autocd

#=======================================================///
#                     FASD                              
#=======================================================///

eval "$(fasd --init auto)"

alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

alias v='f -e vim' # quick opening files with vim
alias m='f -e mplayer' # quick opening files with mplayer
alias o='a -e xdg-open' # quick opening files with xdg-open


fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
	  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache


#}}}
