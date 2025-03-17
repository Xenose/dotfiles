#!/bin/sh

# syncing with a up to date version
if [ -z "${BOOTSTRAP_UP_TO_DATE}" ]; then
	git pull
	export BOOTSTRAP_UP_TO_DATE=true
	sh "$0"
	exit
fi

# start of the actual script
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

###############################################################################
#   Windows
###############################################################################
if [ -n "$WSLENV" ] || grep -q "microsoft" /proc/sys/kernel/osrelease; then
	WINDOWS_USER="$(whoami.exe | awk -F '\\' '{print $NF}' | tr -d '\r')"

	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Desktop"				"${HOME}/Desktop"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/My Documents"		"${HOME}/Documents"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Downloads"			"${HOME}/Downloads"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Projects"			"${HOME}/Projects"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Email"				"${HOME}/Email"

	rsync -av "${SCRIPT_PATH}/windows/etc" "/etc/"

else
	echo "This is not a Windows (WSL) environment. Skipping Windows-specific configurations."
fi

###############################################################################
#   Syncing configuration files
###############################################################################
rsync -av "${SCRIPT_PATH}/home/"		"${HOME}/"
rsync -av "${SCRIPT_PATH}/config/"	"${HOME}/.config/"

su -c "rsync -av \"${SCRIPT_PATH}/etc/\"		/etc/" root

###############################################################################
#   SSH KEY CREATION
###############################################################################
mkdir -pv "${HOME}/.ssh"

# Checks if the key exists
if [ ! -f "${HOME}/.ssh/device_ssh_key" ]; then
	ssh-keygen -t rsa -b 4096 -f "${HOME}/.ssh/device_ssh_key"
fi
	
unset BOOTSTRAP_UP_TO_DATE
