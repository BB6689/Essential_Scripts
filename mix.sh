#!/bin/bash

echo "  ____  ____   __    __    ___  ___  "
echo " | __ )| __ ) / /_  / /_  ( _ )/ _ \ "
echo " |  _ \|  _ \| '_ \| '_ \ / _ \ (_) |"
echo " | |_) | |_) | (_) | (_) | (_) \__, |"
echo " |____/|____/ \___/ \___/ \___/  /_/  "

# Function to rename folders based on a mapping file
rename_folders() {
    read -p "Enter the path to the mapping file (e.g., extrCT.txt): " MAPPING_FILE

    if [ ! -f "$MAPPING_FILE" ]; then
        echo "Error: Mapping file '$MAPPING_FILE' not found!"
        exit 1
    fi

    while IFS= read -r line; do
        FOLDER_NAME=$(echo "$line" | awk '{print $1}')
        NEW_NAME=$(echo "$line" | cut -d' ' -f2-)

        if [ -d "$FOLDER_NAME" ]; then
            mv "$FOLDER_NAME" "$NEW_NAME"
            echo "Renamed folder '$FOLDER_NAME' to '$NEW_NAME'"
        else
            echo "Folder '$FOLDER_NAME' does not exist."
        fi
    done < "$MAPPING_FILE"
}

# Function to combine MKV files
combine_videos() {
    read -p "Enter the directory containing MKV files: " VIDEO_DIR
    cd "$VIDEO_DIR" || { echo "Directory not found!"; exit 1; }

    for f in *.mkv; do
        echo "file '$f'" >> filelist.txt
    done

    ffmpeg -f concat -safe 0 -i filelist.txt -c copy output.mkv
    rm filelist.txt
    echo "Combined MKV files into output.mkv"
}

# Function to convert video files to MKV
convert_to_mkv() {
    read -p "Enter the directory containing video files: " VIDEO_DIR
    cd "$VIDEO_DIR" || { echo "Directory not found!"; exit 1; }

    echo "Select the file format to convert:"
    echo "1) MP4"
    echo "2) TS"
    echo "3) Other (specify extension)"
    read -p "Enter your choice (1-3): " format_choice

    case "$format_choice" in
        1)
            EXT="mp4"
            ;;
        2)
            EXT="ts"
            ;;
        3)
            read -p "Enter the file extension (without dot, e.g., avi, mov): " EXT
            ;;
        *)
            echo "Invalid option: $format_choice"
            echo "Please select a valid option (1-3)."
            exit 1
            ;;
    esac

    for i in *."$EXT"; do
        if [ -f "$i" ]; then
            ffmpeg -i "$i" -c copy "${i%.$EXT}.mkv" && rm "$i"
        else
            echo "No files found with the extension .$EXT"
        fi
    done
    echo "Converted $EXT files to MKV."
}

# Function to extract data from a JSON file
extract_data() {
    read -p "Enter the path to the JSON file: " JSON_FILE
    read -p "Enter the path for the output text file (e.g., extrCT.txt): " OUTPUT_FILE

    if [ ! -f "$JSON_FILE" ]; then
        echo "Error: JSON file '$JSON_FILE' not found!"
        exit 1
    fi

    jq -r '.posts[] | "\(.id) \(.title)"' "$JSON_FILE" > "$OUTPUT_FILE"
    echo "Extraction complete! Data saved to '$OUTPUT_FILE'."
}

# Main script logic
echo "Select an option:"
echo "1) Rename folders"
echo "2) Combine MKV files"
echo "3) Convert video files to MKV"
echo "4) Extract data from JSON file"
read -p "Enter your choice (1-4): " choice

case "$choice" in
    1)
        rename_folders
        ;;
    2)
        combine_videos
        ;;
    3)
        convert_to_mkv
        ;;
    4)
        extract_data
        ;;
    *)
        echo "Invalid option: $choice"
        echo "Please select a valid option (1-4)."
        exit 1
        ;;
esac
