#!/bin/bash

# cd and ls
cdl() {
  cd $1 && ls
}

# clear and ls
cls() {
  clear && ls $1
}

# clear and la
cla() {
  clear && la $1
}

# make and change directory
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# cd path or . and nvim
# short for nvim but with cd
nv() {
  arg=${1:-.}
  if [ -d $arg ]; then # is directory
    cd $arg && nvim .
    # elif [ -e $arg ]; then # is file
  else
    nvim $arg
  fi
}

venv-install-requirements() {
  rel_path=$(find . -maxdepth 3 -name "requirements.txt" -print 2>/dev/null)
  if [[ -n "$rel_path" ]]; then
    abs_path=$(realpath "$rel_path")
    echo -n "Found file '$abs_path'. Do you want to install this? (Y/n)"
    read yes
    if [ "$yes" != "n" ]; then
      pip install -r "$abs_path"
      echo "INFO: Installed $abs_path to current environment"
      return 0
    else
      echo "INFO: Not installing"
      return 1
    fi
  else
    echo "ERROR: No file 'requirements.txt' in cwd"
    return 1
  fi
}

venv-make() {
  name=${1}
  abs_path="$HOME/.python_venvs"
  if [ ! -d "$HOME/.python_venvs" ]; then
    echo -n "WARNING: Did not find '~/.python_venvs' directory. Do you want to make one? (Y/n)"
    read yes
    if [ "$yes" != "n" ]; then
      mkdir "$abs_path"
    else
      return 1
    fi
  fi
  if [ -z "$name" ]; then
    echo "ERROR: venv name not given"
    echo "Usage: 'venv-make <venv-name>'"
    return 1
  else
    python3 -m venv "$abs_path/$name"
    echo "Created venv $name in $abs_path"
    return 0
  fi
}

venv-activate() {
  name=${1}
  venv_path="$HOME/.python_venvs"
  abs_path="$venv_path/$name"
  if [ -z "$name" ]; then
    echo "ERROR: venv name not given"
    echo "Usage: 'venv-activate <venv-name>'"
    return 1
  elif [ ! -d "$abs_path" ]; then
    echo "WARNING: non-existing path '$abs_path'"
    echo "Is your venv located elsewhere?"
    echo "Default dir is '~/.python_venvs'"
    echo -n "Do you want to create a new venv with this name? (y/N)"
    read new
    if [ ! -z "$new" ]; then
      if [ "$new" = "y" ]; then
        venv-make $name
        if [[ $? == 0 ]]; then # Check if venv-make was succesfull
          echo "Created venv succesfully"
          if source $venv_path/$name/bin/activate; then
            echo "Activated $name"
            return 0
          else
            echo "WARNING: Could not activate venv"
            return 1
          fi
        else
          echo "Did not create venv"
          return 1
        fi
      fi
    fi
  else
    if source ~/.python_venvs/$name/bin/activate; then
      echo "Activated $name"
      return 0
    fi
    return 1
  fi
}
