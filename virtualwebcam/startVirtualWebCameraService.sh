#! /bin/bash

SERVICE_NAME="virtual-webCam.service"
LOG_FILE="/var/log/webCam/webCam.log"
variable_name="USB_TRIGGER"
DEFAULT_VALUE="0"


if grep -q "^$variable_name=" /etc/environment; then
    echo "$(date) $0 - 變數 $variable_name 已存在." >> "$LOG_FILE"
else
    # 如果不存在，新增並設定為預設值
    echo "$variable_name=$DEFAULT_VALUE" >> /etc/environment
    echo "$(date) $0 - 已新增變數 $variable_name 並設定為 $DEFAULT_VALUE." >> "$LOG_FILE"
fi


if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$(date) $0 - $SERVICE_NAME 已經處於活動狀態，無需重新啟動。">> "$LOG_FILE"
else
    # 重新啟動服務
    systemctl restart "$SERVICE_NAME"
    echo "$(date) $0 - 重新啟動 $SERVICE_NAME" >> "$LOG_FILE"
    sleep 1
    

    # 使用變數
    source /etc/environment
    virtual_dev_name_value="$VIRTUAL_DEV_NAME"
    echo "$(date) $0 - Virtual Dev Name from /etc/environment: $virtual_dev_name_value" >> "$LOG_FILE"

fi