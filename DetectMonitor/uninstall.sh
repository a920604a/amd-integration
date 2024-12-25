#!/bin/bash

LOG_FILE="${HOME}/.config/autostart/detect-monitor.log"
exec_file="${HOME}/.config/autostart/detectMonitor.sh"
desktop_file="${HOME}/.config/autostart/detect-monitor.desktop"

if [[ -f $LOG_FILE ]]; then
    rm -rf $LOG_FILE
fi

if [[ -f $exec_file ]]; then
    rm -rf $exec_file
fi


if [[ -f $desktop_file ]]; then
    rm -rf $desktop_file
fi

echo "Done to uninstall DetectMonitor"