#!/bin/bash
INIFILE=/home/te/tuxedo_keyboard.ini
COLOR=$(awk -F "=" '/color/ {print $2}' $INIFILE)
BRIGHTNESS=$(awk -F "=" '/brightness/ {print $2}' $INIFILE)
echo $COLOR > /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/color_string
echo $BRIGHTNESS > /sys/devices/platform/tuxedo_keyboard/uw_kbd_bl_color/brightness
echo 'options tuxedo-keyboard mode=0 color='$COLOR' brightness='$BRIGHTNESS > /etc/modprobe.d/tuxedo_keyboard.conf
