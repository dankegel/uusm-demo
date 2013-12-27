#!/bin/sh
fat="\
sites/default/files/*.mp3 \
sites/default/files/*.mp4 \
sites/default/files/audio/*.mp3 \
"

tar -czvf fat.tgz $fat
rm -rf $fat
