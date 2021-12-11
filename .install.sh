#!/usra/bin/env bash

# Use GNU Stow to install dotfiles
echo "[*] Symlinking dotfiles ..."
mv README.md .README.md
mv ~/.bashrc ~/.bashrc.old
mv ~/.zshrc ~/.zshrc.old
stow *
mv .README.md README.md
echo "[*] Done."
