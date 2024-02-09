#!/bin/bash

launchctl unload /Library/LaunchDaemons/com.webroot.security.mac.plist
launchctl unload /Library/LaunchDaemons/com.webroot.webfilter.mac.plist
rm /usr/local/bin/WSDaemon
rm /usr/local/bin/WFDaemon
killall -9 WSDaemon
killall -9 WFDaemon
killall -9 "Webroot SecureAnywhere"
rm -rf /System/Library/Extensions/SecureAnywhere.kext
rm -rf "/Applications/Webroot SecureAnywhere.app"
rm /Library/LaunchAgents/com.webroot.webfilter.mac.plist
rm /Library/LaunchDaemons/com.webroot.security.mac.plist