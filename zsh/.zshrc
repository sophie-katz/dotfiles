# This file comes from https://github.com/sophie-katz/dotfiles

# Prompt string
export PS1="%(?..%F{red}(%?%)%f )%F{243}%*%f %F{170}%n%F{243}@%F{038}%~%F{243}%%%f "

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Path
# export PATH
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
