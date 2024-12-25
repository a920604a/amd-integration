#!/bin/bash

# 將需要複製的檔案路徑定義為變數
DEV_SH_FILE="virWebCam.sh"
SERVICE_FILE="virtual-webCam.service"

# 複製檔案到目標位置
cp "$DEV_SH_FILE" /usr/bin/
cp "$SERVICE_FILE" /lib/systemd/system/
cp startVirtualWebCameraService.sh /opt/amd/
# 啟用與啟動服務
systemctl enable virtual-webCam.service
# systemctl start virtual-webCam.service
