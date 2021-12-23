## TODO: Clean up exports - environment variables
# export PATH := ${HOME}/.local/bin:${HOME}/.node_modules/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/bin/core_perl:${HOME}/bin:${HOME}/google-cloud-sdk/bin
# export GOPATH := ${HOME}

## TODO: Add in global vars node pkgs, pip pkgs, packages, base pkgs, pacman?, system enable, & flutter url?


$(VERBOSE).SILENT:
.PHONY: all clean setup_build build

all: setup_build build

setup_build:
	@$(MAKE) -s clean
	@mkdir build
	$(MAKE) build --no-print-directory
	@printf "\e[32mBUILD SUCCESS!\e[0m\n"

clean:
	rm -rf build

# Keep all dotfiles generated at ./build
# Add any dotfiles make rules BELOW:

## TODO: Add all configuration / installation to Makefile -> Abstract it out to it's own .sh file (value of abstraction vs global)
## TODO: What should go on the same line as the rule after the `:` & why?

build: zsh neovim

zsh: $(ZSH_RC_FILES=$(wildcard src/zsh/rc.d/*))
	cat src/zsh/zsh.rc >> build/.zshrc

neovim: SRC = src/neovim/init
neovim: DST = build/.config/nvim
neovim:
	@mkdir -p $(DST)
	cat $(SRC)/basic.vim >> $(DST)/init.vim
	cat $(SRC)/plugins.vim >> $(DST)/init.vim
	cat $(SRC)/keymap.vim >> $(DST)/init.vim
	cat $(SRC)/misc.vim >> $(DST)/init.vim
