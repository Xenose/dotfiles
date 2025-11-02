#!/bin/bash

set -eu

MPATH="$(readlink -m "${1}")"
MSHELL="$2"

if [ "/" == "${MPATH}" ]; then
	echo "Root path selected! exiting..."
	exit 1
fi

cleanup() {
	umount -l "${MPATH}/proc"		|| true
	umount -l "${MPATH}/sys"		|| true
	umount -l "${MPATH}/dev"		|| true
	umount -l "${MPATH}/run"		|| true
	umount -l "${MPATH}/dev/shm"	|| true
}

trap cleanup EXIT

mount --types proc		/proc		"${MPATH}/proc"
mount --rbind				/sys		"${MPATH}/sys"
mount --rbind				/dev		"${MPATH}/dev"
mount --bind				/run		"${MPATH}/run"
mount --make-rslave					"${MPATH}/sys"
mount --make-rslave					"${MPATH}/dev"
mount --make-slave					"${MPATH}/run"

chroot "${MPATH}" "${MSHELL}"
