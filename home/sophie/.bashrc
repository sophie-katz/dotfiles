#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'

# Prompt strings
PS1='[\u@\h \W]\$ '

# Environment variables
export PATH="$PATH:/home/sophie/.local/bin"
export QT_QPA_PLATFORMTHEME=qt5ct

