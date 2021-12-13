$(VERBOSE).SILENT:
.PHONY: all
all:
	@$(MAKE) -s clean
	@mkdir build
	$(MAKE) build --no-print-directory
	@printf "\e[32mBUILD SUCCESS!\e[0m\n"

.PHONY: clean
clean:
	rm -rf build

# Keep all dotfiles generated at ./build
# Add any dotfiles make rules BELOW:

## TODO: Add all configuration / installation to Makefile -> Abstract it out to it's own .sh file (value of abstraction vs global)


build: zsh, neovim
	# Copy my zsh config to build/.zshrc


neovim: src = src/neovim/init
neovim: dst = build/.config/nvim
	@mkdir -p $(dst)
	cat $(src)/plugins.vim >> $(dst)/init.vim
	cat $(src)/basic.vim >> $(dst)/init.vim
	cat $(src)/keymap.vim >> $(dst)/init.vim

# Setup the env var with each of the zsh config files and then copy the zshrc to the build directory
zsh: 
	ZSH_RC_FILES=$(wildcard src/zsh/rc.d/*)
	cat src/zsh/zsh.rc > build/.zshrc

