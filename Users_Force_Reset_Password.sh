#!/bin/sh
LOGGEDINUSER=$(ls -l /dev/console | awk '{print $3}')
pwpolicy -u $LOGGEDINUSER -setpolicy "newPasswordRequired=1"

/Library/Addigy/macmanage/MacManage.app/Contents/MacOS/MacManage action=notify title="Password Reset Required" description="You will be prompted to reset your password on the next log in" closeLabel="Later" acceptLabel="Log Out" timeout=6000 && sudo -u $LOGGEDINUSER osascript -e 'tell app "System Events" to log out'