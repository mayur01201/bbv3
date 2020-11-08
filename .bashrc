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
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    prompt_color='\[\033[1;34m\]'
    path_color='\[\033[1;32m\]'
    if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
	prompt_color='\[\033[1;31m\]'
	path_color='\[\033[1;34m\]'
    fi
    PS1='${debian_chroot:+($debian_chroot)}'$prompt_color'\u@\h\[\033[00m\]:'$path_color'\w\[\033[00m\]\$ '
    unset prompt_color path_color
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

export PATH=$PATH:~/go/bin
function killvlc(){
ps aux | grep vlc | awk '{print $2}' | head -n 1 | xargs kill -9
}

certspotter(){
curl -s "https://api.certspotter.com/v1/issuances?domain=$1&include_subdomains=true&expand=dns_names&expand=issuer&expand=cert" | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
}

crtsh(){
  curl -s "https://crt.sh/?q=$1" | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$1" | sort -u | awk 'NF'
}

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

alias dirsearch="python3 ~/tools/dirsearch/dirsearch.py -e conf,config,bak,backup,swp,old,db,sql,asp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip,.log,.xml,.js.,.json"


#### Domain ####


alias massdns="~/tools/massdns/bin/massdns"

alias subls="python3 ~/tools/Sublist3r/sublist3r.py"



#### CORS ####

alias corsy="python3 ~/tools/corsy/corsy.py"

alias corscan="python3 ~/tools/corscanner/cors_scan.py"

alias cors="$GOPATH/bin/CORS-Scanner"



#### XSS ####

alias xsstrike="python3 ~/tools/XSStrike/xsstrike.py"


#### Cloud ####

alias s3scanner="python3 ~/tools/AWS/S3Scanner/s3scanner.py"

alias cloudflair="python3 ~/tools/AWS/CloudFlair/cloudflair.py"

alias cloudunflare="bash ~/tools/AWS/CloudUnflare/cloudunflare.bash"

alias gcpbrute="python3 ~/tools/GCPBucketBrute/gcpbucketbrute.py"



#### CMS ####

alias cmsmap="python3 ~/tools/CMS/CMSmap/cmsmap.py"

alias cmseek="python3 ~/tools/CMS/CMSeek/cmseek.py"

alias joomscan="perl ~/tools/CMS/Joomscan/joomscan.pl"


#### Frameworks ####

alias sudomy="bash ~/tools/Sudomy/sudomy"


#### Other Tools ####

alias photon="python3 ~/tools/Photon/photon.py"

alias hakrawler="~/tools/hakrawler/hakrawler"

alias paramspider="python3 ~/tools/ParamSpider/paramspider.py"

alias jexboss="python3 ~/tools/jexboss/jexboss.py"

alias goohak="sudo ~/tools/Goohak/goohak"

alias secretfinder="python3 ~/tools/SecretFinder/SecretFinder.py"

alias arjun="python3 ~/tools/Arjun/arjun.py"

alias ds_store_parser="python2 ~/tools/ds_store_exp/ds_store_exp.py"



