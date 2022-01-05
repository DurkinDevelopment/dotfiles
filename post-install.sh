#!/bin/sh

# Use the post-install.sh to source any environment variables
# export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin:${HOME}/google-cloud-sdk/bin
# export GOPATH := ${HOME}

# Any post-install actions go HERE

export ZDOTDIR=~/.config/zsh
SCRIPT_DIR=~/.config

echo "Checking for ZDOTDIR env variable..."
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    echo "  ...present and valid, skipping .zshenv symlink"
else
    ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    echo "  ...failed to match this script dir, symlinking .zshenv"
fi

echo "dotifles deploy script finish!"
