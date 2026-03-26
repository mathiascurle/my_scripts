# #!/bin/bash
#
# # OMArchy-style menu using rofi
# # Easy to add/remove menus by editing the arrays below
#
# THEME="$HOME/.config/rofi/menu.rasi"
#
# # Main menu entries: "Label" "icon" "action/description"
# # Format: "Label::icon::action"
# # For submenus, action is the function name (e.g., "show_system_menu")
# # For commands, action is the command to run
# declare -a MAIN_MENU=(
#     "Apps::󰀻::show_apps_menu"
#     "System::󰉉::show_system_menu"
#     "Config::󰒓::show_config_menu"
#     "Media::󰕧::show_media_menu"
#     "Style::󰏤::show_style_menu"
# )
#
# # System menu
# declare -a SYSTEM_MENU=(
#     "Lock::󰌾::loginctl lock-session"
#     "Sleep::󰒲::systemctl suspend"
#     "Reboot::󰜉::systemctl reboot"
#     "Shutdown::󰐥::systemctl poweroff"
#     "Log out::󰍃::loginctl terminate-user $USER"
#     "Back::󰉖::show_main_menu"
# )
#
# # Apps menu (opens rofi app launcher)
# declare -a APPS_MENU=(
#     "App Launcher::󰀻::rofi -show drun"
#     "Run Command::󰜺::rofi -show run"
#     "Window Switcher::󰘧::rofi -show window"
#     "Back::󰉖::show_main_menu"
# )
#
# # Config menu - edit configs with $EDITOR
# declare -a CONFIG_MENU=(
#     "Rofi::󰌾::$EDITOR $HOME/.config/rofi/menu.rasi"
#     "Niri::󰉉::# Niri config - edit manually"
#     "Hyprland::󰉉::# Hyprland config - edit manually"
#     "Waybar::󰉉::# Waybar config - edit manually"
#     "Alacritty::󰉉::# Alacritty config - edit manually"
#     "Back::󰉖::show_main_menu"
# )
#
# # Media menu (requires playerctl)
# declare -a MEDIA_MENU=(
#     "Play/Pause::󰏤::playerctl play-pause"
#     "Next::󰤯::playerctl next"
#     "Previous::󰤮::playerctl previous"
#     "Stop::󰓹::playerctl stop"
#     "Back::󰉖::show_main_menu"
# )
#
# # Style menu (requires pywal or hyprpaper)
# declare -a STYLE_MENU=(
#     "Reload Wallpaper::󰉉::# pywal -i \$(cat ~/.cache/wallpaper)"
#     "Change Theme::󰉉::show_theme_menu"
#     "Back::󰉖::show_main_menu"
# )
#
# menu() {
#     local items="$1"
#     echo -e "$items" | rofi -dmenu -p "$2" -theme "$THEME" -i
# }
#
# extract_label() {
#     echo "$1" | awk -F'::' '{print $1}'
# }
#
# extract_icon() {
#     echo "$1" | awk -F'::' '{print $2}'
# }
#
# extract_action() {
#     echo "$1" | awk -F'::' '{print $3}'
# }
#
# handle_choice() {
#     local choice="$1"
#     local action=$(extract_action "$choice")
#
#     # Check if action is a function (submenu)
#     if declare -f "$action" > /dev/null 2>&1; then
#         $action
#     elif [[ "$action" == \#* ]]; then
#         # Comment - feature not available
#         rofi -theme "$THEME" -e "${action:2}" -width 30
#     else
#         # Execute command
#         eval "$action" &
#     fi
# }
#
# show_main_menu() {
#     local items
#     items=$(printf "%s\n" "${MAIN_MENU[@]}")
#     local choice=$(menu "$items" "Menu")
#     [[ -z "$choice" ]] && return
#     handle_choice "$choice"
# }
#
# show_apps_menu() {
#     local items
#     items=$(printf "%s\n" "${APPS_MENU[@]}")
#     local choice=$(menu "$items" "Apps")
#     [[ -z "$choice" ]] && return
#     handle_choice "$choice"
# }
#
# show_system_menu() {
#     local items
#     items=$(printf "%s\n" "${SYSTEM_MENU[@]}")
#     local choice=$(menu "$items" "System")
#     [[ -z "$choice" ]] && return
#     handle_choice "$choice"
# }
#
# show_config_menu() {
#     local items
#     items=$(printf "%s\n" "${CONFIG_MENU[@]}")
#     local choice=$(menu "$items" "Config")
#     [[ -z "$choice" ]] && return
#     handle_choice "$choice"
# }
#
# show_media_menu() {
#     local items
#     items=$(printf "%s\n" "${MEDIA_MENU[@]}")
#     local choice=$(menu "$items" "Media")
#     [[ -z "$choice" ]] && return
#     handle_choice "$choice"
# }
#
# show_style_menu() {
#     local items
#     items=$(printf "%s\n" "${STYLE_MENU[@]}")
#     local choice=$(menu "$items" "Style")
#     [[ -z "$choice" ]] && return
#     handle_choice "$choice"
# }
#
# # Entry point
# # If called with argument, go directly to that menu
# if [[ -n "$1" ]]; then
#     case "$1" in
#         apps) show_apps_menu ;;
#         system) show_system_menu ;;
#         config) show_config_menu ;;
#         media) show_media_menu ;;
#         style) show_style_menu ;;
#         *) show_main_menu ;;
#     esac
# else
#     show_main_menu
# fi
