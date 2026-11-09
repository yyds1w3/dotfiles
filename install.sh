#! /bin/bash
DOTFILES="$HOME/dotfiles"
ln -sf "$DOTFILES/fish" "$HOME/.config/fish"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
