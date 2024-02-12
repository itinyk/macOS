#!/bin/bash
loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ "$loggedInUser" == "" ]; then
    echo 'No logged-in user detected.'
    exit 1
else
    echo "$loggedInUser"
fi

killall -9 "Google Drive"

sleep 5

rm -rf "/Users/$loggedInUser/Library/Application Support/Google/DriveFS"
rm -rf "/Applications/Google Drive.app"

sleep 5

killall -9 Finder