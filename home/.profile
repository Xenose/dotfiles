# .profile

export PROFILE_SOURCED=true

export HISTFILE=~/.histfile
export HISTSIZE=1000
export SAVEHIST=1000
export HISTCONTROL=ignoredups:erasedups

export PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
export PATH="/var/lib/flatpak/exports/bin:$PATH"

export TERM="xterm-256color"	# getting proper colors
export EDITOR="nvim"
export MANPAGER='nvim +Man!'

#export BROWSER=firefox
export LANG=en_US.UTF-8 
export LC_ALL=en_US.UTF-8
export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1

### Not all of my machines are AMD
if grep -q "AMD" /proc/cpuinfo; then
	export AMD_DEBUG="nongg,nodma"
fi

### SETTING OTHER ENVIRONMENT VARIABLES
if [ -z "$XDG_CONFIG_HOME" ]; then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -z "$XDG_DATA_HOME" ]; then
	export XDG_DATA_HOME="$HOME/.local/share"
fi

if [ -z "$XDG_CACHE_HOME" ]; then
	export XDG_CACHE_HOME="$HOME/.cache"
fi

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
#export XDG_CURRENT_DESKTOP=thunar

if [ -n "$SSH_TTY" ]; then
	export TERM=linux
elif [ "$(tty)" = "/dev/tty1" ]; then
	exec Hyprland
fi
