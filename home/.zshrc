
if [ -z "${ZSH_LOADED}" ]; then
	# Auto completion
	zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
	autoload -Uz compinit && compinit

	# Load promptinit
	autoload -Uz promptinit && promptinit

	prompt adam1

	export SH_LOADED=true

	source "${HOME}/.config/shellrc.sh"
fi
