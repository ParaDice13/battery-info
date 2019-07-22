# !/bin/bash
#
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.
#
# DEPENDENCIES: upower, notify-osd
#
# This script is best used in conjunction with a custom key combination
#

# SETTINGS
symbolicicons="false" # Switch between default and symbolic/tray icons.
commandlineonly="false" # Disable pop-up notification via notify-send.

# Percentage and load level
powerinfo=$(upower -i $(upower -e | grep 'BAT')) # upower text output with all the information on the battery
percentage=$(echo "$powerinfo" | grep -Po 'percentage:\s*\K(\d+)') # percentage of energy remaining
if [ "$(echo "$powerinfo" | grep -Po 'state:\s*\K(.*)')" == "charging" ] ; then
	time="$(echo "$powerinfo" | grep -Po 'time to full:\s*\K(.*)')" # time remaining until battery fully charged
	info="Charging, time until full: $time"
else
	time="$(echo "$powerinfo" | grep -Po 'time to empty:\s*\K(.*)')" # time remaining until battery empty
	info="Discharging, time remaining: $time"
fi
icon="$(echo "$powerinfo" | grep -Po "icon-name:\s*'\K([a-z-]+)")" # icon name
if [ "$symbolicicons" == "false" ] ; then
	icon="${icon%-symbolic}"
fi

# Output
msg="Battery level is at: $percentage%%\n$info"
if [ "$commandlineonly" == "false" ]; then
	notify-send -i "$icon" "Energy" "$msg"
fi
printf "$msg\n"
