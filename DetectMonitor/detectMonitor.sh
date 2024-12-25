#!/bin/bash

LOG_FILE="${HOME}/.config/autostart/detect-monitor.log"
source /usr/local/bin/terminate_process_and_children.sh


while true
do
    # 查詢顯示伺服器的狀態
    display_status=$(xset q | grep "Monitor is")
    # 判斷顯示伺服器的狀態，可根據需要修改條件
    if [[ "$display_status" == *"Monitor is Off"* ]]; then
        terminate_process_and_children "amd.x86_64" 
        echo "$(date) $0 - Monitor is Off" >> "$LOG_FILE"
    fi
    sleep 1
done