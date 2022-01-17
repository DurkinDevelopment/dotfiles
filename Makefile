SCRIPT_DIR=src/

XDG_CONFIG_HOME=build/.config
XDG_CACHE_HOME=build/.cache
XDG_DATA_HOME=build/.local/share

SETUP = build install create_file_structure 
PACKAGES = configs submodules git_extras git_quick_stats zsh neovim fzf

CONFIG_PACKAGES = zsh nvim git/local mc htop ranger gem tig gnupg zsh/plugins/{powerlevel10k,fzf-tab,autoenv,autopair,abbr,syntax-highlighting,autosuggestions}
CACHE_PACKAGES = neovim/log vim/{backup,swap,undo} zsh tig
DATA_PACKAGES = zsh man/man1 goenv/plugins {jenv,luaenv,nodenv,phpenv,plenv,pyenv,rbenv}/plugins

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
	mkdir -p $(HOME)/.local/bin
	mkdir -p $(HOME)/.local/etc
	mkdir -p $(HOME)/man/man1
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
	cat $(SRC)/zprofile >> $(DST)/.zprofile
	mkdir -p $(DST)/plugins/z/zsh-z.plugin.zsh	
	@printf "\e[32mBuild zsh files - SUCCESS!\e[0m\n"
	$(MAKE) zsh_tools

zsh_tools: SRC = src/zsh/plugins
zsh_tools: DST = $(XDG_CONFIG_HOME)/zsh/plugins
zsh_tools:
	@printf "Building zsh tools..."
	cat $(SRC)/powerlevel10k/powerlevel10k.zsh-theme >> $(DST)/powerlevel10k/powerlevel10k.zsh-theme
	cat $(SRC)/fzf-tab/fzf-tab.zsh >> $(DST)/fzf-tab/fzf-tab.zsh
	cat $(SRC)/zsh-autoenv/autoenv.zsh >> $(DST)/autoenv/autoenv.zsh
	cat $(SRC)/zsh-autopair/autopair.zsh >> $(DST)/autopair/autopair.zsh
	cat $(SRC)/zsh-abbr/zsh-abbr.zsh >> $(DST)/abbr/zsh-abbr.zsh
	cat $(SRC)/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh >> $(DST)/syntax-highlighting/zsh-syntax-highlighting.zsh
	@printf "\e[32mBuild zsh tools - SUCCESS!\e[0m\n"

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
	pushd src/tools/fzf \
	./install --bin &> /dev/null \
	cat $(SRC)/bin/fzf >> $(HOME)/.local/bin/fzf \
	cat $(SRC)/bin/fzf-tmux >> $(HOME)/.local/bin/fzf-tmux \
	cat $(SRC)/man/man1/fzf.1 >> $(HOME)/man/man1/fzf.1 \
	cat $(SRC)/man/man1/fzf-tmux.1 >> $(HOME)/man/man1/fzf-tmux.1 \
	popd
	@printf "\e[32mInstall fzf - SUCCESS!\e[0m\n"
