#!/bin/bash

# Check if the directory path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Assign the directory path
DIRECTORY="$1"

# Check if the provided directory exists
if [ ! -d "$DIRECTORY" ]; then
  echo "Error: Directory '$DIRECTORY' does not exist."
  exit 1
fi

# Loop through all files in the directory
for FILE in "$DIRECTORY"/*; do
  # Check if it's a file (ignore directories)
  if [ -f "$FILE" ]; then
    # Extract the filename (without path)
    FILENAME=$(basename "$FILE")
    
    # Create a new folder named after the file (excluding the file extension)
    FOLDER="$DIRECTORY/${FILENAME%.*}"
    
    # Create the folder (if it doesn't already exist)
    mkdir -p "$FOLDER"
    
    # Move the file into its respective folder
    mv "$FILE" "$FOLDER/"
    
    echo "Moved '$FILENAME' to '$FOLDER'"
  fi
done

echo "Process complete."
