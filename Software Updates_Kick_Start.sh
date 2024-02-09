#!/bin/bash
# Flush DNS cache
dscacheutil -flushcache && killall -HUP mDNSResponder
# Kill any Apple Silicon downloads
if pgrep BrainService; then
    pkill BrainService
fi
# Kill and restart Software Update
while launchctl kill 9 system/com.apple.softwareupdated; do
    sleep 1
done
launchctl kickstart system/com.apple.softwareupdated