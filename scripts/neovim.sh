#!/bin/sh

case $(uname) in
Darwin)
  brew install neovim
  ;;
Linux)
  if [ "$(command -v apt-get)" ]; then
    sudo apt-get install -y neovim
  elif [ "$(command -v dnf)" ]; then
    sudo dnf install -y neovim python3-neovim
  fi
  ;;
*)
  echo "unsupported environment"
  ;;
esac

# neovim plugins installation
wget -O "$HOME/.vim/autoload/plug.vim" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim -c "PlugInstall" -c "qa"
