SCRIPT_DIR=src/

XDG_CONFIG_HOME=build/.config
XDG_CACHE_HOME=build/.cache
XDG_DATA_HOME=build/.local/share

PACKAGES = configs submodules zsh neovim
CONFIG_PACKAGES = zsh nvim git/local mc htop ranger gem tig gnupg
CACHE_PACKAGES = neovim/log vim/backup vim/swap vim/undo zsh tig
DATA_PACKAGES = zsh man/man1 goenv/plugins jenv/plugins luaenv/plugins nodenv/plugins phpenv/plugins plenv/plugins pyenv/plugins pyenv/plugins rbenv/plugins

# Is there a more efficient way to do this? If I create the directory is the export environment variable even needed?
export NVIM_LOG_FILE = $(XDG_CACHE_HOME)/nvim/log


$(VERBOSE).SILENT:
.PHONY: all clean build install create_file_structure configs submodules zsh neovim

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
	@printf "\e[32mConfigs Build - SUCCESS!\e[0m\n"

submodules:
	@printf "Syncing submodules..."
	git submodule sync > /dev/null
	git submodule update --init --recursive > /dev/null
	git clean -ffd
	@printf "\e[32mSyncing Submodules - SUCCESS!\e[0m\n"



zsh: SRC = src/zsh
zsh: DST = $(XDG_CONFIG_HOME)/zsh
zsh:
	cat $(SRC)/zshrc >> $(DST)/.zshrc
	cat $(SRC)/zshenv >> $(DST)/.zshenv
	mkdir -p $(DST)/plugins/z/zsh-z.plugin.zsh	

neovim:	SRC = src/neovim/init
neovim:	DST = $(XDG_CONFIG_HOME)/nvim
neovim:
	cat $(SRC)/basic.vim >> $(DST)/init.vim
	cat $(SRC)/plugins.vim >> $(DST)/init.vim
	cat $(SRC)/keymap.vim >> $(DST)/init.vim
	cat $(SRC)/misc.vim >> $(DST)/init.vim

fzf: SRC = src/tools/fzf
fzf:
	

