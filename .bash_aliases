######################################################################################
# GENERAL ALIASES                                                                    #
######################################################################################
# Color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert.
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit.bashrc file.
alias ebrc='edit ~/.bashrc'

# Show help for this .bashrc file.
#alias hlp='less ~/.bashrc_help'

# Alias to show the date.
alias da='date "+%Y-%m-%d %A %T %Z"'

# Alias's to modified commands.
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -iv'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias multitail='multitail --no-repeat -c'
alias vi='nvim'
alias vis='nvim "+set si"'

# Change directory aliases.
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Cd into the old directory.
alias bd='cd "$OLDPWD"'

# Remove a directory and all files.
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's for multiple directory listing commands.
alias l='ls -CF'
alias la='ls -lha'                    # show hidden files
alias ls='ls -aFh --color=always'     # add colors and file type extensions
alias lx='ls -lXBh'                   # sort by extension
alias lk='ls -lSrh'                   # sort by size
alias lc='ls -lcrh'                   # sort by change time
alias lu='ls -lurh'                   # sort by access time
alias lr='ls -lRh'                    # recursive ls
alias lt='ls -ltrh'                   # sort by date
alias lm='ls -alh |more'              # pipe through 'more'
alias lw='ls -xAh'                    # wide listing format
alias ll='ls -Flsh'                   # long listing format
alias labc='ls -lap'                  # alphabetical sort
alias lf="ls -l | egrep -v '^d'"      # files only
alias ldir="ls -l | egrep '^d'"       # directories only

# Sudo
alias _='sudo'
alias _i='sudo -i'
alias fucking='sudo'
alias please='sudo'

# Alias chmod commands.
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history.
alias h="history | grep "

# Search running processes.
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder.
alias f="find . | grep "

# Count all files (recursively) in the current folder.
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command.
alias checkcommand="type -t"

# Show current network connections to the webserver.
alias 80view="netstat -anpl | grep :80 | awk {'print $5'} | cut -d":" -f1 | sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"
alias 443view="netstat -anpl | grep :443 | awk {'print $5'} | cut -d":" -f1 | sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'"

# Show open ports.
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots.
alias rebootsafe='shutdown -r now'
alias rebootforce='shutdown -r -n now'

# Alias's to show disk space and space used in a folder.
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives.
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log.
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'




######################################################################################
# SPECIFIC ALIASES                                                                   #
######################################################################################
# Alias's to change the directory.
if [ -d "/home/www" ]; then alias web='cd /home/www/' # directadmin
elif [ -d "/home/kayleigh/Code" ]; then alias web='cd /home/kayleigh/Code' # local development
else alias web='cd /var/www/'
fi

# Commands I forget about.
alias logsort='du -a /var/log | sort -n -r | head -n 10'

# Typos.
alias hotp='htop'
alias sl='ls'
alias vom='nvim'
alias nvom='nvim'
alias ipconfig='ifconfig'

# Shortcuts
alias fw='iptables -nL'
alias fwv='iptables -nvL'

# Easier copypasta for root
if [ "$EUID" == 0 ]; then
  alias sudo=''
fi

# Sar
alias sarmem='sar -r'
alias sarcpu='sar -p'

# VIM-like commands
alias :e=edit
alias :q=exit

# GIT
alias glp="git log --patch"

# SSH TO ABS SERVERS
alias w1='ssh w1'
alias m1='ssh m1'

####################
# Firewall related #
#################### -%>
# Saving and restoring IPtables.  Restoring can be done automaticly with the iptables-persistent package.
alias saveiptables='iptables-save > /etc/iptables/rules.v4 && ip6tables-save > /etc/iptables/rules.v6'
alias restoreiptables='iptables-restore < /etc/iptables/rules.v4 && ip6tables-restore < /etc/iptables/rules.v6'

# Monitoring fail2ban.  http://www.the-art-of-web.com/system/fail2ban-log/
# Sort fail2ban blocks per IP in all logfiles.
alias sortf2b="zgrep -h \"Ban \" /var/log/fail2ban.log* | awk '{print \$NF}' | sort | uniq -c"
# Sort on most problematic /24 subnets.
alias f2bsubnets="zgrep -h \"Ban \" /var/log/fail2ban.log* | awk '{print \$NF}' | awk -F\\. '{print \$1\".\"\$2\".\"\$3}' | sort | uniq -c | sort -n | tail"
