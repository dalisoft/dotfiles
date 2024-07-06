#!/bin/sh

case $(uname) in
Darwin)
  brew install git
  ;;
Linux)
  if [ "$(command -v apt-get)" ]; then
    sudo add-apt-repository -y ppa:git-core/ppa
    sudo apt update -y
    sudo apt install -y git
  elif [ "$(command -v dnf)" ]; then
    sudo dnf install -y git
  fi
  ;;
*)
  echo "unsupported environment"
  ;;
esac
