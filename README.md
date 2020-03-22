
FuxNews™
========
http://fuxnews.disktree.net/

<img src="bin/fux_card.jpg"/>

## Export

```sh
## Left Screen
ffmpeg -i fff.mp4 -async 1 -filter:v "crop=590:500:42:28" -an bin/video/live/NAME-1/1.mp4
## Right Screen
ffmpeg -i fff.mp4 -async 1 -filter:v "crop=590:500:650:28" -an bin/video/live/NAME-1/1.mp4
```
