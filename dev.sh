#!/bin/bash
SCRIPT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
RUN=:"$SCRIPT_PATH/run.sh"
alias run="$RUN"
SESSION="${PWD##*/}"

WINDOW1='VIM'
WINDOW2='TER'
WINDOW3='RUN'
WINDOW4='DCK'

tmux new-session -d -s "$SESSION"
tmux rename-window -t 1 $WINDOW1
tmux send-keys -t $WINDOW1 'nvim' C-m
tmux new-window -t "$SESSION:2" -n ${WINDOW2}
tmux new-window -t "$SESSION:3" -n ${WINDOW3}
tmux send-keys -t 3 "run"
tmux new-window -t "$SESSION:4" -n $WINDOW4
tmux send-keys -t 4 "docker compose up"
tmux attach -t "$SESSION:1"
