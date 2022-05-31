#!/bin/bash

# this is a small project I'm working on that uses the ffmpeg tool to convert videos from 
# mkv to mp4
# the syntax for the conversion is ffmpeg -i inputVideoName.mkv -c:v copy -c:a copy outputVideoName.mp4


echo "Hello, kindly give me the path to the video you want to convert"
   read inputvideo
sleep 2

echo "what would you like the new video to be saved as?"
   read outputvideo
sleep 2

ffmpeg -i $inputvideo -c:v copy -c:a copy $outputvideo.mp4 
