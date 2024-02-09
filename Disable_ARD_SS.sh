#!/bin/bash
/bin/launchctl disable system/com.apple.screensharing
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off