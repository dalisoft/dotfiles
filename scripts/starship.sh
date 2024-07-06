#!/bin/sh

case $(uname) in
Darwin)
  brew install starship
  ;;
Linux)
  if [ "$(command -v apt-get)" ]; then
    curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin -y
  elif [ "$(command -v dnf)" ]; then
    sudo dnf copr enable atim/starship
    sudo dnf install -y starship
  fi
  ;;
*)
  echo "unsupported environment"
  ;;
esac
