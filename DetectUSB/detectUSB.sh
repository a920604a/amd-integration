#!/bin/bash

LOG_FILE="/var/log/detectUSB.log"
SERVICE_NAME="virtual-webCam.service"
PROCESS_NAME="amd.x86_64"

source /usr/local/bin/terminate_process_and_children.sh

if [ "$ACTION" == "bind" ]; then
    # USB 插入時的處理邏輯
    # notify-send "USB HUB 插入"
    # echo "inserted" | wall
    
    echo "$(date) $0 - USB HUB 插入" >> "$LOG_FILE"
    # 等待 3 秒
    sleep 3
    
    # 重新啟動服務
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "$(date) $0 - $SERVICE_NAME 已經處於活動狀態，無需重新啟動。">> "$LOG_FILE"
    else
        # 重新啟動服務
        systemctl restart "$SERVICE_NAME"
        echo "$(date) $0 - 重新啟動 $SERVICE_NAME" >> "$LOG_FILE"

    fi
    
elif [ "$ACTION" == "remove" ]; then
    # USB 拔出時的處理邏輯
    # notify-send "USB HUB 拔出"
    # echo "removed" | wall

    


    echo "$(date) $0 - USB HUB 拔出" >> "$LOG_FILE"


    terminate_process_and_children "amd.x86_64"

    # 判斷服務是否處於活動狀態
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        # 停止服務
        systemctl stop "$SERVICE_NAME"
        echo "$(date) $0 - 停止 $SERVICE_NAME - $(date)" >> "$LOG_FILE"
    else
        echo "$(date) $0 - $SERVICE_NAME 已經處於停止狀態，無需再次停止。">> "$LOG_FILE"
    fi
fi