function hex-encode()
{
  echo "$@" | xxd -p
}

function hex-decode()
{
  echo "$@" | xxd -p -r
}

function rot13()
{
  echo "$@" | tr 'A-Za-z' 'N-ZA-Mn-za-m'
}




######################################################################################
# SPECIAL FUNCTIONS                                                                  #
######################################################################################
# Use the best editor installed.
edit() {
  if [ "$(type -t nvim)" = "file" ]; then nvim "$@"
  elif [ "$(type -t vim)" = "file" ]; then vim "$@"
  elif [ "$(type -t jpico)" = "file" ]; then jpico -nonotice -linums -nobackups "$@"
  elif [ "$(type -t pico)" = "file" ]; then pico "$@"
  else nano -c "$@"
  fi
}
sedit() {
  if [ "$(type -t nvim)" = "file" ]; then sudo nvim "$@"
  elif [ "$(type -t vim)" = "file" ]; then sudo vim "$@"
  elif [ "$(type -t jpico)" = "file" ]; then sudo jpico -nonotice -linums -nobackups "$@"
  elif [ "$(type -t pico)" = "file" ]; then sudo pico "$@"
  else sudo nano -c "$@"
  fi
}
# Extracts any archive(s) (if unp isn't installed).
extract() {
  for archive in $*; do
    if [ -f $archive ] ; then
      case $archive in
        *.tar.bz2) tar xvjf $archive ;;
        *.tar.gz) tar xvzf $archive ;;
        *.bz2) bunzip2 $archive ;;
        *.rar) rar x $archive ;;
        *.gz) gunzip $archive ;;
        *.tar) tar xvf $archive ;;
        *.tbz2) tar xvjf $archive ;;
        *.tgz) tar xvzf $archive ;;
        *.zip) unzip $archive ;;
        *.Z) uncompress $archive ;;
        *.7z) 7z x $archive ;;
        *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}
# Searches for text in all files in the current folder.
ftext() {
  # case-insensitive
  # -I ignore binary files
  # -H causes filename to be printed
  # -r recursive search
  # -n causes line number to be printed
  # optional: -F treat search term as a literal, not a regular expression
  # optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
  grep -iIHrn --color=always "$1" . | less -r
}
# Copy file with a progress bar.
cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 | awk '{
    count += $NF
    if (count % 10 == 0){
      percent = count / total_size * 100
      printf "%3d%% [", percent
      for (i=0;i<=percent;i++)
        printf "="
        printf ">"
        for (i=percent;i<100;i++)
          printf " "
          printf "]\r"
    }
  }
  END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}
# Copy and go to the directory.
cpg() {
  if [ -d "$2" ]; then cp $1 $2 && cd $2
  else cp $1 $2
  fi
}
# Move and go to the directory.
mvg() {
  if [ -d "$2" ]; then mv $1 $2 && cd $2
  else mv $1 $2
  fi
}
# Create and go to the directory.
mkdirg() {
  mkdir -p $1 && cd $1
}
# Goes up a specified number of directories  (i.e. up 4).
up() {
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++)); do d=$d/.. ; done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then d=.. ; fi
  cd $d
}
# Automatically do an ls after each cd
cdl() {
  if [ -n "$1" ]; then builtin cd "$@" && ls
  else builtin cd ~ && ls
  fi
}
# Returns the last 2 fields of the working directory.
pwdtail() {
  pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}
