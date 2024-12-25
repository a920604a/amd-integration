#!/bin/bash

set -x 

LOG_FILE="${HOME}/.config/autostart/detect-lid.log"
source /usr/local/bin/terminate_process_and_children.sh

# 無窮迴圈，持續檢測
while true
do
    # 啟動 acpi_listen 並將輸出傳遞給 while 迴圈
    acpi_listen | while IFS= read -r event
    do
        # 判斷是否為螢幕閉合事件
        if [[ $event == "button/lid LID close" ]]; then
            terminate_process_and_children "amd.x86_64" 
            echo "$(date) $0 - 螢幕閉合事件發生" >> "$LOG_FILE"            
        fi
    done
done
