# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dockeruser/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# aliases

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST
PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# This strips out a link from a markdown link assuming there is just one on a line
function getlinks() { grep -oE "\[.*\](\(.*?\))" $1 | awk -F '(' '{print $NF }' | sed 's/.$//'; }