# Show the current distribution.
distribution() {
  local dtype
  # Assume unknown
  dtype="unknown"
  # First test against Fedora / RHEL / CentOS / generic Redhat derivative.
  if [ -r /etc/rc.d/init.d/functions ]; then
    source /etc/rc.d/init.d/functions
    [ zz`type -t passed 2>/dev/null` == "zzfunction" ] && dtype="redhat"
  # Then test against SUSE. (must be after Redhat, I've seen rc.status on Ubuntu I think? TODO: Recheck that)
  elif [ -r /etc/rc.status ]; then
    source /etc/rc.status
    [ zz`type -t rc_reset 2>/dev/null` == "zzfunction" ] && dtype="suse"
  # Then test against Debian, Ubuntu and friends.
  elif [ -r /lib/lsb/init-functions ]; then
    source /lib/lsb/init-functions
    [ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ] && dtype="debian"
  # Then test against Gentoo.
  elif [ -r /etc/init.d/functions.sh ]; then
    source /etc/init.d/functions.sh
    [ zz`type -t ebegin 2>/dev/null` == "zzfunction" ] && dtype="gentoo"
  # For Mandriva we currently just test if /etc/mandriva-release exists and isn't empty. (TODO: Find a better way :)
  elif [ -s /etc/mandriva-release ]; then
    dtype="mandriva"
  # For Slackware we currently just test if /etc/slackware-version exists.
  elif [ -s /etc/slackware-version ]; then
    dtype="slackware"
  # For Arch we currently just test if /etc/arch-release exists.
  elif [ -s /etc/arch-release ]; then
    dtype="arch"
  fi
  echo $dtype
}
# Show the current version of the operating system.
ver() {
  local dtype
  dtype=$(distribution)
  if [ $dtype == "redhat" ]; then
    if [ -s /etc/redhat-release ]; then cat /etc/redhat-release && uname -a
    else cat /etc/issue && uname -a
    fi
  elif [ $dtype == "suse" ]; then cat /etc/SuSE-release
  elif [ $dtype == "debian" ]; then lsb_release -a
  elif [ $dtype == "gentoo" ]; then cat /etc/gentoo-release
  elif [ $dtype == "mandriva" ]; then cat /etc/mandriva-release
  elif [ $dtype == "slackware" ]; then cat /etc/slackware-version
  elif [ $dtype == "arch" ]; then cat /etc/arch-release
  else
    if [ -s /etc/issue ]; then cat /etc/issue
    else echo "Error: Unknown distribution" ; exit 1
    fi
  fi
}
# Automatically install the needed support files for this .bashrc file.
install_bashrc_support() {
  local dtype
  dtype=$(distribution)
  if [ $dtype == "redhat" ]; then yum install multitail tree joe
  elif [ $dtype == "suse" ]; then zypper install multitail ; zypper install tree ; zypper install joe
  elif [ $dtype == "debian" ]; then apt-get install multitail tree joe
  elif [ $dtype == "gentoo" ]; then emerge multitail ; emerge tree ; emerge joe
  elif [ $dtype == "mandriva" ]; then urpmi multitail ; urpmi tree ; urpmi joe
  elif [ $dtype == "slackware" ]; then echo "No install support for Slackware"
  elif [ $dtype == "arch" ]; then yaourt multitail ; yaourt tree ; yaourt joe
  else echo "Unknown distribution"
  fi
}
# Show current network information.
netinfo() {
  printf 'IPv4: '
  /sbin/ifconfig | grep 'inet ' | grep -v '127.' | awk -F' ' '{print $2}' | xargs echo -n
  printf '\nIPv6: '
  /sbin/ifconfig | grep 'inet6' | grep -v 'fe80::' | grep -v '::1' | awk -F' ' '{print $2"  "}' | xargs echo -n
  printf '\n'
}
# IP address lookup.
alias whatismyip="whatsmyip"
function whatsmyip() {
  printf 'Internal:\n'
  netinfo
  printf 'External:\n'
  printf 'IPv4: '
  wget https://v4.ident.me/ -O - -q
  printf '\nIPv6: '
  wget https://v6.ident.me/ -O - -q
  printf '\n'
}
# View Apache logs
apachelog() {
  if [ -f /etc/httpd/conf/httpd.conf ]; then cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
  else cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
  fi
}
# Edit the Apache configuration
apacheconfig() {
  if [ -f /etc/httpd/conf/httpd.conf ]; then sedit /etc/httpd/conf/httpd.conf
  elif [ -f /etc/apache2/apache2.conf ]; then sedit /etc/apache2/apache2.conf
  else printf "Error: Apache config file could not be found.\nSearching for possible locations:\n" ; sudo updatedb && locate httpd.conf && locate apache2.conf
  fi
}
# Edit the PHP configuration file.
phpconfig() {
  if [ -f /etc/php/8.4/fpm/php.ini ]; then sedit /etc/php/8.3/fpm/php.ini
  elif [ -f /etc/php.ini ]; then sedit /etc/php.ini
  elif [ -f /etc/php/php.ini ]; then sedit /etc/php/php.ini
  elif [ -f /etc/php8.4/php.ini ]; then sedit /etc/php8.3/php.ini
  elif [ -f /usr/bin/php8.4/bin/php.ini ]; then sedit /usr/bin/php8.3/bin/php.ini
  elif [ -f /etc/php8.4/apache2/php.ini ]; then sedit /etc/php8.3/apache2/php.ini
  else printf "Error: php.ini file could not be found.\nSearching for possible locations:\n" ; sudo updatedb && locate php.ini
  fi
}
# Edit the MySQL configuration file.
mysqlconfig() {
  if [ -f /etc/my.cnf ]; then sedit /etc/my.cnf
  elif [ -f /etc/mysql/my.cnf ]; then sedit /etc/mysql/my.cnf
  elif [ -f /usr/local/etc/my.cnf ]; then sedit /usr/local/etc/my.cnf
  elif [ -f /usr/bin/mysql/my.cnf ]; then sedit /usr/bin/mysql/my.cnf
  elif [ -f ~/my.cnf ]; then sedit ~/my.cnf
  elif [ -f ~/.my.cnf ]; then sedit ~/.my.cnf
  else printf "Error: my.cnf file could not be found.\nSearching for possible locations:\n" ; sudo updatedb && locate my.cnf
  fi
}
# For some reason, rot13 pops up everywhere.
rot13() {
  if [ $# -eq 0 ]; then tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
  else echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
  fi
}
# Trim leading and trailing spaces (for scripts).
trim() {
  local var=$@
  var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
  echo -n "$var"
}

# Run `dig` and display the most useful info
digga() {
	dig +nocmd "$1" any +multiline +noall +answer
}

# Show all the names (CNs and SANs) listed in the SSL certificate for a given domain
getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified."
		return 1
	fi

	local domain="${1}"
	echo "Testing ${domain}…"
	echo "";

	local tmp
	tmp=$(echo -e "GET / HTTP/1.0\\nEOT" \
		| openssl s_client -connect "${domain}:443" 2>&1)

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText
		certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_header, no_serial, no_version, \
			no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
		echo "Common Name:"
		echo "";
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
		echo "";
		echo "Subject Alternative Name(s):"
		echo "";
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\\n" | tail -n +2
		return 0
	else
		echo "ERROR: Certificate not found."
		return 1
	fi
}

