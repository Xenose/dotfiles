#!/bin/sh


# syncing with a up to date version
if [ -z "${BOOTSTRAP_UP_TO_DATE}" ]; then
	git pull
	export BOOTSTRAP_UP_TO_DATE=true
	sh "$0"
	exit
fi

if [ "$(id -u)" = 0 ]; then
	echo "This script must not be run as root."
	exit 1
fi

# start of the actual script
DISTRO=$(grep -E '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

[ -z "$DISTRO" ] && DISTRO="Unknown"

###############################################################################
# Command setup section
###############################################################################
CMD_COPY="cp -vr --no-preserve=mode,ownership"

if command -v rsync > /dev/null; then
	CMD_COPY="rsync -rltD"
fi

echo "CMD_COPY is: $CMD_COPY"

super() {
	if command -v sudo > /dev/null; then
		# shellcheck disable=SC2068
		sudo $@
	else
		if [ ! -e "${PASSWORD_FILE}" ]; then
			# Password handling should never fail
			set -e

			# creating a temporary password file
			PASSWORD_FILE=$(mktemp)
			trap 'rm -f "$PASSWORD_FILE"' EXIT
			chmod 600 "$PASSWORD_FILE"

			printf "Password: "
			stty -echo
			read -r PASSWORD
			stty echo
			echo ""

			# storing the password
			echo "$PASSWORD" > "$PASSWORD_FILE"
			unset PASSWORD

			# we can allow failure now
			set +e
		fi

		su -c "$@" root < "${PASSWORD_FILE}"
	fi
}

rm_move() {
	if rmdir	"${HOME}/${1}" > /dev/null; then
		if [ ! -L "${HOME}/${1}" ]; then
			mkdir -pv "/mnt/c/Users/${WINDOWS_USER}/${2}/"
			mv -ir "${HOME}/${1}/*" "/mnt/c/Users/${WINDOWS_USER}/${2}/"
			rmdir	"${HOME}/${1}"
		fi
	fi
}
###############################################################################
# Windows Detection
###############################################################################
if [ -n "$WSLENV" ] || grep -q "microsoft" /proc/sys/kernel/osrelease; then
	echo "WSL system detected!"
	echo "Okay, lets get started with this sh**..."

	WINDOWS=true
	# shellcheck disable=SC1003
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
	rm_move "Desktop"		"Desktop"
	rm_move "Documents"	"Documents"
	rm_move "Downloads"	"Downloads"
	rm_move "Emails"		"Emails"
	rm_move "Music"		"Music"
	rm_move "Projects"	"Projects"
	rm_move "Pictures"	"Pictures"
	rm_move "Videos"		"Vidoes"

	ln -s "/mnt/c/Users/${WINDOWS_USER}/Desktop"				"${HOME}/Desktop"
	ln -s "/mnt/c/Users/${WINDOWS_USER}/Documents"			"${HOME}/Documents"
	ln -s "/mnt/c/Users/${WINDOWS_USER}/Downloads"			"${HOME}/Downloads"
	ln -s "/mnt/c/Users/${WINDOWS_USER}/Emails"				"${HOME}/Emails"
	ln -s "/mnt/c/Users/${WINDOWS_USER}/Music"				"${HOME}/Music"
	ln -s "/mnt/c/Users/${WINDOWS_USER}/Projects"			"${HOME}/Projects"
	ln -s "/mnt/c/Users/${WINDOWS_USER}/Pictures"			"${HOME}/Pictures"
	ln -s "/mnt/c/Users/${WINDOWS_USER}/Videos"				"${HOME}/Videos"
	ln -s "/mnt/c/Users/${WINDOWS_USER}/AppData"				"${HOME}/.appdata"

	# shellcheck disable=SC2086
	super ${CMD_COPY} "${SCRIPT_PATH}/platform/windows/etc" "/etc/"
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
${CMD_COPY} "${SCRIPT_PATH}/home/"		"${HOME}/"
${CMD_COPY} "${SCRIPT_PATH}/config/"	"${HOME}/.config/"

# shellcheck disable=SC2086
super ${CMD_COPY} "${SCRIPT_PATH}/etc/" "/etc/"

case "$DISTRO" in
	"Arch Linux")
		# shellcheck disable=SC2086
		super ${CMD_COPY} "${SCRIPT_PATH}/platform/arch/etc/" "/etc/"
		;;
esac

###############################################################################
#   SSH KEY CREATION
###############################################################################
echo "[ mkdir ] Creating ~/.ssh folder"
mkdir -pv "${HOME}/.ssh"

# Checks if the key exists
if [ ! -f "${HOME}/.ssh/device_ssh_key" ]; then
	if command -v ssh-keygen > /dev/null; then
		echo "[ ssh-keygen ] creating ~/.ssh/device_ssh_key"
		ssh-keygen -t ed25519 -f "${HOME}/.ssh/device_ssh_key" -N ""
	else
		echo "command ssh-keygen is missing!"
	fi
fi

###############################################################################
#   Storing distribution name in /etc/environment
###############################################################################
super echo "DISTRO=${DISTRO}" | tee -a /etc/environment > /dev/null

unset BOOTSTRAP_UP_TO_DATE
