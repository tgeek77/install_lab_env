#!/bin/bash

tmux new-session \; \
split-window -v -t $session:0 \; \
split-window -h -t $session:0.0 \; \
send-keys -t $session:0 "clear" C-m \; \
send-keys -t $session:0.0 "clear" C-m \; \
send-keys -t $session:0.1 "clear" C-m \;
