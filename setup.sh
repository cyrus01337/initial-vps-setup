#!/usr/bin/env bash
RUNNING_USER="$(logname)"
ZSHRC="/home/$RUNNING_USER/.zshrc"

if ! grep -q "^deb-src http://archive.ubuntu.com/ubuntu/ jammy main" /etc/apt/sources.list; then
    echo "http://archive.ubuntu.com/ubuntu/ jammy main" >> /etc/apt/sources.list
fi

sudo apt-get update

# Grab cURL if it's not installed because that's all I know how to use at the moment
if ! command -v curl > /dev/null; then
    sudo apt-get install -y curl git
else
    sudo apt-get install -y git
fi

# APT-Fast (https://github.com/ilikenwf/apt-fast)
if ! command -v curl > /dev/null; then
    /bin/bash -c "$(wget -qO - https://git.io/vokNn)"
else
    /bin/bash -c "$(curl -sL https://git.io/vokNn)"
fi

# Dependencies
sudo apt-fast install -y build-essential fonts-powerline gdb lcov libbz2-dev libffi-dev libgdbm-compat-dev libgdbm-dev liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev lzma lzma-dev pkg-config tk-dev uuid-dev zlib1g-dev zsh
sudo apt-fast build-dep -y python3

# Pre-Install System Update
sudo apt-fast upgrade -y
sudo apt-fast dist-upgrade -y

# Zsh
if ! command -v curl > /dev/null; then
    sh -c "$(wget -qO - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

sudo chsh -s /bin/zsh $RUNNING_USER
curl https://raw.githubusercontent.com/cyrus01337/initial-vps-setup/main/.zshrc > $ZSHRC

# Pyenv
if ! command -v curl > /dev/null; then
    sh -c "$(wget -qO - https://pyenv.run)"
else
    sh -c "$(curl https://pyenv.run)"
fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.11

# NVM
if ! command -v curl > /dev/null; then
    sh -c "$(wget -qO - https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh)"
else
    sh -c "$(curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install 18
npm i -g npm
corepack enable pnpm

# Post-Install
exec $SHELL
