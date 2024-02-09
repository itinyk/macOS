#!/bin/bash
# script kindly provided by @bmorales

#Change the following line. No spaces
NEW_HOSTNAME="<THE_NEW_HOSTNAME>"

# DON'T EDIT BELOW THIS
if [[ $EUID -ne 0 ]]; then
	/usr/bin/printf "This script must be run as root.\n"
	exit 1
fi

/usr/sbin/scutil --set ComputerName "$NEW_HOSTNAME"
/usr/sbin/scutil --set HostName "$NEW_HOSTNAME"
/usr/sbin/scutil --set LocalHostName "$NEW_HOSTNAME"
/usr/bin/dscacheutil -flushcache

/usr/bin/printf "ComputerName='%s'\n" "$(/usr/sbin/scutil --get ComputerName)"
/usr/bin/printf "HostName='%s'\n" "$(/usr/sbin/scutil --get HostName)"
/usr/bin/printf "LocalHostName='%s'\n" "$(/usr/sbin/scutil --get LocalHostName)"

/Library/Addigy/collector
/Library/Addigy/auditor

# uncomment line below if using Watchman Monitoring
#/Library/MonitoringClient/RunClient -F