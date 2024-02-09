#!/bin/bash
loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ "$loggedInUser" == "" ]; then
    echo 'No logged-in user detected.'
    exit 1
else
    echo "$loggedInUser"
fi

#Very basic quit Safari and delete application support folder for Safari. When user relaunches Safari it will be reset.

#force quit Safari
killall Safari;

sleep 2

rm -Rf /Users/$loggedInUser/Library/Cookies/*;
rm -Rf /Users/$loggedInUser/Library/Cache/*;
rm -Rf /Users/$loggedInUser/Library/Safari/*;
rm -Rf /Users/$loggedInUser/Library/Caches/Apple\ -\ Safari\ -\ Safari\ Extensions\ Gallery;
rm -Rf /Users/$loggedInUser/Library/Caches/Metadata/Safari;
rm -Rf /Users/$loggedInUser/Library/Caches/com.apple.Safari;
rm -Rf /Users/$loggedInUser/Library/Caches/com.apple.WebKit.PluginProcess;
rm -Rf /Users/$loggedInUser/Library/Cookies/Cookies.binarycookies;
rm -Rf /Users/$loggedInUser/Library/Preferences/Apple\ -\ Safari\ -\ Safari\ Extensions\ Gallery;
rm -Rf /Users/$loggedInUser/Library/Preferences/com.apple.Safari.LSSharedFileList.plist;
rm -Rf /Users/$loggedInUser/Library/Preferences/com.apple.Safari.RSS.plist;
rm -Rf /Users/$loggedInUser/Library/Preferences/com.apple.Safari.plist;
rm -Rf /Users/$loggedInUser/Library/Preferences/com.apple.WebFoundation.plist;
rm -Rf /Users/$loggedInUser/Library/Preferences/com.apple.WebKit.PluginHost.plist;
rm -Rf /Users/$loggedInUser/Library/Preferences/com.apple.WebKit.PluginProcess.plist;
rm -Rf /Users/$loggedInUser/Library/PubSub/Database;
rm -Rf /Users/$loggedInUser/Library/Saved\ Application\ State/com.apple.Safari.savedState;

sleep 2

open -a "Safari"