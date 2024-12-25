#!/bin/bash

echo "$0 $1 $2"

# 將需要複製的檔案路徑定義為變數
DEV_SH_FILE="$1/detectMonitor.sh"
SERVICE_FILE="$1/detect-monitor.desktop"
AUTOSTART_DIR="/home/$2/.config/autostart"

# 檢查目錄是否存在，如果不存在則建立
if [ ! -d "$AUTOSTART_DIR" ]; then
    mkdir -p "$AUTOSTART_DIR"
fi

# 複製檔案到目標位置
cp "$DEV_SH_FILE" "$AUTOSTART_DIR/"
cp "$SERVICE_FILE" "$AUTOSTART_DIR/"


echo "Done to Install DetectMonitor"