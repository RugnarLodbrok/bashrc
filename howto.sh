#!/bin/env bash
function ffmpeg-cheatsheet() {
  echo ffmpeg -i input.mp4 output.mp4
  echo ffmpeg -i input.mp4 -vf scale=-1:720 output.mp4
  echo ffmpeg -i input.mp4 -crf 25 output.mp4  \# quality factor, 0-51 (higher to lower)
  echo ffmpeg -i input.mp4 -t 00:02:00.0  \# trim duration
  echo ffmpeg -i input.mp4 -ss 00:00:10.0  \# trim start
}
