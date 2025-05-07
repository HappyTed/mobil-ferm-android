#!/usr/bin/bash

trap $(rm -f ./frame.jpg) SIGINT EXIT

if [ -n "$1" ] ; then
    STREAM_PATH="$1"
else 
    STREAM_PATH="$HOME/Documents/mobil-ferm-android/backend/stream"
fi

adb exec-out screenrecord --output-format=h264 - | \
ffmpeg -f h264 -i - -vf fps=5 -q:v 5 -update 1 -y "$STREAM_PATH/frame.jpg"