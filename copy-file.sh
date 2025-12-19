#!/usr/bin/env bash

# Select a file with fzf and copy its CONTENT into the clipboard.

set -e

file="$(fzf)"

[ -z "$file" ] && exit 0

if command -v wl-copy >/dev/null 2>&1; then
    cat "$file" | wl-copy
elif command -v xclip >/dev/null 2>&1; then
    cat "$file" | xclip -selection clipboard
else
    echo "No clipboard tool found (need wl-copy or xclip)."
    exit 1
fi

echo "Copied content of: $file"
