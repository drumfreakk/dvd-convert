#!/bin/sh

cd ../

#ffmpeg -i movie.mkv -target pal-dvd -vf 'scale=1024:576:force_original_aspect_ratio=decrease,pad=1024:576:(ow-iw)/2:(oh-ih)/2,setsar=1' movie.mpg


for file in *; do
    if [ -f "$file" ]; then
		echo "\n\n\nConverting ${file}"
		nice -n 19 ffmpeg -i $file -target pal-dvd -vf 'scale=1024:576:force_original_aspect_ratio=decrease,pad=1024:576:(ow-iw)/2:(oh-ih)/2,setsar=1' converted/${file%.*}.mpg
    fi
done
