git_status_all() {
  local changed_repos=() # Array to store repos with any changes

  # Define colors
  RED="\033[1;91m"
  ORANGE="\033[1;38;5;214m"
  GREEN="\033[1;92m"
  MAGENTA="\033[1;95m"
  CYAN="\033[1;96m"
  BLUE="\033[1;94m"
  GRAY="\033[1;90m"
  # YELLOW="\033[0;33m"
  RESET="\033[0m"

  # Find all Git repos and check their status
  find . -type d -name ".git" | while read gitdir; do
    repo=$(dirname "$gitdir")
    echo "${BLUE}Checking Git status in: ${GREEN}$repo${RESET}"

    # Run git status and capture untracked files
    cd "$repo" 
    git_status_output=$(git status --porcelain)

    # Check if there are any changes (untracked, modified, added, deleted, renamed)
    if [ -n "$git_status_output" ]; then
      changed_repos+=("$repo") # Store repo if it has any changes
    fi

    # Print git status output in color
    while IFS= read -r line; do
      symbol="${line:0:2}" # First two characters
      filename="${line:3}" # Everything after
      symbol=$(echo "$symbol" | xargs) # Trim any trailing spaces
      case "$symbol" in
        "M") echo -e "${ORANGE}M ${RESET}${filename}" ;;
        "??") echo -e "${RED}??${RESET} ${filename}" ;;
        "A") echo -e "${GREEN}A ${RESET}${filename}" ;;
        "D") echo -e "${MAGENTA}D ${RESET}${filename}" ;;
        "R") echo -e "${CYAN}R ${RESET}${filename}" ;;
        *)     echo "$line" ;;
      esac
    done <<< "$git_status_output"

    cd - > /dev/null # Go back to the previous dir silently
    echo "${GRAY}----------------------------------------${RESET}"
  done

  # Print summary of repos with any changes
  if [ ${#changed_repos[@]} -gt 0 ]; then
    echo "${GREEN}Repos with changes:${RESET}"
    for repo in "${changed_repos[@]}"; do
      echo "${GREEN}- $repo${RESET}"
    done
  else
    echo "${GREEN}No repos with changes.${RESET}"
  fi
}
