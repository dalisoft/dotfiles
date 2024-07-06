#!/bin/sh

case $(uname) in
Darwin)
  brew install ripgrep
  ;;
Linux)
  if [ "$(command -v apt-get)" ]; then
    sudo apt-get install -y ripgrep
  elif [ "$(command -v dnf)" ]; then
    sudo dnf install -y ripgrep
  fi
  ;;
*)
  echo "unsupported environment"
  ;;
esac
