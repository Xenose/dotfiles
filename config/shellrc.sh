#!/bin/sh

if [ -z "$PROFILE_SOURCED" ]; then
	. "${HOME}/.profile"
fi

bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

# loading custom scripts
. "${HOME}/.scripts/tools/copy.sh"
. "${HOME}/.scripts/tools/update.sh"

### ALIASES ###
# navigation
case "$(uname)" in
	Darwin)	alias ls='ls -G' ;;
	Linux)	alias ls='ls --group-directories-first --color' ;;
esac

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cls='clear'
alias hyprland='Hyprland'

# Tool macros
#
notify_user() {
	if [ "$(uname)" = "Darwin" ]; then
		osascript -e "display notification \"$1\""
	# elif command -v powershell.exe > /dev/null; then
	#	powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$1')"
	elif command -v notify-send > /dev/null; then
		notify-send "$1"
	else
		echo "No program to notify user..."
	fi
}

# package update
update() {
	if command -v pacman > /dev/null; then
		su -c "pacman -Syu"
	fi

	if command -v apt > /dev/null; then
		su -c apt update && sudo apt upgrade -y
	fi

	if command -v dnf > /dev/null; then
		su -c dnf upgrade -y
	fi

	if command -v nix-env > /dev/null; then
		nix profile upgrade
	fi

	if command -v flatpak > /dev/null; then
		flatpak update
	fi
	
	if command -v brew > /dev/null; then
		brew update && brew upgrade
	fi
}

# End of lines configured by zsh-newuser-install
clear

if command -v fastfetch > /dev/null; then
	fastfetch
elif command -v neofetch > /dev/null; then
	neofetch
fi
