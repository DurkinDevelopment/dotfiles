## TODO: Clean up exports - environment variables
# export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin:${HOME}/google-cloud-sdk/bin
# export GOPATH := ${HOME}

export ZSH_RC_FILES = $(wildcard src/zsh/rc.d/*))

SCRIPT_DIR="src/"

XDG_CONFIG_HOME="build/.config"
XDG_CACHE_HOME="build/.cache"
XDG_DATA_HOME="build/.local/share"

PACKAGES := zsh neovim
CONFIG_PACKAGES := git/local, mc, htop, ranger, gem, tig, gnupg
CACHE_PACKAGES := neovim/log, vim/backup, vim/swap, vim/undo, zsh, tig
DATA_PACKAGES := zsh, man/man1, goenv/plugins, jenv/plugins, luaenv/plugins, nodenv/plugins, phpenv/plugins, plenv/plugins, pyenv/plugins, pyenv/plugins, rbenv/plugins



$(VERBOSE).SILENT:
.PHONY: all clean setup_build build

all: setup_build create_directories build
	@printf "\e[32mBUILD SUCCESS!\e[0m\n"

setup_build:
	@$(MAKE) -s clean
	@mkdir build
	$(MAKE) build --no-print-directory

create_directories: 
	$(foreach package, $(CONFIG_PACKAGES), $(mkdir -p $(XDG_CONFIG_HOME)/$(package)))
	$(foreach package, $(CACHE_PACKAGES), $(mkdir -p $(XDG_CACHE_HOME)/$(package)))
	$(foreach package, $(DATA_PACKAGES), $(mkdir -p $(XDG_DATA_HOME)/$(package)))
	chmod 700 $(XDG_CONFIG_HOME)/gnupg

clean:
	rm -rf build

# Keep all dotfiles generated at ./build
# Add any dotfiles make rules BELOW:


build: configs zsh neovim

configs:

zsh: SRC = src/zsh
zsh: DST = $(XDG_CONFIG_HOME)/zsh 
zsh:
	# Follow Up: Link zshenv if needed / ZDOTDIR dynamic check workflow (what is the use case for it)
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
