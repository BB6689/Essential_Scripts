#!/bin/bash

# Set the directory containing the videos
VIDEO_DIR="/home/balaji/Downloads/Video"

# Find a random video file and play it
RANDOM_VIDEO=$(find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" \) | shuf -n 1)

# Check if a video was found
if [ -z "$RANDOM_VIDEO" ]; then
    echo "No videos found in the directory."
    exit 1
fi

# Play the selected video with VLC in fullscreen mode and crop to 2880x1800 aspect ratio
flatpak run org.videolan.VLC --fullscreen --video-filter=crop --crop=2880:1800 --play-and-exit "$RANDOM_VIDEO"
