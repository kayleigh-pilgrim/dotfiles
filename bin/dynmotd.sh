#!/bin/bash

# ABS BashRC  -  Kayleigh Pilgrim <k@abs.gd>  -  V.0.0.1  -  2024/11/12
clear
printf "\n${Yellow}LOGGING IN${Color_off}\n"




######################################################################################
# COLORS                                                                             #
######################################################################################
# Reset
Color_Off='\e[0m'
# Regular Colors
Black='\e[0;30m';Red='\e[0;31m';Green='\e[0;32m';Yellow='\e[0;33m';Blue='\e[0;34m';Purple='\e[0;35m';Cyan='\e[0;36m';White='\e[0;37m'
# Bold
BBlack='\e[1;30m';BRed='\e[1;31m';BGreen='\e[1;32m';BYellow='\e[1;33m';BBlue='\e[1;34m';BPurple='\e[1;35m';BCyan='\e[1;36m';BWhite='\e[1;37m'
# Underline
UBlack='\e[4;30m';URed='\e[4;31m';UGreen='\e[4;32m';UYellow='\e[4;33m';UBlue='\e[4;34m';UPurple='\e[4;35m';UCyan='\e[4;36m';UWhite='\e[4;37m'
# Background
On_Black='\e[40m';On_Red='\e[41m';On_Green='\e[42m';On_Yellow='\e[43m';On_Blue='\e[44m';On_Purple='\e[45m';On_Cyan='\e[46m';On_White='\e[47m'
# High Intensity
IBlack='\e[0;90m';IRed='\e[0;91m';IGreen='\e[0;92m';IYellow='\e[0;93m';IBlue='\e[0;94m';IPurple='\e[0;95m';ICyan='\e[0;96m';IWhite='\e[0;97m'
# Bold H-Intensity
BIBlack='\e[1;90m';BIRed='\e[1;91m';BIGreen='\e[1;92m';BIYellow='\e[1;93m';BIBlue='\e[1;94m';BIPurple='\e[1;95m';BICyan='\e[1;96m';BIWhite='\e[1;97m'
# High Intensity backgrounds
On_IBlack='\e[0;100m';On_IRed='\e[0;101m';On_IGreen='\e[0;102m';On_IYellow='\e[0;103m';On_IBlue='\e[0;104m';On_IPurple='\e[0;105m';On_ICyan='\e[0;106m';On_IWhite='\e[0;107m'




######################################################################################
# VARIABLES                                                                          #
######################################################################################
# HOSTNAME
HOSTNAME=`hostname -f | xargs echo -n`

# OS
OS="unknown"
# REDHAT
if [ -r /etc/rc.d/init.d/functions ]; then
  source /etc/rc.d/init.d/functions
  [ zz`type -t passed 2>/dev/null` == "zzfunction" ] && OS="Redhat"
# SUSE
elif [ -r /etc/rc.status ]; then
  source /etc/rc.status
  [ zz`type -t rc_reset 2>/dev/null` == "zzfunction" ] && OS="Suse"
# DEBIAN, UBUNTU, MINT, ...
elif [ -r /lib/lsb/init-functions ]; then
  source /lib/lsb/init-functions
  [ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ] && OS=`lsb_release -a | grep 'Description' | awk -F':' '{printf $2" (Debian)"}' | xargs echo -n`
# GENTOO
elif [ -r /etc/init.d/functions.sh ]; then
  source /etc/init.d/functions.sh
  [ zz`type -t ebegin 2>/dev/null` == "zzfunction" ] && OS="Gentoo"
# MANDRIVA
elif [ -s /etc/mandriva-release ]; then
  OS="Mandriva"
# SLACKWARE
elif [ -s /etc/slackware-version ]; then
  OS="Slackware"
# ARCH
elif [ -s /etc/arch-release ]; then
  OS="Arch"
fi

# KERNEL
KERNEL=`uname -srm | xargs echo -n`

# VIRTUAL OR NOT
VIRTUAL=`cat /proc/cpuinfo | grep hypervisor 2>/dev/null 1>&2 && echo 'Yes' || echo 'No'`

