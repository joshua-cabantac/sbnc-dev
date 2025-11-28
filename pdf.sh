path="$(fd . --type file -e pdf ~ | fzf)"
if [ -n "$path" ]; then
    zathura "$path" &
fi
