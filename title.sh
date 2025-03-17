#!/bin/bash

# Path to the text file containing the mappings
MAPPING_FILE="extrCT.txt"

while IFS= read -r line; do
    
    FOLDER_NAME=$(echo "$line" | awk '{print $1}')
    NEW_NAME=$(echo "$line" | cut -d' ' -f2-)

    # Check if the folder exists
    if [ -d "$FOLDER_NAME" ]; then
        # Rename the folder
        mv "$FOLDER_NAME" "$NEW_NAME"
        echo "Renamed folder '$FOLDER_NAME' to '$NEW_NAME'"
    else
        echo "Folder '$FOLDER_NAME' does not exist."
    fi
done < "$MAPPING_FILE"
