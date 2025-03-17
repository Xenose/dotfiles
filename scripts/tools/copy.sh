#!/bin/dash

copy() {
	FILE_PATH="$1"
	RETURN_CODE=0
	MESSAGE="File copied to clipboard!"

	if [ -z "${FILE_PATH}" ]; then
		MESSAGE="No file given"
		RETURN_CODE=1
	elif [ ! -e "${FILE_PATH}" ]; then
		MESSAGE="File not found"
		RETURN_CODE=1
	else
		# Checking what clipboard command we are using.
		if [ "$(uname)" = "Darwin" ]; then
			pbcopy < "${FILE_PATH}"
		elif command -v clip.exe > /dev/null; then
			clip.exe < "${FILE_PATH}"
		elif [ "wayland" = "${XDG_SESSION_TYPE}" ] || [ -z "${XDG_SESSION_TYPE}" ]; then
			if command -v wl-copy > /dev/null; then
				wl-copy < "${FILE_PATH}"
			elif command -v clipman > /dev/null; then
				clipman < "${FILE_PATH}"
			elif command -v wlr-clipboard > /dev/null; then
				wlr-clipboard < "${FILE_PATH}"
			elif command -v greenclip > /dev/null; then
				greenclip < "${FILE_PATH}"
			elif command -v copyq > /dev/null; then
				copyq < "${FILE_PATH}"
			else
				MESSAGE="No wayland clipboard found!"
			fi
		elif [ "x11" = "${XDG_SESSION_TYPE}" ]; then
			if command -v xclip > /dev/null; then
				xclip < "${FILE_PATH}"
			elif command -v xsel > /dev/null; then
				xsel < "${FILE_PATH}"
			elif command -v parcellite > /dev/null; then
				parcellite < "${FILE_PATH}"
			elif command -v clipit > /dev/null; then
				clipit < "${FILE_PATH}"
			elif command -v greenclip > /dev/null; then
				greenclip < "${FILE_PATH}"
			elif command -v copyq > /dev/null; then
				copyq < "${FILE_PATH}"
			else
				MESSAGE="No x11 clipboard found!"
				RETURN_CODE=1
			fi

		elif [ "tty" = "${XDG_SESSION_TYPE}" ]; then
			echo "TTY is not supported!"
			RETURN_CODE=1
		else
			MESSAGE="Failed to copy file to clipboard!"
			RETURN_CODE=1
		fi
	fi

	notify_user "${MESSAGE}"
	return "${RETURN_CODE}"
}
