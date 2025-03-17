# Create a file list
for f in *.mkv; do echo "file '$f'" >> filelist.txt; done

# Use FFmpeg to concatenate the videos
ffmpeg -f concat -safe 0 -i filelist.txt -c copy output.mkv

# Clean up the temporary file list
rm filelist.txt