# IP4I
IP4I=`/sbin/ifconfig | grep 'inet ' | grep -v '127.' | awk -F' ' '{print $2}' | xargs echo -n`
# IP4E
IP4E=`wget https://v4.ident.me/ -O - -q | xargs echo -n`
# IP6I
IP6I=`/sbin/ifconfig | grep 'inet6' | grep -v 'fe80::' | grep -v '::1' | awk -F' ' '{print $2"  "}' | xargs echo -n`
# IP6E
IP6E=`wget https://v6.ident.me/ -O - -q | xargs echo -n`

# USER:GROUP member of GROUPS
USER=`id -un`
USERSTRING="${USER}${Red}:${Green}`id -gn` ${Red}member of ${Green}`id -Gn`"

# LASTLOGIN
LASTLOG=`last -iF | grep '(' | grep 'pts' | head -1 | awk -F' ' '{printf $1" from "$3" on "$4" "$6" "$5" "$8" at "$7" for "$15}' | awk -F'(' '{print $1$2}' | awk -F')' '{print $1}'`

# UPTIME
UPTIME=`uptime -p | awk -F' ' '{print $2"h "$4"min"}' | xargs echo -n`

# LOAD
LOADAVG=`/bin/cat /proc/loadavg` ;
LOAD="`echo ${LOADAVG} | awk {'print $1'}` $Red- $Green`echo $LOADAVG | awk {'print $2'}` $Red- $Green`echo $LOADAVG | awk {'print $3'}`"

# LOGGED IN USERS
LOGGEDINUSERS="`w -h | wc -l | xargs echo -n`"

# MAIL (oonly checks if root has mail for now)
if [ "$EUID" -ne 0 ]; then
  MAIL=''
else
  if [ -f /var/spool/mail/root ]; then
    MAIL=`cat /var/spool/mail/root | grep 'X-Original-To:' | wc -l | xargs echo -n`
  fi
fi

