## TODO: Clean up exports - environment variables
# export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin:${HOME}/google-cloud-sdk/bin
# export GOPATH := ${HOME}

## TODO: Add in global vars node pkgs, pip pkgs, packages, base pkgs, pacman?, system enable, & flutter url?

SCRIPT_DIR="src/"

XDG_CONFIG_HOME="build/.config"
XDG_CACHE_HOME="build/.cache"
XDG_DATA_HOME="build/.local/share"

PACKAGES := zsh neovim
CONFIG_PACKAGES := git/local, mc, htop, ranger, gem, tig, gnupg
CACHE_PACKAGES := neovim/log, vim/backup, vim/swap, vim/undo, zsh, tig
DATA_PACKAGES := zsh, man/man1, goenv/plugins, jenv/plugins, luaenv/plugins, nodenv/plugins, phpenv/plugins, plenv/plugins, pyenv/plugins, pyenv/plugins, rbenv/plugins


## TODO: Set this as an environment variable so that the .zshrc file can access it
$(ZSH_RC_FILES=$(wildcard src/zsh/rc.d/*))

$(VERBOSE).SILENT:
.PHONY: all clean setup_build build

all: setup_build build
	@printf "\e[32mBUILD SUCCESS!\e[0m\n"

setup_build:
	@$(MAKE) -s clean
	@mkdir build
	$(MAKE) build --no-print-directory


clean:
	rm -rf build

# Keep all dotfiles generated at ./build
# Add any dotfiles make rules BELOW:

## TODO: Add all configuration / installation to Makefile -> Abstract it out to it's own .sh file (value of abstraction vs global)
## TODO: What should go on the same line as the rule after the `:` & why?


## TODO: Run this and validate each of the package directories get created as they should
create_directories:
	$(foreach package, $(CONFIG_PACKAGES), $(mkdir -p $(XDG_CONFIG_HOME)/$(package)))
	$(foreach package, $(CACHE_PACKAGES), $(mkdir -p $(XDG_CACHE_HOME)/$(package)))
	$(foreach package, $(DATA_PACKAGES), $(mkdir -p $(XDG_DATA_HOME)/$(package)))



build: zsh neovim

zsh: SRC = src/zsh
zsh: DST = $(XDG_CONFIG_HOME)/zsh 
zsh:
	cat $(SRC)/zshrc.rc > $(DST)/.zshrc
	cat $(SRC)/zshenv.rc > $(DST)/.zshenv


neovim: SRC = src/neovim/init
neovim: DST = $(XDG_CONFIG_HOME)/nvim 
neovim:
	## Does this need to be set as an environment variable? Or can I create the directory before hand for it to work?
	NVIM_LOG_FILE = $(XDG_CACHE_HOME)/$@/log
	@mkdir -p $(DST)
	cat $(SRC)/basic.vim > $(DST)/init.vim
	cat $(SRC)/plugins.vim > $(DST)/init.vim
	cat $(SRC)/keymap.vim > $(DST)/init.vim
	cat $(SRC)/misc.vim > $(DST)/init.vim
