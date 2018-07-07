#!/bin/sh
VIDEOS=res/video/live
for f in $(ls $VIDEOS/*.mp4); do
	ffmpeg -i $f -c copy -bsf:v h264_mp4toannexb -f mpegts $f.ts
done
CONCAT=$(echo $(ls $VIDEOS/*.ts) | sed -e "s/ /|/g")
ffmpeg -i "concat:$CONCAT" -c copy -bsf:a aac_adtstoasc fuxnews.mp4
rm $VIDEOS/*.ts
