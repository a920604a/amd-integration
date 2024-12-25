#!/bin/bash

LOG_FILE="/var/log/detectHDMI.log"

source /usr/local/bin/terminate_process_and_children.sh

function checkConnectedStatus {
    ret=0

    # 遍歷每個子目錄
    for cardDirectory in "$1"/card*; do
        # 構建 status 檔案的完整路徑
        statusFilePath="$cardDirectory/status"

        # 檢查是否存在 status 檔案
        if [ -e "$statusFilePath" ]; then
            # 讀取 status 內容
            status=$(cat "$statusFilePath" | tr -d '[:space:]')  

            # 排除 card0 且檢查是否為 "connected"
            if [[ "$status" == "connected" ]]; then
                echo "$(date) $0 顯示卡 $cardDirectory 連接狀態: $status" >> "$LOG_FILE"
                ((ret=ret+1))

            fi
        fi
    done
    echo "$(date) $0 連接 NUMBER: $ret" >> "$LOG_FILE"

    if [ "$ret" -ge 2 ]; then
        echo true
    else
        echo false
    fi

}


# 使用方式：
result=$(checkConnectedStatus "/sys/class/drm" )

if [ "$result" = true ]; then
    echo "$(date) $0 至少有一個顯示卡是連接的" >> "$LOG_FILE"
else
    echo "$(date) $0 所有顯示卡都未連接" >> "$LOG_FILE"
    terminate_process_and_children "amd.x86_64"
    # invoke other processs    
fi