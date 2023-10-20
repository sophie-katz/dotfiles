#!/bin/bash

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

# Find script directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load libraries
source $SCRIPT_DIR/../utilities/consts.sh
source $SCRIPT_DIR/../utilities/pretty.sh

# Check if running as root
if [[ "$(whoami)" != "root" ]]; then
    log_error "This script must be run as root"
    exit 1
fi

# Print the banner
banner

################################################################################
# Packages
################################################################################

log_info "Updating package list..."

apt update -y

if [ "$?" -eq "0" ]; then
    log_info "Package list successfully updated"
else
    log_error "Error while updating package list"
    exit 1
fi

log_info "Upgrading packages..."

apt upgrade -y

if [ "$?" -eq "0" ]; then
    log_info "Packages successfully upgraded"
else
    log_error "Error while upgrading packages"
    exit 1
fi

log_info "Installing packages..."

apt install -y \
    ca-certificates \
    curl \
    gcc-10 \
    gnupg \
    iproute2 \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncurses-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    lsof \
    mokutil \
    openssh-client \
    openssh-server \
    sudo \
    vim \
    zlib1g-dev \
    zsh \
;

if [ "$?" -eq "0" ]; then
    log_info "Packages successfully installed"
else
    log_error "Error while installing packages"
    exit 1
fi

################################################################################
# Docker
################################################################################

log_info "Adding Docker apt repository..."

install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

if [ "$?" -ne "0" ]; then
    log_error "Error while installing repository key"
    exit 1
fi

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

if [ "$?" -ne "0" ]; then
    log_error "Error while updating sources.list.d"
    exit 1
fi

apt update -y

if [ "$?" -eq "0" ]; then
    log_info "Docker apt repository successfully added"
else
    log_error "Error while adding Docker apt repository"
    exit 1
fi

log_info "Installing Docker engine..."

apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
;

if [ "$?" -eq "0" ]; then
    log_info "Docker engine successfully installed"
else
    log_error "Error while installing Docker engine"
    exit 1
fi

log_info "Smoke testing Docker..."

docker run hello-world

if [ "$?" -eq "0" ]; then
    log_info "Docker engine smoke test passed"
else
    log_error "Error while smoke testing Docker engine"
    exit 1
fi

log_info "Enabling Docker start on boot..."

systemctl enable docker.service && \
    systemctl enable containerd.service

if [ "$?" -eq "0" ]; then
    log_info "Docker start on boot successfully enabled"
else
    log_error "Error while enabling Docker start on boot"
    exit 1
fi

log_info "Patch docker-compose.yml"

cp $SCRIPT_DIR/docker-compose.example.yml $SCRIPT_DIR/docker-compose.yml

if [ "$?" -ne "0" ]; then
    log_error "Error while copying docker-compose.example.yml"
    exit 1
fi

echo "Run: vim $SCRIPT_DIR/docker-compose.yml"
echo
echo "     Replace PHOTOS_PATH with the path to photos. Press any key when done."

read -k 1 -s

log_info "docker-compose.yml successfully patched"

log_info "Starting Docker Compose environment..."

docker compose up -d -f $SCRIPT_DIR/docker-compose.yml

if [ "$?" -eq "0" ]; then
    log_info "Docker Compose environment successfully started"
else
    log_error "Error while starting Docker compose environment"
    exit 1
fi

################################################################################
# Users
################################################################################

log_info "Creating groups..."

groupadd docker

if [ "$?" -eq "0" ]; then
    log_info "Groups successfully created"
else
    log_error "Error while creating groups"
    exit 1
fi

log_info "Adding user sophie..."

adduser sophie

if [ "$?" -eq "0" ]; then
    log_info "User successfully added"
else
    log_error "Error while adding user"
    exit 1
fi

log_info "Adding user to groups..."

usermod -aG docker $USER

if [ "$?" -eq "0" ]; then
    log_info "User successfully added to groups"
else
    log_error "Error while adding user to groups"
    exit 1
fi

log_info "Setting user default shell to zsh..."

usermod --shell /bin/zsh sophie

if [ "$?" -eq "0" ]; then
    log_info "User default shell successfully set to zsh"
else
    log_error "Error while setting user default shell to zsh"
    exit 1
fi

################################################################################
# Python
################################################################################

log_info "Installing Python $PYTHON_VERSION..."

su sophie -c "pyenv install $PYTHON_VERSION"

if [ "$?" -eq "0" ]; then
    log_info "Python $PYTHON_VERSION successfully installed"
else
    log_error "Error while installing Python $PYTHON_VERSION"
    exit 1
fi

su sophie -c "pyenv global $PYTHON_VERSION"

if [ "$?" -eq "0" ]; then
    log_info "Python $PYTHON_VERSION set as global default"
else
    log_error "Error while setting Python $PYTHON_VERSION as global default"
    exit 1
fi

su sophie -c "python --version" | grep -q "$PYTHON_VERSION"

if [ "$?" -ne "0" ]; then
    log_error "Detected Python version is not $PYTHON_VERSION"
    python --version
    exit 1
fi

log_info "Upgrading Pip..."

su sophie -c "python3 -m pip install --upgrade pip"

if [ "$?" -eq "0" ]; then
    log_info "Pip successfully upgraded"
else
    log_error "Error while upgrading Pip"
    exit 1
fi

################################################################################
# Dotfiles
################################################################################

log_info "Linking dotfiles..."

rm /etc/docker/daemon.json && \
    ln -s $SCRIPT_DIR/../docker/daemon.json /etc/docker/daemon.json && \
    rm /etc/ssh/sshd_config && \
    ln -s $SCRIPT_DIR/../ssh/sshd_config /etc/ssh/sshd_config && \
    rm /home/sophie/.gitconfig && \
    ln -s $SCRIPT_DIR/../git/.gitconfig /home/sophie/.gitconfig && \
    rm /home/sophie/.zshrc && \
    ln -s $SCRIPT_DIR/../zsh/.zshrc /home/sophie/.zshrc

if [ "$?" -eq "0" ]; then
    log_info "Dotfiles successfully linked"
else
    log_error "Error while linking dotfiles"
    exit 1
fi

log_info "Patch /etc/ssh/sshd_config"

echo "Run: vim /etc/ssh/sshd_config"
echo
echo "     Replace PORT per instructions in the file. Press any key when done."

read -k 1 -s

log_info "/etc/ssh/sshd_config successfully patched"
