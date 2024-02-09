#!/bin/bash
loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ "$loggedInUser" == "" ]; then
    echo 'No logged-in user detected.'
    exit 1
else
    echo "$loggedInUser"
fi

rm -rf /Users/$loggedInUser/Library/Preferences/com.apple.finder.plist
rm -rf /Users/$loggedInUser/Library/Preferences/com.apple.sidebarlists.plist