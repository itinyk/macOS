#!/bin/sh

# Determine the current user
currentUser=$(stat -f '%Su' /dev/console)

# Remove the current user from the admin group
dseditgroup -o edit -d $currentUser -t user admin

# Check the exit code of the previous command
if [ "$?" == "0" ]; then
  echo "Successfully removed $currentUser from the admin group."
else
  echo "Error: Unable to remove $currentUser from the admin group."
fi