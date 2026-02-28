#!/bin/sh

ytdownload() {
  if [ -z "$1" ]; then
    echo "ERROR: No url given"
    return 1
  else
    venv-activate spotify
    if [ -z "$2" ]; then
      shiradl "$1" -f "$HOME/Music"
    else
      shiradl "$1" -f "$2"
    fi
    deactivate
  fi
}
