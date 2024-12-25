#!/bin/bash

echo "$0 $1 $2"

DEV_SH_FILE="$1/start_with_camera_check.sh"
SERVICE_FILE="$1/launcher.x86_64.desktop"
AUTOSTART_DIR="/home/$2/.config/autostart"

# 檢查目錄是否存在，如果不存在則建立
if [ ! -d "$AUTOSTART_DIR" ]; then
    mkdir -p "$AUTOSTART_DIR"
fi

# 複製檔案到目標位置
cp "$DEV_SH_FILE" "$AUTOSTART_DIR/"
cp "$SERVICE_FILE" "$AUTOSTART_DIR/"


echo "Done to Install Launcher"