#!/bin/bash

# Check if bluetooth is enabled
if bluetoothctl show | grep -q "Powered: yes"; then
  # If enabled, disable it
  bluetoothctl power off
else
  # If disabled, enable it
  bluetoothctl power on
fi

# Update the waybar module
waybar -t
