#!/bin/bash

# bluetooth_connect.sh
# Automatically connects to a preset Bluetooth device

bluetooth_connect() {
  local airpods_mac="50:F3:51:B0:B5:21"
  if bluetoothctl connect "$airpods_mac"; then
    echo "Connected to AirPods"
  else
    echo "Could not connect to airpods. Are they paired?"
    return 1
  fi
}

# bluetooth_connect() {
#     # Configuration - Update these with your device info
#     local device_name="${1:-Mathias\'s AirPods Pro - Find My}"  # Use first argument or default
#     local mac_address="${2:-50:F3:51:B0:B5:21}"          # Optional second argument for MAC
#     local use_mac="${3:-0}"             # Optional third argument: 1 for MAC, 0 for name
#
#     # Timeout in seconds
#     local timeout="${4:-30}"
#
#     # Check if bluetoothctl is available
#     if ! command -v bluetoothctl &> /dev/null; then
#         echo "ERROR: bluetoothctl not found. Please install BlueZ."
#         return 1
#     fi
#
#     # Determine MAC address
#     if [ "$use_mac" = "1" ] && [ -n "$mac_address" ]; then
#         local target_mac="$mac_address"
#         echo "Targeting device by MAC: $target_mac"
#     else
#         # Find device by name
#         echo "Searching for device: $device_name"
#         target_mac=$(bluetoothctl list | grep -i "$device_name" | awk '{print $2}')
#
#         if [ -z "$target_mac" ]; then
#             echo "ERROR: Device '$device_name' not found. Please pair it first."
#             echo "Usage: bluetooth_connect <device_name> [mac_address] [use_mac] [timeout]"
#             return 1
#         fi
#         echo "Found device: $target_mac"
#     fi
#
#     echo "Connecting to $device_name..."
#
#     # Make sure Bluetooth is powered on
#     echo "Enabling Bluetooth..."
#     bluetoothctl power on
#
#     # Check if already paired
#     paired_info=$(bluetoothctl info "$target_mac")
#     if ! echo "$paired_info" | grep -q "Pairable: yes"; then
#         echo "Device not paired. Pairing..."
#         if ! bluetoothctl pair "$target_mac"; then
#             echo "ERROR: Failed to pair with device"
#             return 1
#         fi
#         echo "Pairing successful!"
#     else
#         echo "Device already paired"
#     fi
#
#     # Check if already connected
#     if echo "$paired_info" | grep -q "Connected: yes"; then
#         echo "$device_name is already connected!"
#         return 0
#     fi
#
#     # Connect to device
#     if bluetoothctl connect "$target_mac"; then
#         echo "Successfully connected to $device_name!"
#         return 0
#     else
#         echo "ERROR: Failed to connect to device"
#         return 1
#     fi
# }
