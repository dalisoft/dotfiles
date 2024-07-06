#!/bin/sh

case $(uname) in
Darwin)
  brew install fnm
  ;;
Linux)
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  ;;
*)
  echo "unsupported environment"
  ;;
esac
