#!/usr/bin/env bash
# launch the swww daemon if it’s not already running
if ! swww query &>/dev/null; then
  swww-daemon &
fi