# HDD INFORMATION
HDD=`df -hP | grep "/dev/" | grep -v "tmpfs" | awk {'print $6"|"$2"|("$3"/"$4")|"$5'}`
HDDTXT=""
for i in ${HDD[@]}; do
    res=$(echo $i | tr "|" " ");L=$(echo $res | awk {'print $1'});LS=$(expr 16 - ${#L});LA="";C=0;while [ $C -lt $LS ]; do LA="${LA} ";let C=C+1;done
    S=$(echo $res | awk {'print $2" "$3'});SS=$(expr 20 - ${#S});SA="";C=0;while [ $C -lt $SS ]; do SA="${SA} ";let C=C+1;done
    P=$(echo $res | awk {'print $4'});PA="";C=0;X=$(echo $P | tr "%" " ");let "X /= 4";while [ $C -lt $X ]; do PA="${PA}=";let C=C+1;done;while [ $C -lt 25 ]; do PA="${PA} ";let C=C+1;done
    if [ "${L}" == "/var/share/optimumcache" ]; then L="optimumcache    ";elif [ "${L}" == "/root/development" ]; then L="/root/dev       ";fi
    HDDTXT="${HDDTXT}\n ${Red}${L}${LA} ${Green}${S}${SA} ${Red}[${Green}${PA}${Red}] ${Green}${P}"
    HDDTXT=$(echo "$HDDTXT" | sed "s/\/run\/media\/kayleigh\/backup1/backup1         /")
    HDDTXT=$(echo "$HDDTXT" | sed "s/\/run\/media\/kayleigh\/backup2/backup2         /")
done

# RAM
RAM="`free -h | grep Mem | awk -F' ' '{print $4}'` ${Red}free (${Green}`free -h | grep Mem | awk -F' ' '{print $3}'`${Red}/${Green}`free -h | grep Mem | awk -F' ' '{print $2}'`${Red})"

# SWAP
SWAP="`free -h | grep Swap | awk -F' ' '{print $4}'` ${Red}free (${Green}`free -h | grep Swap | awk -F' ' '{print $3}'`${Red}/${Green}`free -h | grep Swap | awk -F' ' '{print $2}'`}${Red})"

# TIME (includes timezone)
TIME=`date -R`

# PROCESSES
PROCESSES=`ps aux | wc -l`

# RUNNING SERVICES (for now only on systems with systemctl)
if [ "$(type -t systemctl)" = "file" ]; then
  SERVICESSTRING=`systemctl --type=service --state=running 2> /dev/null | grep 'running' | awk -F' ' '{print $1}' | awk -F'.' '{print $1}'`
  skip_services=( accounts-daemon avahi-daemon bluetooth bolt colord cups-browsed dbus fwupd getty@ irqbalance kerneloops ModemManager networkd-dispatcher polkit switcheroo systemd- udisks2 upower user@1000 user@0 zfs-zed haveged rtkit-daemon smartmontools touchegg thermald power-profiles-daemon wpa_supplicant )
  for skip_service in "${skip_services[@]}"
  do
    SERVICESSTRING=`echo -e "${SERVICESSTRING}" | grep -v ${skip_service}`
  done
  SERVICESSTRING=`echo -e "${SERVICESSTRING}" | xargs echo -n`
else
  SERVICESSTRING='OS not supported'
fi

# LOGINS FROM (IP)
LOGINS1=`last -ai | awk -F'-' '{print $2}' | awk -F' ' '{print $3}' | xargs -n1 | sort -u | xargs | awk -F'0.0.0.0 ' '{print $1 $2}' | xargs echo -n`
COUNT=0;LOGINS=""
for LOGIN in ${LOGINS1}; do
    COUNT=`echo "${COUNT} + 1" | bc`
    if [[ ${COUNT} -eq 5 ]]; then LOGINS="${LOGINS} \n                 ${Green}"; COUNT=0 ; fi
    if [[ -z $LOGINS ]]; then LOGINS=${LOGIN}
    else LOGINS="${LOGINS} ${LOGIN}"; fi
done

# AMOUNT OF FAIL2BAN BLOCKS
if [ -f "/var/log/fail2ban.log" ]; then
  BLOCKS=`grep -h "Ban " /var/log/fail2ban.log* | awk '''{print $NF}''' | sort | uniq | wc -l | xargs echo -n`
fi




######################################################################################
# BANNER                                                                             #
######################################################################################
clear

# Old root.land banner ...
#if  [ -f "/dev/mmcblk0" ]; then
#    printf "${Green}";   printf "    .~~.   .~~.    "
#    printf "\n${Green}"; printf "    '. \\' ' /.'    "; printf "${Red}"; printf "`man grep | tail -n5 | head -1 | cut -c 8- | xargs -0 echo -n`"
#    printf "\n${Red}";   printf "    .~ .~~~..~.    ";  printf "${Red}"; printf "`ddate | xargs echo -n`"
#    printf "\n${Red}";   printf "   : .~.'~'.~. :   "
#    printf "\n${Red}";   printf "  ~ (   ) (   ) ~  "
#    printf "\n${Red}";   printf " ( : '~'.~.'~' : ) "; printf "${Green}"; printf '     ____              __    __                    __'
#    printf "\n${Red}";   printf "  ~ .~ (   ) ~. ~  "; printf "${Green}"; printf '    / __ \____  ____  / /_  / /   ____ _____  ____/ /'
#    printf "\n${Red}";   printf "   (  : '~' :  )   "; printf "${Green}"; printf '   / /_/ / __ \/ __ \/ __/ / /   / __ `/ __ \/ __  / '
#    printf "\n${Red}";   printf "    '~ .~~~. ~'    "; printf "${Green}"; printf '  / _, _/ /_/ / /_/ / /__ / /___/ /_/ / / / / /_/ /  '
#    printf "\n${Red}";   printf "        '~'        "; printf "${Green}"; printf ' /_/ |_|\____/\____/\__(_)_____/\__,_/_/ /_/\__,_/   '
#    printf "\n"
#else
#    printf "\n${Green} \`7MM\"\"\"Mq.                     mm      \`7MMF\'                               \`7MM  \n"
#    printf "${Green}   MM   \`MM.                    MM        MM                                   MM  \n"
#    printf "${Green}   MM   ,M9  ,pW\"Wq.   ,pW\"Wq.mmMMmm      MM         ,6\"Yb.  \`7MMpMMMb.   ,M\"\"bMM  \n"
#    printf "${Green}   MMmmdM9  6W\'   \`Wb 6W\'   \`Wb MM        MM        8)   MM    MM    MM ,AP    MM  \n"
#    printf "${Green}   MM  YM.  8M     M8 8M     M8 MM        MM      ,  ,pm9MM    MM    MM 8MI    MM  \n"
#    printf "${Green}   MM   \`Mb.YA.   ,A9 YA.   ,A9 MM   ,,   MM     ,M 8M   MM    MM    MM \`Mb    MM  \n"
#    printf "${Green} .JMML. .JMM.\`Ybmd9\'   \`Ybmd9\'  \`Mbmodb .JMMmmmmMMM \`Moo9^Yo..JMML  JMML.\`Wbmd\"MML.\n"
#    printf "\n${Red} `man grep | tail -n5 | head -1 | cut -c 8- | xargs -0 echo -n`\n `ddate | xargs echo -n`\n"
#fi

# New abs.gd banner
if  [ -f "/dev/mmcblk0" ]; then
    printf "\n${Green}"; printf "    .~~.   .~~.     "
    printf "\n${Green}"; printf "    '. \\' ' /.'      "; printf "${Green}"; printf '   ▄████████ ▀███████████   ▄█████████'
    printf "\n${Red}";   printf "    .~ .~~~..~.     "; printf "${Green}"; printf '  ███    ███   ███    ███  ███     ███ '
    printf "\n${Red}";   printf "   : .~.'~'.~. :    "; printf "${Green}"; printf '  ███    ███   ███    ███  ███     █▀  '
    printf "\n${Red}";   printf "  ~ (   ) (   ) ~   "; printf "${Green}"; printf '  ███    ███ ▄▄███▄▄▄██▀   ███        '
    printf "\n${Red}";   printf " ( : '~'.~.'~' : )  "; printf "${Green}"; printf '▀███████████ ▀▀███▀▀▀██▄   ▀██████████ '
    printf "\n${Red}";   printf "  ~ .~ (   ) ~. ~   "; printf "${Green}"; printf '  ███    ███   ███    ██▄          ███ '
    printf "\n${Red}";   printf "   (  : '~' :  )    "; printf "${Green}"; printf '  ███    ███   ███    ███   ▄█     ███ '
    printf "\n${Red}";   printf "    '~ .~~~. ~'     "; printf "${Green}"; printf '  ███    █▀  ▄█████████▀  ▄█████████▀  '
    printf "\n${Red}";   printf "        '~'         "
    printf "\n\n${Yellow} ";
#    printf "`ddate | xargs echo -n`"
    printf "\n\n"
else
    printf "${Green}";
    printf '\n    ▄████████ ▀███████████   ▄█████████'
    printf '\n   ███    ███   ███    ███  ███     ███ '
    printf '\n   ███    ███   ███    ███  ███     █▀  '
    printf '\n   ███    ███ ▄▄███▄▄▄██▀   ███        '
    printf '\n ▀███████████ ▀▀███▀▀▀██▄   ▀██████████ '
    printf '\n   ███    ███   ███    ██▄          ███ '
    printf '\n   ███    ███   ███    ███   ▄█     ███ '
    printf '\n   ███    █▀  ▄█████████▀  ▄█████████▀  '
    printf "\n\n${Yellow} "
#    printf "`ddate | xargs echo -n`"
    printf "\n\n"
fi




######################################################################################
# VARIABLES                                                                          #
######################################################################################
echo -e "
 ${Yellow}GENERAL
 ${Red}Hostname         ${Green}${HOSTNAME}
 ${Red}OS               ${Green}${OS} (${KERNEL})
 ${Red}Virtual Machine  ${Green}${VIRTUAL}
 ${Red}Time             ${Green}${TIME}
 ${Red}Uptime           ${Green}${UPTIME}
 ${Red}User             ${Green}${USERSTRING}
 
 ${Yellow}SYSTEM
 ${Red}Int IPv4         ${Green}${IP4I}
 ${Red}Ext IPv4         ${Green}${IP4E}
 ${Red}Int IPv6         ${Green}${IP6I}
 ${Red}Ext IPv6         ${Green}${IP6E}
 ${Red}Memory           ${Red}RAM: ${Green}${RAM}  ${Red}SWAP: ${Green}${SWAP}
 ${Red}Load             ${Red}Load: ${Green}${LOAD}  ${Red}Processes: ${Green}${PROCESSES}
 ${Red}Services         ${Green}${SERVICESSTRING}
 
 ${Yellow}SECURITY
 ${Red}Information      ${Red}Mail: ${Green}${MAIL}  ${Red}Users: ${Green}${LOGGEDINUSERS}  ${Red}F2B: ${Green}${BLOCKS}
 ${Red}Last login       ${Green}${LASTLOG}
 ${Red}Logins from      ${Green}${LOGINS}
 
 ${Yellow}DISKS${HDDTXT}
 ${Color_Off}
"
