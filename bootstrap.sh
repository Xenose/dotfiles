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

printf "Password: "
stty -echo
read -r PASSWORD
stty echo

###############################################################################
# Windows Detection
###############################################################################
if [ -n "$WSLENV" ] || grep -q "microsoft" /proc/sys/kernel/osrelease; then
	echo "WSL system detected!"
	echo "Okay, lets get started with this sh**..."

	WINDOWS=true
	WINDOWS_USER="$(whoami.exe | awk -F '\\' '{print $NF}' | tr -d '\r')"

	if [ ! -d "/mnt/c/Users/${WINDOWS_USER}" ]; then
		echo "Windows user directory not found! Skipping symlinks."
		exit 1
	fi
else
	WINDOWS=false
fi

###############################################################################
#   Windows or Linux directory linking/creation
###############################################################################
if $WINDOWS; then

	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Desktop"			"${HOME}/Desktop"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Documents"			"${HOME}/Documents"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Downloads"			"${HOME}/Downloads"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Emails"				"${HOME}/Emails"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Music"				"${HOME}/Music"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Projects"			"${HOME}/Projects"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Pictures"			"${HOME}/Pictures"
	ln -sf "/mnt/c/Users/${WINDOWS_USER}/Videos"				"${HOME}/Videos"

	if command -v rsync > /dev/null; then
		rsync -av "${SCRIPT_PATH}/windows/etc" "/etc/"
	else
		su -c "cp -r \"${SCRIPT_PATH}/windows/etc\" /etc/" root < "${PASSWORD}" 
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

	echo "# Copying /etc configurations"
	su -c "cp -r \"${SCRIPT_PATH}/etc/\"		/etc/" root < "${PASSWORD}"
fi

###############################################################################
#   SSH KEY CREATION
###############################################################################
echo "[ mkdir ] Creating ~/.ssh folder"
mkdir -pv "${HOME}/.ssh"

# Checks if the key exists
if [ ! -f "${HOME}/.ssh/device_ssh_key" ]; then
	echo "[ ssh-keygen ] creating ~/.ssh/device_ssh_key"
	ssh-keygen -t ed25519 -f "${HOME}/.ssh/device_ssh_key" -N ""
fi
	
unset BOOTSTRAP_UP_TO_DATE
