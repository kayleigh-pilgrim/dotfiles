# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac




######################################################################################
# EXPORTS                                                                            #
###################################################################################### 
iatest=$(expr index "$-" i)
export HISTFILESIZE=2000                                               # Expand the history size.
export HISTSIZE=2048                                                   # "
export HISTCONTROL=ignoreboth                                          # Don't put duplicate + ignore starting with a space.
shopt -s histappend                                                    # Append to history: start a new terminal, have old history.
PROMPT_COMMAND='history -a'                                            # "
stty -ixon                                                             # Allow ctrl-S for history navigation (with ctrl-R).
shopt -s checkwinsize                                                  # Check the window size after each command.
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi    # Ignore case on auto-completion.
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi     #  Show auto-completion list automatically, no double tab.
export EDITOR=nvim                                                     # Set the default editor.
export VISUAL=nvim                                                     # "
export CLICOLOR=1                                                      # To have colors for ls and all grep commands.
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
export GREP_OPTIONS='--color=auto'                                     # "
export LESS_TERMCAP_mb=$'\E[01;31m'                                    # Color for manpages in less: a little easier to read.
export LESS_TERMCAP_md=$'\E[01;31m'                                    # "
export LESS_TERMCAP_me=$'\E[0m'                                        # "
export LESS_TERMCAP_se=$'\E[0m'                                        # "
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 # "
export LESS_TERMCAP_ue=$'\E[0m'                                        # "
export LESS_TERMCAP_us=$'\E[01;32m'                                    # "
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01' # colored GCC warnings and errors
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"           # make less more friendly for non-text input files, see lesspipe(1)




######################################################################################
# PROMPT                                                                             #
###################################################################################### 
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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
    PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;37m\]\342\234\227\[\033[0;31m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h'; fi)\[\033[0;31m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]\[\e[01;33m\]\\$\[\e[0m\]"
else
    PS1='┌──[\u@\h]─[\w]\n└──╼ \$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;31m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h'; fi)\[\033[0;31m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]\[\e[01;33m\]\\$\[\e[0m\]"
    ;;
*)
    ;;
esac

# Set 'man' colors
if [ "$color_prompt" = yes ]; then
	man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
	}
fi




######################################################################################
# ALIASES & FUNCTIONS                                                                #
###################################################################################### 
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
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


#/home/bin
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
#zoxide
eval "$(zoxide init bash)"
#pipx
export PATH="$PATH:/home/kayleigh/.local/bin"
#composer
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
# Jetbrains Toolbox
export PATH="$PATH:/home/kayleigh/.local/share/JetBrains/Toolbox/scripts"
# cargo
#export PATH="$PATH:/home/kayleigh/.local/bin"
#. "/home/kayleigh/.local/share/cargo/env"
# opam
#test -r /home/kayleigh/.opam/opam-init/init.sh && . /home/kayleigh/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true


. ~/bin/dynmotd.sh


