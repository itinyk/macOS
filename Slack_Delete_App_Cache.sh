#!/bin/bash
loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ "$loggedInUser" == "" ]; then
    echo 'No logged-in user detected.'
    exit 1
else
    echo "$loggedInUser"
fi

killall -2 Slack

sleep 2

rm -rf /Applications/Slack.app
rm -rf /Users/$loggedInUser/Library/Application Support/Slack
rm -rf /Users/$loggedInUser/Library/Saved Application State/com.tinyspeck.slackmacgap.savedState/
rm -rf /Users/$loggedInUser/Library/Preferences/com.tinyspeck.slackmacgap.plist/
rm -rf /Users/$loggedInUser/Library/Preferences/com.tinyspeck.slackmacgap.helper.plist/
rm -rf /Users/$loggedInUser/Library/Logs/Slack/