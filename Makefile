SCRIPT_DIR=src/

XDG_CONFIG_HOME=build/.config
XDG_CACHE_HOME=build/.cache
XDG_DATA_HOME=build/.local/share

SETUP = build install create_file_structure 
PACKAGES = configs submodules git_extras git_quick_stats zsh neovim fzf

CONFIG_PACKAGES = zsh nvim git/local mc htop ranger gem tig gnupg
CACHE_PACKAGES = neovim/log vim/backup vim/swap vim/undo zsh tig
DATA_PACKAGES = zsh man/man1 goenv/plugins jenv/plugins luaenv/plugins nodenv/plugins phpenv/plugins plenv/plugins pyenv/plugins pyenv/plugins rbenv/plugins

$(VERBOSE).SILENT:
.PHONY: all clean $(SETUP) $(PACKAGES)

all:
	$(MAKE) create_file_structure
	$(MAKE) build --no-print-directory
	@printf "\e[32mBUILD SUCCESS!\e[0m\n"

clean:
	rm -rf build

build: $(PACKAGES)

create_file_structure: 
	@$(MAKE) -s clean
	@mkdir build
	mkdir -p $(addprefix $(XDG_CONFIG_HOME)/,$(CONFIG_PACKAGES))
	mkdir -p $(addprefix $(XDG_CACHE_HOME)/,$(CACHE_PACKAGES))
	mkdir -p $(addprefix $(XDG_DATA_HOME)/,$(DATA_PACKAGES))
	@chmod 700 $(XDG_CONFIG_HOME)/gnupg

# Keep all dotfiles generated at ./build Add any dotfiles make rules BELOW:

configs: SRC = src/configs
configs: DST = $(XDG_CONFIG_HOME)
configs:
	@printf "Building configs..."
	cat $(SRC)/git/gitconfig >> $(DST)/git/config
	cat $(SRC)/git/gitattributes >> $(DST)/git/attributes
	cat $(SRC)/git/gitignore >> $(DST)/git/ignore
	cat $(SRC)/mc.ini >> $(DST)/mc/ini
	cat $(SRC)/htoprc >> $(DST)/htop/htoprc
	cat $(SRC)/gemrc >> $(DST)/gem/gemrc
	cat $(SRC)/ranger >> $(DST)/ranger/rc.conf
	cp -R $(SRC)/ranger-plugins $(DST)/ranger/plugins
	@printf "\e[32mBuild configs - SUCCESS!\e[0m\n"

submodules:
	@printf "Syncing submodules..."
	git submodule sync > /dev/null
	git submodule update --init --recursive > /dev/null
	git clean -ffd
	@printf "\e[32mSync Submodules - SUCCESS!\e[0m\n"

git_extras:
	@printf "Installing git-extras..."
	pushd src/tools/git-extras \
	PREFIX="$(HOME)/.local" make install > /dev/null \
	popd 
	@printf "\e[32mInstall git-extras - SUCCESS!\e[0m\n"

git_quick_stats:
	@printf "Installing git-quick-stats..."
	pushd src/tools/git-quick-stats \
	PREFIX="$(HOME)/.local" make install > /dev/null \
	popd 
	@printf "\e[32mInstall git-quick-stats - SUCCESS!\e[0m\n"

zsh: SRC = src/zsh
zsh: DST = $(XDG_CONFIG_HOME)/zsh
zsh:
	@printf "Building zsh files..."
	cat $(SRC)/zshrc >> $(DST)/.zshrc
	cat $(SRC)/zshenv >> $(DST)/.zshenv
	mkdir -p $(DST)/plugins/z/zsh-z.plugin.zsh	
	@printf "\e[32mBuild zsh files - SUCCESS!\e[0m\n"

neovim:	SRC = src/neovim/init
neovim:	DST = $(XDG_CONFIG_HOME)/nvim
neovim:
	@printf "Building neovim files..."
	cat $(SRC)/basic.vim >> $(DST)/init.vim
	cat $(SRC)/plugins.vim >> $(DST)/init.vim
	cat $(SRC)/keymap.vim >> $(DST)/init.vim
	cat $(SRC)/misc.vim >> $(DST)/init.vim
	@printf "\e[32mBuild neovim files - SUCCESS!\e[0m\n"

fzf: SRC = src/tools/fzf
fzf:
	@printf "Installing fzf..."
	cat $(SRC)/src/tools/fzf/bin/fzf >> $(HOME)/.local/bin/fzf 
	cat $(SRC)/src/tools/fzf/bin/fzf-tmux >> $(HOME)/.local/bin/fzf-tmux 
	cat $(SRC)/src/tools/fzf/man/man1/fzf.1 >> $(HOME)/man/man1/fzf.1
	cat $(SRC)/src/tools/fzf/man/man1/fzf-tmux.1 >> $(HOME)/man/man1/fzf-tmux.1
	@printf "\e[32mInstall fzf - SUCCESS!\e[0m\n"
