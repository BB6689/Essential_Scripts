#!/bin/bash

# Define the path for the JSON file and the output text file
JSON_FILE="/home/balaji/Downloads/posts-0-50-2025-03-17.json"  # Update this path to your JSON file
OUTPUT_FILE="/home/balaji/Downloads/extrCT.txt"  # Update this path for the output text file

# Check if the JSON file exists
if [ ! -f "$JSON_FILE" ]; then
  echo "Error: JSON file '$JSON_FILE' not found!"
  exit 1
fi

# Extract id and title and save to the output file
jq -r '.posts[] | "\(.id) \(.title)"' "$JSON_FILE" > "$OUTPUT_FILE"

echo "Extraction complete! Data saved to '$OUTPUT_FILE'."
