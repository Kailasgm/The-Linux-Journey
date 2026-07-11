#!/bin/bash

# Requires nmcli and waybar -t

# Function to toggle WiFi
  if nmcli radio wifi | grep -q "enabled"; then
    nmcli radio wifi off
    echo "WiFi is now OFF"
  else
    nmcli radio wifi on
    echo "WiFi is now ON"
  fi
  waybar -t #Refresh Waybar after each action


# Function to get the WiFi status


