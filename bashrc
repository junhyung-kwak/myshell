echo "Start myshell sourcing.."
# bash custom design
THIS_BASHRC_PATH="$( dirname "$BASH_SOURCE" )"

source $THIS_BASHRC_PATH/func/include.func #$BASH_INCLUDE

include.os
include.assert

export MY_REQUIRED_ENV="DROPBOX | MYENV | RESULTS_DIR | DATASETS"
echo "========================================================"
echo "[DEFAULT] MYENV : ${MYENV}"
echo "[DEFAULT] RESULTS_DIR : ${RESULTS_DIR}"


# get os from tools
OS=$(os.name) 

source ${THIS_BASHRC_PATH}/${OS}rc
source ${THIS_BASHRC_PATH}/ps1 
#include.relative $OS/bashrc
#include.relative ps1

#ALIAS
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'



# PERSONAL SETTINGS


export SCREENDIR=$HOME/.screen
# MUSE ALERT SOUND
bind 'set bell-style none'


#if !command conda &> /dev/null; then
    source ${THIS_BASHRC_PATH}/language/.condarc 
    #include.relative ../conda/bashrc
#fi

# common contents

source "${MYENV}/command_public"

if [ -f "$MYENV/command_private" ]; then
    echo "command_private exists."
    source "${MYENV}/command_private"
fi
export WINDOWS_USER='/mnt/windows/Users/jhkwak/'

# language settings
export PYTHONSTARTUP=$MYENV/language/.pythonrc

