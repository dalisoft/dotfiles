#!/bin/sh

TMPDIR=$(mktemp -d)
CURRENT=$(pwd)

cd "${TMPDIR}" || exit 1

for script in ~/.dotfiles/scripts/*; do
  bash "$script"
done

cd "${CURRENT}" || exit 1

rm -rf "${TMPDIR}"
