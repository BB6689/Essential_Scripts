for i in *.mp4; do
    ffmpeg -i "$i" -c copy "${i%.mp4}.mkv" && rm "$i"
done
