#!/bin/bash

# Set Session Name
session="Startup"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Validate the tmux session doesn't already exist before creating it
if [ "$SESSIONEXISTS" = "" ]
then
	# Start New Session with 'session' as the defined name
	tmux new-session -d -s $session

	# Name first Window and start zsh
	tmux rename-window -t 0 'Main'
	tmux send-keys -t 'Main' 'zsh' C-m 'clear' C-m

	# Setup Dev window with nvim pane
	tmux new-window -t $SESSION:1 -n 'Dev'
	tmux send-keys -t 'Dev' "nvim" C-m
	
	# Setup an additional shell
	tmux new-window -t $SESSION:2 -n 'Shell'
	tmux send-keys -t 'Shell' "zsh" C-m 'clear' C-m

	# Attach Session, on the Main window
	tmux attach-session -t $SESSION:0
fi

# Attach Session on the Main Window
tmux attach-window -t $SESSION:0