# `o` with no arguments opens the current directory, otherwise opens the given location
o() {
	if [ $# -eq 0 ]; then
		xdg-open .	> /dev/null 2>&1
	else
		xdg-open "$@" > /dev/null 2>&1
	fi
}


# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
	tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}

# Call from a local repo to open the repository on github/bitbucket in browser
# Modified version of https://github.com/zeke/ghwd
repo() {
	# Figure out github repo base URL
	local base_url
	base_url=$(git config --get remote.origin.url)
	base_url=${base_url%\.git} # remove .git from end of string

	# Fix git@github.com: URLs
	base_url=${base_url//git@github\.com:/https:\/\/github\.com\/}

	# Fix git://github.com URLS
	base_url=${base_url//git:\/\/github\.com/https:\/\/github\.com\/}

	# Fix git@bitbucket.org: URLs
	base_url=${base_url//git@bitbucket.org:/https:\/\/bitbucket\.org\/}

	# Fix git@gitlab.com: URLs
	base_url=${base_url//git@gitlab\.com:/https:\/\/gitlab\.com\/}

	# Validate that this folder is a git folder
	if ! git branch 2>/dev/null 1>&2 ; then
		echo "Not a git repo!"
		exit $?
	fi

	# Find current directory relative to .git parent
	full_path=$(pwd)
	git_base_path=$(cd "./$(git rev-parse --show-cdup)" || exit 1; pwd)
	relative_path=${full_path#$git_base_path} # remove leading git_base_path from working directory

	# If filename argument is present, append it
	if [ "$1" ]; then
		relative_path="$relative_path/$1"
	fi

	# Figure out current git branch
	# git_where=$(command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
	git_where=$(command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null

	# Remove cruft from branchname
	branch=${git_where#refs\/heads\/}
	branch=${branch#remotes\/origin\/}

	[[ $base_url == *bitbucket* ]] && tree="src" || tree="tree"
	url="$base_url/$tree/$branch$relative_path"


	echo "Calling $(type open) for $url"

	open "$url" &> /dev/null || (echo "Using $(type open) to open URL failed." && exit 1);
}

# Use feh to nicely view images
openimage() {
	local types='*.jpg *.JPG *.png *.PNG *.gif *.GIF *.jpeg *.JPEG'

	cd "$(dirname "$1")" || exit
	local file
	file=$(basename "$1")

	feh -q "$types" --auto-zoom \
		--sort filename --borderless \
		--scale-down --draw-filename \
		--image-bg black \
		--start-at "$file"
}

# check if uri is up
isup() {
	local uri=$1

	if curl -s --head  --request GET "$uri" | grep "200 OK" > /dev/null ; then
		notify-send --urgency=critical "$uri is down"
	else
		notify-send --urgency=low "$uri is up"
	fi
}
