term_config() {
  TERMINALS="alacritty|wezterm|kitty"

  if [ -n "$TMUX" ]; then
    # Within tmux, start from the tmux client's PID
    CURRENT_PID=$(tmux display-message -p '#{client_pid}')
  else
    # Outside tmux, start from the current shell's parent PID
    CURRENT_PID=$PPID
  fi

  # Climb the tree until we find a terminal or hit PID 1
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

  # Use the result in your logic
  case "$DETECTED_TERM" in
    *wezterm*)        nvim ~/.config/wezterm/wezterm.lua ;;
    *alacritty*)      nvim ~/.config/alacritty/alacritty.toml ;;
    *kitty*)      nvim ~/.config/kitty/kitty.conf ;;
    *)                echo "Terminal not in list: $DETECTED_TERM" ;;
  esac
}
