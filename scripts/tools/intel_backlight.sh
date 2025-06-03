#!/bin/sh

INPUT="$1"
INTEL_PATH="/sys/class/backlight/intel_backlight"
PATH_BRIGHTNESS="${INTEL_PATH}/brightness"
VALUE_CURRENT=$(cat "${PATH_BRIGHTNESS}")
VALUE_MAX=$(cat "${INTEL_PATH}/max_brightness")
STEPS=$((VALUE_MAX / 100))
NEW_VALUE=$((VALUE_CURRENT + (STEPS * INPUT)))

if [ $NEW_VALUE -le 0 ]; then
	NEW_VALUE=0
elif [ $NEW_VALUE -ge "${VALUE_MAX}" ]; then
	NEW_VALUE=$VALUE_MAX
fi

echo "${NEW_VALUE}"
echo "${NEW_VALUE}" > "${PATH_BRIGHTNESS}"
