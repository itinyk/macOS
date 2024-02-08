#!/bin/bash

loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ "$loggedInUser" == "" ]; then
    echo 'No logged-in user detected.'
    exit 1
else
    echo "$loggedInUser"
fi

echoOut () {
echo "$(date) $*"
}

echoOut "Data Drive Size:
$(df -h /dev/disk3s* 2>/dev/null | sort -k3 -h -r)
"

echoOut "Common Cache Directory Sizes:

$(du -h -d1 /Library/Addigy/ansible/packages 2>/dev/null | sort -h -r)
$(du -h -d1 /Library/Addigy/download-cache/downloaded 2>/dev/null | sort -h -r)
$(du -h -d1 /users/$loggedInUser/Library/CloudStorage 2>/dev/null | sort -h -r)
$(du -h -d1 /users/$loggedInUser/Library/Adobe 2>/dev/null | sort -h -r)
$(du -h -d1 "/users/$loggedInUser/Library/Application Support/Adobe/Common/" 2>/dev/null | sort -h -r)
$(du -h -d1 /users/$loggedInUser/Library/Caches/Adobe 2>/dev/null | sort -h -r)
"

echoOut "Current logged in User Size:

$(du -h -d3 /users | sort -h -r)
"

echoOut "Applications Size:

$(du -h -d1 /Applications | sort -h -r)
"

echoOut "Checking for local TimeMachine Snpshots"

if [[ "$(tmutil listlocalsnapshots / | grep -c 'com.apple.TimeMachine' )" -gt 0 ]]
    then
        echoOut "Local TimeMachine Snapshots found.
        "
    else
        echoOut "No Local TimeMachine Snapshots.
        "
fi
Test