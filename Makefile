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
build: neovim
	cat src/zsh/rc.zsh > build/.zshrc

neovim: src = src/neovim/init
neovim: dst = build/.config/nvim
	@mkdir -p $(dst)
	cat $(src)/plugins.vim >> $(dst)/init.vim
	cat $(src)/basic.vim >> $(dst)/init.vim
	cat $(src)/keymap.vim >> $(dst)/init.vim


