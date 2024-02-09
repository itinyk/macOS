#!/bin/bash

loggedInUser=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [ "$loggedInUser" == "" ]; then
    echo 'No logged-in user detected.'
    exit 1
else
    echo "$loggedInUser"
fi

declare -a adobeProcessList=('AdobeCRDaemon' 'AdobeIPCBroker' 'com.adobe.acc.installer.v2' 'CCXProcess.app' 'CCLibrary.app' 'Adobe CEF Helper' 'Core Sync' 'Creative Cloud Helper' 'Adobe Desktop Service' 'Creative Cloud');

for processName in "${adobeProcessList[@]}"; do
  pgrep -f "$(echo $processName)" > /dev/null;

  if [ $? -ne 0 ]; then 
    echo "process not running, skipping: ${processName}";
    continue; 
  fi;

  results=$(pgrep -fl "$(echo $processName)");
  echo $results | awk -v pid='' '{pid=$1; $1=""; print "\nkill process:" $0 " (" pid ")"}';
  kill -9 $(echo $results | awk '{print $1}');

  if pgrep -f "$(echo $processName)" > /dev/null; then 
    killall -9 "$(echo processName)";
  fi;
done;

for processID in $(pgrep -f 'Adobe|adobe'); do
  processName=$(ps -p $processID -o command | awk 'FNR == 2 {print}');
  if [ -z "$processName" ]; then
    continue;
  fi;

  echo "kill process:" $processName "\n";
  kill -9 $processID;
done;

rm -rf /Users/$loggedInUser/Library/Caches/Adobe/
rm -rf "/Users/$loggedInUser/Library/Application Support/Adobe/Common/"