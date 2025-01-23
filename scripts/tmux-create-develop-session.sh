#!/bin/bash

# Usage: ./script.sh -t <session_name> <directory_path>

# Initialize default variables
session_name=""
input_path=""

# Parse options
while getopts "t:" opt; do
  case $opt in
  t)
    session_name="$OPTARG"
    ;;
  *)
    echo "Usage: $0 -t <session_name> <directory_path>"
    exit 1
    ;;
  esac
done

# Check for the directory path argument after the options
shift $((OPTIND - 1))
input_path="$1"

if [ -z "$session_name" ]; then
  echo "Error: You must provide a session name using -t option."
  echo "Usage: $0 -t <session_name> <directory_path>"
  exit 1
fi

if [ -z "$input_path" ]; then
  echo "Error: You must provide a directory path as the argument."
  echo "Usage: $0 -t <session_name> <directory_path>"
  exit 1
fi

# If the input is '.', convert it to the absolute path of the current directory
if [ "$input_path" = "." ]; then
  dir_path=$(pwd) # Get the absolute path of the current directory
else
  dir_path=$(realpath "$input_path") # Convert to an absolute path
fi

# Check if the directory actually exists
if [ ! -d "$dir_path" ]; then
  echo "Error: The directory '$dir_path' does not exist."
  exit 1
fi

# tmux window names
main_window="zsh"
container_window="container"

# Check if the tmux session already exists
if tmux has-session -t "$session_name" 2>/dev/null; then
  echo "Attaching to existing tmux session '$session_name'."
else
  echo "Creating a new tmux session named '$session_name' in directory '$dir_path'."
  # Create a new session with the first window named "zsh"
  tmux new-session -d -s "$session_name" -c "$dir_path" -n "$main_window"
fi

# Add a window named "container" if it doesn't already exist
if tmux list-windows -t "$session_name" | grep -q "^1:.*$container_window"; then
  echo "Window '$container_window' already exists in session '$session_name'."
else
  echo "Adding a new window named '$container_window' to session '$session_name'."
  tmux new-window -t "$session_name" -n "$container_window" -c "$dir_path"
fi

# Switch to the "zsh" window before attaching
tmux select-window -t "$session_name:$main_window"

# Attach to the tmux session
tmux attach-session -t "$session_name"
