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
