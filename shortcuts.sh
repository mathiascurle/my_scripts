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

term_config() {
  TERMINALS="alacritty|wezterm"

  if [ -n "$TMUX" ]; then
    # Within tmux, start from the tmux client's PID
    CURRENT_PID=$(tmux display-message -p '#{client_pid}')
  else
    # Outside tmux, start from the current shell's parent PID
    CURRENT_PID=$PPID
  fi

  # 3. Climb the tree until we find a terminal or hit PID 1
  DETECTED_TERM="unknown"
  while [ "$CURRENT_PID" -gt 1 ]; do
    # Get the process name
    PROC_NAME=$(ps -p "$CURRENT_PID" -o comm= | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')

    # Check if the process name is in our list of terminals
    if [[ "$PROC_NAME" =~ ($TERMINALS) ]]; then
      DETECTED_TERM="$PROC_NAME"
      break
    fi

    # Climb to the next parent
    CURRENT_PID=$(ps -p "$CURRENT_PID" -o ppid= | tr -d '[:space:]')
  done

  # echo "Terminal Emulator: $DETECTED_TERM"

  # 4. Use the result in your logic
  case "$DETECTED_TERM" in
    *wezterm*)        nvim ~/.config/wezterm/wezterm.lua ;;
    *alacritty*)      nvim ~/.config/alacritty/alacritty.toml ;;
    *)                echo "Terminal not in list: $DETECTED_TERM" ;;
  esac
}
