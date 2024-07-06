#!/bin/sh

case $(uname) in
Darwin)
  brew install fish
  ;;
Linux)
  if [ "$(command -v apt-get)" ]; then
    sudo apt-get install -y fish
  elif [ "$(command -v dnf)" ]; then
    sudo dnf install -y fish
  fi
  ;;
*)
  echo "unsupported environment"
  ;;
esac

FISH_SHELL_PATH=$(which fish)
sudo chsh -s "$FISH_SHELL_PATH"         # change for root
sudo chsh -s "$FISH_SHELL_PATH" "$USER" # change for current user
