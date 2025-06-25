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
HISTSIZE=100000
HISTFILESIZE=200000
HISTFILE=~/.bash_history

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
    xterm-color|*-256color) color_prompt=yes;;
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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

# Run 'cc' with '-Wall -Wextra -Werror' 
alias cc='cc -Wall -Wextra -Werror'


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

. "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"

# Initialize fasd
eval "$(fasd --init auto)"

# Open file in nvim with a fasd shortcut
n() {
    local target_file
    target_file=$(fasd -f -- "$1")
    
    if [ -n "$target_file" ]; then
        nvim "$target_file"
    else
        echo "File matching '$1' not found."
    fi
}

# Custom completion function for 'n'
_n_completion() {
    local cur opts
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Use fasd to list file candidates that match the current word.
    # Here, we use '-f -l' to list file entries.
    # Depending on your fasd version, the output may be just a list of full paths.
    opts=$(fasd -f -l -- "$cur" 2>/dev/null)
    
    # If opts is not empty, set up completions.
    if [ -n "$opts" ]; then
        # You can choose to complete either the full paths or just the basename.
        # For example, to complete just the basenames:
        local cand
        local list=()
        while read -r cand; do
            # Extract basename from each candidate
            list+=( "$(basename "$cand")" )
        done <<< "$opts"
        COMPREPLY=( $(compgen -W "${list[*]}" -- "$cur") )
    else
        COMPREPLY=()
    fi
}

complete -F _n_completion n

# Define j as a function that jumps to a directory using fasd.
j() {
    if [ $# -eq 0 ]; then
        cd ~
        return
    fi
    local pattern="$*"
    local target
    target=$(fasd -d -- "$pattern")
    if [ -n "$target" ]; then
        cd "$target" || return
    else
        echo "No matching directory found for '$pattern'."
    fi
}

# Custom completion function for j.
_j_completion() {
    local cur opts cand list=() rel
    cur="${COMP_WORDS[COMP_CWORD]}"
    # Define the common base directory for your projects.
    local BASE="/home/blakcmirror/Documents/42/Piscine42"

    # Get the full list of directory entries from fasd and remove the ranking.
    opts=$(fasd -d 2>/dev/null | awk '{$1=""; sub(/^ /, ""); print}')
    # Filter the list using grep (case-insensitive) to match the current input.
    opts=$(echo "$opts" | grep -i "$cur")

    if [ -n "$opts" ]; then
        while IFS= read -r cand; do
            if [[ "$cur" == */* ]]; then
                # If the user has typed a slash, show the candidate as a relative path.
                if [[ "$cand" == $BASE/* ]]; then
                    # Remove the BASE prefix (with the trailing slash) from the candidate.
                    rel=${cand#$BASE/}
                    list+=( "$rel" )
                else
                    list+=( "$cand" )
                fi
            else
                # Otherwise, just offer the basename.
                list+=( "$(basename "$cand")" )
            fi
        done <<< "$opts"
        COMPREPLY=( $(compgen -W "${list[*]}" -- "$cur") )
    else
        COMPREPLY=()
    fi
}

complete -F _j_completion j

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/blakcmirror/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
alias mini='~/mini-moulinette/mini-moul.sh'
. "$HOME/.cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"
alias v="vim"
alias ccusage="npx ccusage"
