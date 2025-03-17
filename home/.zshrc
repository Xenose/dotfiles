# .zshrc

if [ -z "${ZSH_LOADED}" ]; then
	if [ -z "$PROFILE_SOURCED" ]; then
		source "${HOME}/.profile"
	fi

	bindkey -v

	# Auto completion
	zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
	autoload -Uz compinit && compinit

	# Load promptinit
	autoload -Uz promptinit && promptinit

	prompt adam1
	# loading custom scripts
	source "${HOME}/.scripts/tools/*.sh"

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

	export ZSH_LOADED=true
fi

# End of lines configured by zsh-newuser-install
clear
fastfetch
