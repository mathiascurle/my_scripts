#!/bin/bash

calc() {
  local HISTORY_FILE="${HOME}/.calc_history"
  local MAX_HISTORY=100
  local CONFIG_FILE="${HOME}/.config/fuzzel/calc.ini"

  # check dependencies
  if ! command -v fuzzel &>/dev/null; then
    echo "Error: fuzzel not installed" >&2
    return 1
  elif ! command -v qalc &>/dev/null; then
    echo "Error: qalc not installed" >&2
    return 1
  fi

  # init history file
  mkdir -p "$(dirname "$HISTORY_FILE")" && touch "$HISTORY_FILE"

  # ensure config exists, if not create default
  if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
[main]
include="~/.config/fuzzel/colors.ini"
font="Paper Mono:size=14"
prompt="calc: "
icons-enabled="no"
width=40
lines=15
horizontal-pad=20
inner-pad=10
line-height=25
EOF
  fi

  # Clipboard helper
  copy_to_clipboard() {
    if command -v wl-copy &>/dev/null; then
      wl-copy "$1" 2>/dev/null
    elif command -v xclip &>/dev/null; then
      xclip -selection clipboard <<< "$1" 2>/dev/null
    elif command -v xsel &>/dev/null; then
      xsel --clipboard <<< "$1" 2>/dev/null
    fi
  }

  # continue requesting new expressions until fuzzel exit
  while true; do
    local history=$(tac "$HISTORY_FILE" 2>/dev/null || cat "$HISTORY_FILE")
    local choice=$(echo -e "$history" | fuzzel --config="$CONFIG_FILE" --dmenu)
    if [ -z "$choice" ]; then
      break # exit on empty expression
    fi

    # check if expression exists
    # if echo "$choice" | grep -q '='; then # old
    if echo "$choice" | grep -qP '.+=\S+'; then
      local result=$(echo "$choice" | sed 's/.*=//')
      copy_to_clipboard "$result"
    elif [ "$choice" = "clear history" ]; then
      sed -i 'd' "$HISTORY_FILE"
      fuzzel --config="$CONFIG_FILE" --dmenu
    else # calculate new expression
      local result=$(qalc -t "$choice" 2>/dev/null | head -n 1 | sed 's/.*= //' | xargs)
      if [ -z "$result" ]; then
        echo "Invalid expression: $choice" | fuzzel --config="$CONFIG_FILE" --dmenu -p "Error: "
      else
        # add to whole expression history file
        echo "${choice}=${result}" >> "$HISTORY_FILE"
        # if reached max history length
        if [ "$(wc -l < "$HISTORY_FILE")" -gt "$MAX_HISTORY" ]; then
          # remove first line
          # sed edit in place, delete line 1
          sed -i '1d' "$HISTORY_FILE"
        fi
        copy_to_clipboard "$result"
      fi
    fi
  done
}

if [ "$1" = "run" ]; then
  calc
fi
