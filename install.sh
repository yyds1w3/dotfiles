#! /bin/bash
DOTFILES="$HOME/dotfiles"
ln -sfn "$DOTFILES/fish" "$HOME/.config/fish"
ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sfn "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
