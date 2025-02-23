# Convert video to (PAL) DVD format

Taken from [the Arch Wiki](https://wiki.archlinux.org/title/Convert_any_Movie_to_DVD_Video), [this random site](https://www.mythtv.org/wiki/Creating_a_DVD_with_a_menu), and [this random gist](https://gist.github.com/mikitsu/4bdc4cc956bed5931130a1a648b9e89e).

## Convert video (using 1 original audio track):

```sh
ffmpeg -i movie.mkv -target pal-dvd -vf 'scale=1024:576:force_original_aspect_ratio=decrease,pad=1024:576:(ow-iw)/2:(oh-ih)/2,setsar=1' movie.mpg
```
The scale is set to 1024:576 as that is the resolution it will be displayed at.

## Subtitles:

### Get subtitles (srt) from video file

```sh
ffmpeg -i movie.mkv -map 0:s:<N> subs.srt
```

Where <N> is the subtitle number, which you can get using mplayer

### Mix subtitles to mpeg

Uses spumux and the [Xerox Sans Serif Wide Bold](http://www.webpagepublicity.com/free-fonts-x.html) font.

```sh
spumux -s0 subs.xml <movie.mpg >movie_sub.mpg
```

`-s0` gives the subtitle stream id, and should be increased if you're adding multiple subtitle tracks.

## Menu

Optional, create a menu if there are multiple films on the same DVD.

### Background
Use the template in menu.xcf, save as a jpg, convert to looping video w/o audio:

```sh
jpeg2yuv -n 50 -I p -f 25 -j menu.jpg | mpeg2enc -n p -f 8 -o menu.m2v
dd if=/dev/zero bs=4 count=2000 | toolame -b 128 -s 48 /dev/stdin menu.mp2
mplex -f 8 -o menu.mpg menu.m2v menu.mp2
```

Thumbnails should be added now, as they cannot be added later. They can easily be extracted from VLC with the keyboard shortcut `Shift - S`.

### Buttons
 1. Open the menu jpg in gimp
> **Note:**\
> The jpg should be 720x576 px, with an x resolution of 75 ppi and a y resolution of 80 ppi.
 2. Create a transparent layer
 3. Mark the button positions on the transparent layer, using max 3 colors
 4. Delete the background layer
 5. Convert the image to indexed color, by right-clicking the image, Image -> Mode -> Indexed, and select 4 colors
 6. Create the image you want it to look like normally, when you haven't selected anything, and save it as `menu1.png`
 7. Create an image with what the buttons should look like selected, and save it as `menu2.png`
> **Note:**\
> For this, only use the 3 original colors. For consistency, the colors should be #FFFFFF, #AAAAAA and #555555, the font should be `Xerox Sans Serif Wide, Bold`, and there should be 5px borders around the thumbnails.
> When saving the images, ensure "Save Background Color" and "Save Resolution" are checked
 8. Create the menu using spumux and `menu.xml`. `outlinewidth` can be adjusted to ensure the buttons are properly autodetected (if there are too many buttons, it should be set to a larger value).
 ```sh
 spumux menu.xml < menu.mpg > menu_final.mpg
 ```
 Lines starting with `INFO: Autodetect` indicate a button, there should be as many of these as buttons.


## Author the DVD

`dvd.xml` is a good default if there's only one film, with one video and one subtitle track.
`dvd_multiple.xml` is an example for if you have multiple films and a menu.

```sh
export VIDEO_FORMAT=PAL
dvdauthor -o dvd -x dvd.xml
```
`-o` gives the directory the dvd will be created in, it should not yet exist.

## Test the DVD

If it doesn't have a menu, this works:
```sh
mplayer -dvd-device dvd/ dvd://1
```
Otherwise, use xine:
```sh
xine dvd:/full/path/to/dvd/VIDEO_NS/
```

## Create the disk image file
```sh
mkisofs -dvd-video -udf -V "Movie name" -o dvd.iso dvd/
```

## Burn the DVD
```sh
cdrecord -v dev=/dev/sr0 dvd.iso
```

## TODO

Image slideshow with looping video of each image? 



