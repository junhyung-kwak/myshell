#export PS1="\n\[\033[35m\]\$(/bin/date)\n\[\033[32m\]\w\n\[\033[1;31m\]\u@\h: \[\033[1;34m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] -> \[\033[0m\]"
#export PS1="🐧\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
#export PS1="\n${FG_MAGENTA}[\t]${RST}\`if [ \$? != 0 ]; then echo ' ${FG_RED}${BOLD}${HL}!${RST}'; fi\` ${FG_YELLOW}\\w${RST}\n${debian_chroot:+($debian_chroot)}${FG_GREEN}${BOLD}\u${RST}${FG_WHITE}@${RST}${FG_CYAN}\h${RST}\$ "
#export PS1="\[\e[00;37m\]\n\[\e[0m\]\[\e[00;33m\][\[\e[0m\]\[\e[00;34m\]\w\[\e[0m\]\[\e[00;33m\]]\[\e[0m\]\[\e[00;37m\]\n\[\e[0m\]\[\e[01;32m\]\u\[\e[0m\]\[\e[01;33m\]@\[\e[0m\]\[\e[01;32m\]\h\[\e[0m\]\[\e[00;34m\]:\[\e[0m\]\[\e[00;31m\]\\$\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"
#export PS1="🎅\[\e[33;41m\][\[\e[m\]\[\e[32m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\]\[\e[33;41m\]]\[\e[m\]🎄 "
#export PS1="🐧\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
#export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "


#export PS1="🐧\[\033[32m\]\h\[\033[00m\]:\[\033[33;1m\]\w\[\033[m\]\$ "
export PS1="(\[\033[33;1m\]\w\[\033[m\]) of (\033[32m\]\h\[\033[00m\]) \n[🐧] -> "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
