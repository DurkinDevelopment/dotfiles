## TODO: Clean up exports - environment variables
# export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin:${HOME}/google-cloud-sdk/bin
# export GOPATH := ${HOME}

export ZSH_RC_FILES := $(wildcard dotfiles/src/zsh/rc.d/*))

SCRIPT_DIR=src/

XDG_CONFIG_HOME=build/.config
XDG_CACHE_HOME=build/.cache
XDG_DATA_HOME=build/.local/share

PACKAGES := configs zsh neovim
CONFIG_PACKAGES := zsh nvim git/local mc htop ranger gem tig gnupg
CACHE_PACKAGES := neovim/log vim/backup vim/swap vim/undo zsh tig
DATA_PACKAGES := zsh man/man1 goenv/plugins jenv/plugins luaenv/plugins nodenv/plugins phpenv/plugins plenv/plugins pyenv/plugins pyenv/plugins rbenv/plugins

# Is there a more efficient way to do this? If I create the directory is the export environment variable even needed?
export NVIM_LOG_FILE = $(XDG_CACHE_HOME)/nvim/log

$(VERBOSE).SILENT:
.PHONY: all clean build install create_root_directory create_file_structure 

all:
	$(MAKE) create_file_structure
	$(MAKE) build --no-print-directory
	@printf "\e[32mBUILD SUCCESS!\e[0m\n"

clean:
	rm -rf build

create_file_structure: 
	@$(MAKE) -s clean
	@mkdir build
	@mkdir -p $(XDG_CONFIG_HOME)
	$(foreach package, $(CONFIG_PACKAGES), mkdir -p $(XDG_CONFIG_HOME)/$(package))
	@mkdir -p $(XDG_CACHE_HOME)
	$(foreach package, $(CACHE_PACKAGES), mkdir -p $(XDG_CACHE_HOME)/$(package))
	@mkdir -p $(XDG_DATA_HOME)
	$(foreach package, $(DATA_PACKAGES), mkdir -p $(XDG_DATA_HOME)/$(package))
	@chmod 700 $(XDG_CONFIG_HOME)/gnupg

build: $(PACKAGES)



# Keep all dotfiles generated at ./build
# Add any dotfiles make rules BELOW:

configs:
	
zsh: SRC = src/zsh
zsh: DST = $(XDG_CONFIG_HOME)/zsh
zsh:
	cat $(SRC)/zshrc >> $(DST)/.zshrc
	cat $(SRC)/zshenv >> $(DST)/.zshenv

neovim:	SRC = src/neovim/init
neovim:	DST = $(XDG_CONFIG_HOME)/nvim
neovim:
	cat $(SRC)/basic.vim >> $(DST)/init.vim
	cat $(SRC)/plugins.vim >> $(DST)/init.vim
	cat $(SRC)/keymap.vim >> $(DST)/init.vim
	cat $(SRC)/misc.vim >> $(DST)/init.vim
