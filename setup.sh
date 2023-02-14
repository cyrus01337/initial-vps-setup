#!/usr/bin/env bash
ZSHRC="/home/$(logname)/.zshrc"

sudo apt-get update
sudo apt-get install -y git

# Grab cURL if it's not installed because that's all I know how to use at the moment
if [[ ! command -v curl ]]; then
    sudo apt-get install -y curl
fi

# APT-Fast (https://github.com/ilikenwf/apt-fast)
/bin/bash -c "$(curl -sL https://git.io/vokNn)"

# Dependencies
sudo apt-fast install -y build-essential gdb lcov libbz2-dev libffi-dev libgdbm-compat-dev libgdbm-dev liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev lzma lzma-dev pkg-config tk-dev uuid-dev zlib1g-dev zsh
sudo apt-fast build-dep -y python3

# Pre-Install System Update
sudo apt-fast upgrade -y
sudo apt-fast dist-upgrade -y

# Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo chsh -s /bin/zsh $RUNNING_USER
curl https://gist.githubusercontent.com/cyrus01337/ed66e661a3dfe91f07d21d70dc14ef98/raw/494d97108860f0f49906bfa80affba76c5d537e7/.zshrc > $ZSHRC
. $ZSHRC

# Pyenv
curl https://pyenv.run | bash
exec $SHELL
pyenv install 3.11

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
exec $SHELL
nvm install 18
npm i -g npm
corepack enable pnpm

# Post-Install
sudo reboot