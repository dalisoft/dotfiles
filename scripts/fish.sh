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
