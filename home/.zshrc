
# Auto completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# Load promptinit
autoload -Uz promptinit && promptinit

prompt adam1

source "${HOME}/.config/shellrc.sh"
