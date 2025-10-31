#!/bin/bash
#!/usr/bin/env bash
set -euo pipefail

SESSION="edit-configs"

# ordered list of window names
WINDOWS=(zshrc tmux nvim alacritty hyprland waybar)

# mapping from name → path
declare -A CONFIGS=(
  [zshrc]="$HOME/.zshrc"
  [tmux]="$HOME/.config/tmux/tmux.conf"
  [nvim]="$HOME/.config/nvim"
  [alacritty]="$HOME/.config/alacritty"
  [hyprland]="$HOME/.config/hypr/hyprland.conf"
  [waybar]="$HOME/.config/waybar"
)

# if session exists, attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
  exec tmux attach -t "$SESSION"
fi

# helper to open in nvim
open_in_nvim() {
  local name="$1"
  local path="$2"

  if [ -f "$path" ]; then
    tmux send-keys -t "$SESSION:$name" "nvim '$path'" C-m
  elif [ -d "$path" ]; then
    tmux send-keys -t "$SESSION:$name" "cd '$path' && nvim ." C-m
  else
    tmux send-keys -t "$SESSION:$name" "echo '⚠️  Not found: $path'; bash" C-m
  fi
}

# create the session with the first window
first="${WINDOWS[0]}"
tmux new-session -d -s "$SESSION" -n "$first"
open_in_nvim "$first" "${CONFIGS[$first]}"

# remaining windows
for name in "${WINDOWS[@]:1}"; do
  tmux new-window -t "$SESSION" -n "$name"
  open_in_nvim "$name" "${CONFIGS[$name]}"
done

# focus first window and attach
tmux select-window -t "$SESSION:1"
exec tmux attach -t "$SESSION"

# # paths (adjust if needed)
# VC="$HOME/.config/nvim/"
# ZSHRC="$HOME/.zshrc"
# TMUX="$HOME/.config/tmux/tmux.conf"
# ALACRITTY="$HOME/.config/alacritty/"
# HYPR="$HOME/.config/hypr/hyprland.conf"
# WAYBAR="$HOME/.config/waybar/"
#
# SESSION="edit-configs"
#
# # if session already exists, just attach
# if tmux has-session -t "$SESSION" 2>/dev/null; then
#   exec tmux attach -t "$SESSION"
# fi
#
# # create new tmux session detached
# tmux new-session -d -s "$SESSION" -n "zshrc" "nvim $ZSHRC"
#
# # create additional windows
# tmux new-window -t "$SESSION" -n "tmux"     "nvim $TMUX"
# tmux new-window -t "$SESSION" -n "vimconf"  "nvim $VC"
# tmux new-window -t "$SESSION" -n "alacritty"  "nvim $ALACRITTY"
# tmux new-window -t "$SESSION" -n "hyprland" "nvim $HYPR"
# tmux new-window -t "$SESSION" -n "waybar"  "nvim $WAYBAR"
#
# # optional: rearrange or start on first window
# tmux select-window -t "$SESSION":1
#
# # attach to the session
# exec tmux attach -t "$SESSION"
#
#
# # paths (adjust if needed)
# VC="$HOME/.config/nvim/"
# ZSHRC="$HOME/.zshrc"
# TMUX="$HOME/.config/tmux/tmux.conf"
# ALACRITTY="$HOME/.config/alacritty/"
# HYPR="$HOME/.config/hypr/hyprland.conf"
# WAYBAR="$HOME/.config/waybar/"
#
# SESSION="edit-configs"
#
# # if session already exists, just attach
# if tmux has-session -t "$SESSION" 2>/dev/null; then
#   exec tmux attach -t "$SESSION"
# fi
#
# # create new tmux session detached
# tmux new-session -d -s "$SESSION" -n "zshrc" "nvim $ZSHRC"
#
# # create additional windows
# tmux new-window -t "$SESSION" -n "tmux"     "nvim $TMUX"
# tmux new-window -t "$SESSION" -n "vimconf"  "nvim $VC"
# tmux new-window -t "$SESSION" -n "alacritty"  "nvim $ALACRITTY"
# tmux new-window -t "$SESSION" -n "hyprland" "nvim $HYPR"
# tmux new-window -t "$SESSION" -n "waybar"  "nvim $WAYBAR"
#
# # optional: rearrange or start on first window
# tmux select-window -t "$SESSION":1
#
# # attach to the session
# exec tmux attach -t "$SESSION"
#
