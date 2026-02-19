#!/bin/sh

# TODO: use fuzzy find to find config file
conf() {
  typeset -A config_files=(
        nvim "$HOME/.config/nvim"
        alacritty "$HOME/.config/alacritty/alacritty.toml"
        kitty "$HOME/.config/kitty/kitty.conf"
        niri "$HOME/.config/niri"
        zsh "$HOME/.zshrc"
        omz "$HOME/.oh-my-zsh/custom"
        qute "$HOME/.config/qutebrowser/config.py"
        none "$HOME/.config" # base case
    )

  local name="${1:-none}"
  local flag="${2}"

  # Print available config files
  if [[ "$name" = "-h" ]]; then
    echo "Available config files/directories:"
    for key in ${(k)config_files}; do
      echo "  $key -> ${config_files[$key]}"
    done
    return 0
  fi

  if [[ "$flag" = "-d" ]]; then
    if [[ -n "${config_files[$name]}" ]]; then
      local abs_path="${config_files[$name]}"
      if [[ -f "$abs_path" ]]; then
        cd "$(dirname "$abs_path")" # cd to file's directory
      else
        cd "$abs_path" # cd to directory
      fi
    else # no matches
      cd $HOME/.config # open .config dir
    fi
    return 0
  fi

  if [[ -n "${config_files[$name]}" ]]; then
    nvim "${config_files[$name]}" # open config file/dir
  else # no matches
    nvim $HOME/.config # open .config dir
  fi
}
