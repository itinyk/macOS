#!/bin/bash

currentUser=$(ls -la /dev/console | cut -d' ' -f4)
cuSecureTokenStatus=$(sysadminctl -secureTokenStatus "${currentUser}" 2>&1 | awk -F 'Secure token is | for' '{print $2}')

#Checks if FileVault is enabled on the device
fileVaultStatus=$(fdesetup status)
if [[ $fileVaultStatus == *"FileVault is On."* && $(echo "$fileVaultStatus" | grep "Decryption in progress:") == "" ]]; then
  echo "FileVault is On."
else
  echo "FileVault is Off. Exiting..."
  exit 1
fi

#Checks if Addigy MDM and FileVault Config are installed on the device
echo "Checking if Addigy MDM Profile and FileVault Escrow Payload are installed"
if profiles -P | grep "com.github.addigy.mdm.mdm" >& /dev/null; then
  echo "Addigy MDM Profile is installed. Checking for FileVault Escrow Payload..."
  if [[ $(system_profiler SPConfigurationProfileDataType | grep -A 10 "com.apple.security.FDERecoveryKeyEscrow" | grep "Key will be escrowed to an Addigy secure database.") != "" ]]; then
    echo "FileVault Escrow Payload is installed"
  else
    echo "FileVault Escrow Payload is NOT installed... Exiting!"
    exit 1
  fi
else
  echo "Addigy MDM Profile is NOT installed... Exiting!"
  exit 1
fi

#Checks if there is a logged in user on the device with SecureToken in order to prompt for rotation
if [[ "${currentUser}" != "" && "${currentUser}" != "root" ]]; then
  if [[ "${cuSecureTokenStatus}" != "ENABLED" ]]; then
      echo "$currentUser does not have SecureToken enabled. Cannot proceed with rotating FileVault key.. Exiting!"
      exit 1
    else
      echo "$currentUser has SecureToken enabled."
  fi
else
  echo "No user logged in... Exiting!"
  exit 1
fi

#Creates function to ask for password
function askPassword(){
password=$(/usr/bin/osascript << EOF
with timeout of 180 seconds
display dialog "Your IT Admin requires your password to continue with rotating the FileVault key.\n\nEnter the password for user \"$currentUser\" to continue the process:" default answer "" with icon POSIX file "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/FileVaultIcon.icns" with hidden answer buttons {"Continue"} default button 1 giving up after 180
end timeout
EOF
)
}

#Creates a function for asking for logged in User's password again if previous input was incorrect using osascript
function wrongPassword(){
password=$(/usr/bin/osascript << EOF
with timeout of 180 seconds
display dialog "Incorrect Password.\n\nPlease enter the correct password for user \"$currentUser\" to continue rotating FileVault key:" default answer "" with icon POSIX file "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/FileVaultIcon.icns" with hidden answer buttons {"Continue"} default button 1 giving up after 180
end timeout
EOF
)
}

#Creates a function that prompts User that the max number of authentication attempts have been reached using osascript
function contactAdmin(){
/usr/bin/osascript << EOF
with timeout of 180 seconds
display dialog "Too many incorrect password attempts for user \"$currentUser\".\n\nPlease Contact your IT Admin for following steps." with icon POSIX file "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/FileVaultIcon.icns" with hidden answer buttons {"Continue"} default button 1 giving up after 180
end timeout
EOF
}

#Creates functions to cut the extraneous characters from the $password string
function cutPassword(){
password=$(echo "$password" | awk -F':' '{print $3}' | awk -F ', gave' '{print $1}')
if [[ $password == "" ]]; then
  password="null"
fi
}

echo "Continuing with rotation of FileVault key..."

#Runs the functions for Ask and Cut password
askPassword
cutPassword

#Creates function to run the password through a local password authentication binary in order to verify the password is correct.
function verifyPassword() {
  if ! dscl . authonly ${currentUser} ${password} >& /dev/null; then
    echo "First authentication attempt failed. Asking for password again..."
    wrongPassword
    cutPassword
    if ! dscl . authonly ${currentUser} ${password} >& /dev/null; then
      echo "Second authentication attempt failed. Asking for password again..."
      wrongPassword
      cutPassword
      if ! dscl . authonly ${currentUser} ${password} >& /dev/null; then
        echo "Too many failed authentication attempts... prompting to contact IT Admin"
        contactAdmin
        exit 1
      fi
    fi
  fi
}

#Runs the function to verify password
verifyPassword

#Creates function to pass collected data into the expect cli tool running the rotation command
function passExpect(){
password=$(echo "${password}" | sed 's/\$/\\\$/g')
/usr/bin/expect <<EOF
set timeout -1
set password ${password}
spawn {/usr/bin/fdesetup} {changerecovery} {-personal}
expect "Enter the user name:"
send "$currentUser\r"
expect "Enter the password for user \'$currentUser\':"
send "${password}\r"
expect
EOF
}
passExpect >& /dev/null

echo
echo '--------------------------'
echo
echo "Run all Audits from GoLive then make sure the key is stored and matches in GoLive > Security"