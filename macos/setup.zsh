#!/bin/zsh

# MIT License
#
# Copyright (c) 2023 Sophie Katz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

################################################################################
# Boilerplate
################################################################################

# Load libraries
source ${0:a:h}/../utilities/pretty.zsh

# Print the banner
banner

################################################################################
# Applications
################################################################################

log_info "Install applications"

echo "Install these applications:"
echo
echo "  Chrome:             https://www.google.com/chrome"
echo "  1Password:          https://1password.com/downloads/mac"
echo "  FaceBook Messenger: https://www.messenger.com/desktop"
echo "  Discord:            https://discord.com"
echo "  Signal:             https://signal.org/download/"
echo "  Spotify:            https://www.spotify.com/de-en/download/other/"
echo "  VS Code:            https://code.visualstudio.com/download"
echo "  Zoom:               https://zoom.us/download"
echo "  Notion:             https://www.notion.so/desktop"
echo "  qBittorrent:        https://www.qbittorrent.org/download"
echo "  Kindle:             https://www.amazon.com/b?ie=UTF8&node=16571048011"
echo "  Steam:              https://store.steampowered.com/about/"
echo
echo "  Press any key when done."

read -k 1 -s

log_info "Applications successfully installed"

################################################################################
# Xcode command line tools
################################################################################

log_info "Install Xcode command line tools... (will open installer)"

xcode-select -—install

if [ "$?" -eq "0" ]; then
    log_info "Xcode command line tools successfully installed"
else
    log_error "Error while installing Xcode command line tools"
    exit 1
fi

################################################################################
# HomeBrew
################################################################################

log_info "Installing HomeBrew..."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ "$?" -eq "0" ]; then
    log_info "HomeBrew successfully installed"
else
    log_error "Error while installing HomeBrew"
    exit 1
fi

log_info "Installing HomeBrew packages..."

brew update

if [ "$?" -ne "0" ]; then
    log_error "Error while fetching formulae"
    exit 1
fi

brew upgrade

if [ "$?" -ne "0" ]; then
    log_error "Error while upgrading outdated formulae"
    exit 1
fi

brew install \
    htop \
    llvm \
    mpv \
    nvm \
    pyenv \
    sqlite \
;

if [ "$?" -eq "0" ]; then
    log_info "HomeBrew packages successfully installed"
else
    log_error "Error while installing HomeBrew packages"
    exit 1
fi

################################################################################
# Python
################################################################################

PYTHON_VERSION="3.11.6"

log_info "Installing Python $PYTHON_VERSION..."

pyenv install $PYTHON_VERSION

if [ "$?" -eq "0" ]; then
    log_info "Python $PYTHON_VERSION successfully installed"
else
    log_error "Error while installing Python $PYTHON_VERSION"
    exit 1
fi

pyenv global $PYTHON_VERSION

if [ "$?" -eq "0" ]; then
    log_info "Python $PYTHON_VERSION set as global default"
else
    log_error "Error while setting Python $PYTHON_VERSION as global default"
    exit 1
fi

python --version | grep -q "$PYTHON_VERSION"

if [ "$?" -ne "0" ]; then
    log_error "Detected Python version is not $PYTHON_VERSION"
    python --version
    exit 1
fi

################################################################################
# Rust
################################################################################

log_info "Installing Rust..."

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly -c llvm-tools

if [ "$?" -eq "0" ]; then
    log_info "Rust successfully installed"
else
    log_error "Error while installing Rust"
    exit 1
fi

################################################################################
# Dotfiles
################################################################################

log_info "Linking dotfiles..."

rm ~/.gitconfig && \
    ln -s ${0:a:h}/../git/.gitconfig ~/.gitconfig && \
    rm ~/.zshrc && \
    ln -s ${0:a:h}/../zsh/.zshrc ~/.zshrc

if [ "$?" -eq "0" ]; then
    log_info "Dotfiles successfully linked"
else
    log_error "Error while linking dotfiles"
    exit 1
fi

log_info "Patch ~/.ssh/config"

echo "Run: vim ~/.ssh/config"
echo
echo "     Replace LOCAL_IP and GLOBAL_IP per instructions in the file. Press any key"
echo "     when done."

read -k 1 -s

log_info "~/.ssh/config successfully patched"

################################################################################
# SSH
################################################################################

log_info "Generating SSH key..."

ssh-keygen -t rsa -b 4096

if [ "$?" -eq "0" ]; then
    log_info "SSH key successfully generated"
else
    log_error "Error while generating SSH key"
    exit 1
fi

log_info "Copy SSH key to dev server"

echo "Run: ssh-copy-id -i ~/.ssh/id_rsa.pub sophie@SophiesDevServerLocal"
echo
echo "     This requires that password login be enabled on the dev server. Press any"
echo "     key when done."

read -k 1 -s

log_info "SSH key successfully copied to dev server"

################################################################################
# Done
################################################################################

echo
log_info "\033[1;95mDone :3\033[0;0m"
