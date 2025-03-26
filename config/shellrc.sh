#!/bin/sh

if [ -z "$PROFILE_SOURCED" ]; then
	. "${HOME}/.profile"
fi

bindkey -v

# loading custom scripts
. "${HOME}/.scripts/tools/*.sh"

### ALIASES ###
# navigation
alias ls='ls --group-directories-first --color'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd../../..'
alias cls='clear'
alias hyprland='Hyprland'

# Tool macros
#
notify_user() {
	if [ "$(uname)" = "Darwin" ]; then
		osascript -e "display notification \"$1\""
	elif command -v powershell.exe > /dev/null; then
		powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$1')"
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

	if command -v nix-env > /dev/null; then
		nix profile upgrade
	fi

	if command -v flatpak > /dev/null; then
		flatpak update
	fi
}

# End of lines configured by zsh-newuser-install
clear

if command -v fastfetch > /dev/null; then
	fastfetch
elif command -v neofetch > /dev/null; then
	neofetch
fi
