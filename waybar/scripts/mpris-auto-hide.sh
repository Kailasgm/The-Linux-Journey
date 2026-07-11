#!/usr/bin/env bash
pause_start=0
while true; do
  status=$(playerctl status 2>/dev/null)
  title=$(playerctl metadata title 2>/dev/null)

  if [[ "$status" == "Playing" ]]; then
    pause_start=0
    echo " [  ${title:0:25}"
  elif [[ "$status" == "Paused" ]]; then
    if ((pause_start == 0)); then
      pause_start=$SECONDS
    fi
    if ((SECONDS - pause_start >= 60)); then
      echo ""
    else
      echo " [  <i>${title}</i>"
    fi
  else
    echo ""
  fi
  sleep 1
done
