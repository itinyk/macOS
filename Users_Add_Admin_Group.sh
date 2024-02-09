#!/bin/sh

# Determine the current user
currentUser=$(stat -f '%Su' /dev/console)

# Add the current user to the admin group
dseditgroup -o edit -a $currentUser -t user admin

# Check the exit code of the previous command
if [ "$?" == "0" ]; then
  echo "Successfully added $currentUser to the admin group."
else
  echo "Error: Unable to add $currentUser to the admin group."
fi