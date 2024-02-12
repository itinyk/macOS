#!/bin/bash
loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ "$loggedInUser" == "" ]; then
    echo 'No logged-in user detected.'
    exit 1
else
    echo "$loggedInUser"
fi

killall -9 "Google Chrome"

sleep 5

rm -rf "/Users/$loggedInUser/Library/Application Support/Google Chrome"
rm -rf "/Applications/Google Chrome.app"