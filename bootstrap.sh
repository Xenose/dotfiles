#!/bin/sh

# syncing with a up to date version
if [ -z "${BOOTSTRAP_UP_TO_DATE}" ]; then
	git pull
	export BOOTSTRAP_UP_TO_DATE=true
	sh "$0"
	exit
fi

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if grep -q "Microsoft" /proc/version; then
	ln -s "/mnt/c/user/sebastian.johansson/Desktop" "${HOME}/Desktop"
	ln -s "/mnt/c/user/sebastian.johansson/My Documents" "${HOME}/Documents"
	ln -s "/mnt/c/user/sebastian.johansson/Downloads" "${HOME}/Downloads"
	ln -s "/mnt/c/user/sebastian.johansson/Projects" "${HOME}/Projects"

	rsync -av "${SCRIPT_PATH}/windows/etc" "/etc/"
fi

rsync -av "${SCRIPT_PATH}/home/"		"${HOME}/"
rsync -av "${SCRIPT_PATH}/config/"	"${HOME}/.config/"
rsync -av "${SCRIPT_PATH}/etc/"		"/etc/"
	
unset BOOTSTRAP_UP_TO_DATE
