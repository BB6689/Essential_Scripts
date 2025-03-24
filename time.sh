#!/bin/bash

# Set the directory containing the videos
VIDEO_DIR="/home/balaji/Downloads/Video"

RANDOM_VIDEO=$(find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" \) | shuf -n 1)

if [ -z "$RANDOM_VIDEO" ]; then
    echo "No videos found in the directory."
    exit 1
fi

# Get the duration of the video in seconds
DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$RANDOM_VIDEO")
DURATION=${DURATION%.*}  # Convert to integer

# Generate a random start time
if [ "$DURATION" -gt 0 ]; then
    RANDOM_START_TIME=$((RANDOM % DURATION))
else
    echo "Error retrieving video duration."
    exit 1
fi


flatpak run org.videolan.VLC --fullscreen --video-filter=crop --crop=2880:1800 --start-time="$RANDOM_START_TIME" --play-and-exit "$RANDOM_VIDEO"
