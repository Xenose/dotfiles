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

	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Desktop"			"${HOME}/Desktop"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/My Documents"		"${HOME}/Documents"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Downloads"			"${HOME}/Downloads"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Emails"				"${HOME}/Emails"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Music"				"${HOME}/Music"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Projects"			"${HOME}/Projects"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Pictures"			"${HOME}/Pictures"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Videos"				"${HOME}/Videos"

	if command -v rsync > /dev/null; then
		rsync -av "${SCRIPT_PATH}/windows/etc" "/etc/"
	else
		su -c "cp -r \"${SCRIPT_PATH}/windows/etc\" /etc/" root
	fi

else
	echo "This is not a Windows (WSL) environment. Skipping Windows-specific configurations."

	mkdir -pv "${HOME}/Desktop"
	mkdir -pv "${HOME}/Documents"
	mkdir -pv "${HOME}/Downloads"
	mkdir -pv "${HOME}/Emails"
	mkdir -pv "${HOME}/Music"
	mkdir -pv "${HOME}/Pictures"
	mkdir -pv "${HOME}/Projects"
	mkdir -pv "${HOME}/Videos"

fi

###############################################################################
#   Syncing configuration files
###############################################################################

if command -v rsync > /dev/null; then
	rsync -av "${SCRIPT_PATH}/home/"		"${HOME}/"
	rsync -av "${SCRIPT_PATH}/config/"	"${HOME}/.config/"

	su -c "rsync -av \"${SCRIPT_PATH}/etc/\"		/etc/" root
else
	cp -r "${SCRIPT_PATH}/home/"		"${HOME}/"
	cp -r "${SCRIPT_PATH}/config/"	"${HOME}/.config/"

	su -c "cp -r \"${SCRIPT_PATH}/etc/\"		/etc/" root
fi

###############################################################################
#   SSH KEY CREATION
###############################################################################
mkdir -pv "${HOME}/.ssh"

# Checks if the key exists
if [ ! -f "${HOME}/.ssh/device_ssh_key" ]; then
	ssh-keygen -t rsa -b 4096 -f "${HOME}/.ssh/device_ssh_key"
fi
	
unset BOOTSTRAP_UP_TO_DATE
