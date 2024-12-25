#!/bin/bash

LOG_FILE="${HOME}/.config/autostart/detect-lid.log"
exec_file="${HOME}/.config/autostart/detectLID.sh"
desktop_file="${HOME}/.config/autostart/detect-lid.desktop"

if [[ -f $LOG_FILE ]]; then
    rm -rf $LOG_FILE
fi

if [[ -f $exec_file ]]; then
    rm -rf $exec_file
fi


if [[ -f $desktop_file ]]; then
    rm -rf $desktop_file
fi

echo "Done to uninstall DetectLID"