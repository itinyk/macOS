#!/bin/bash

# Stop any running DDM processes
sudo pkill -f "softwareupdate"

# Clear downloaded update files
sudo rm -rf /Library/Updates/202[0-9]_[0-9][0-9]_*

# Clear update history
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ResetForegroundUpdates -bool YES

# Restart Software Update service
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.SoftwareUpdate.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.SoftwareUpdate.plist

echo "DDM update reset complete. Please open System Preferences > Software Update to check for updates."