#!/bin/sh

# Any post-install shell script functions go HERE
# Use the post-install.sh to source any environment variables
set_environment_variables() {
	set_env_var_DOTDIR
	set_env_var_ZDOTDIR
}

set_env_var_PATH() {
	#export PATH=/bin:/usr/bin:/usr/local/bin:${PATH}
	#export PATH=${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin:${HOME}/google-cloud-sdk/bin
}

set_env_var_DOTDIR() {
	export DOTDIR=${PWD}
}

set_env_var_ZDOTDIR() {
	SCRIPT_DIR=~/.config
	export ZDOTDIR=~/.config/zsh

	echo "Checking for ZDOTDIR env variable..."
	if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    		echo "  ...present and valid, skipping .zshenv symlink"
	else
    		ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
   		echo "  ...failed to match this script dir, symlinking .zshenv"
	fi
}


# Any post-install actions go HERE
set_environment_variables
echo "dotifles deploy script finish!"
