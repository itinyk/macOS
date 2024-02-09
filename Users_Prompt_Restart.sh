#!/bin/bash

username=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ "${username}" = "" ]; then
    (sleep 5 && /sbin/shutdown -r now) &>/dev/null &
else
    /Library/Addigy/macmanage/MacManage.app/Contents/MacOS/MacManage action=notify title="Reboot Required for Update" description="Your device has been updated and needs to be restarted." closeLabel="Later" acceptLabel="Restart" && sudo -u "$username" osascript -e 'tell app "loginwindow" to «event aevtrrst»'
fi