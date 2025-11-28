#!/bin/bash
SESSION="Vault"
cd ~/Vault

tmux new-session -d -s "$SESSION"
tmux rename-window -t 1 "Obsidian"
tmux send-keys -t "Obsidian" 'nvim' C-m
tmux send-keys -t 4 "codex" C-m
tmux attach -t "$SESSION:1"
