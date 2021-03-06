#!/usr/bin/env bash
# modulate the themes colors arbitrarily
# GPL 2.0
# Joe Shields
# 2020-01-24

### Usage ###
# ./modulate.sh THEMENAME BRIGHTNESS,SATURATION,HUESHIFT

### Synopsis ###
# This is just a wrapper for modulation using ImageMagick.
# It uses the same syntax as the -modulate argument for `convert`.
# The hue shift is a percentage from 0 to 200, not a number of degrees.
# So, 100 does nothing, while 0 and 200 shift to the opposite hue.
# It's *strongly recommended* that you don't use spaces in the theme name!

### Useful Hues ###
# red...............0
# orange            15
# yellow............33
# green             66
# cyan (original)...100
# blue              133
# purple............150
# magenta           166
# red...............200

### Examples ###
# effectively copy the theme:
# ./modulate Neon_Thicc_copy 100,100,100

# shift the hue from cyan to red:
# ./modulate Neon_Thicc_red 100,100,200

# remove all saturation:
# ./modulate Neon_Thicc_white 100,0,100

# make everything half as bright:
# ./modulate Neon_Thicc_dark 50,100,100

modulation=$2
dirName=$1

# create a directory for the new theme
mkdir -p "../$dirName/xfwm4"

for f in `ls xfwm4/*.xpm` # for each pixmap
do
    # if it's an existant regular file that isn't a symlink
    if [ -f "$f" -a ! -h "$f" ] 
    then # convert it and place it in the new theme
        convert \
            -define modulate:colorspace=HSB \
            "$f" \
            -modulate "$modulation" \
            "../$dirName/$f"
    else # copy it into the new theme
        cp -n --no-dereference "$f" "../$dirName/$f"
    fi
done
# copy the theme configuration
cp -n xfwm4/themerc "../$dirName/xfwm4/themerc"
# copy the miscellaneous files
cp -n COPYING CREDITS modulate.sh README.md "../$dirName/"
