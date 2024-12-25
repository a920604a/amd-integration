#!/bin/bash

log_folder="/var/log/webCam/"
exec_file="/usr/bin/virWebCam.sh"
service_file="/lib/systemd/system/virtual-webCam.service"

if systemctl is-active --quiet virtual-webCam.service; then
    systemctl stop virtual-webCam.service
fi

systemctl disable virtual-webCam.service
modprobe --remove v4l2loopback

if [[ -f $exec_file ]]; then
    rm -rf $exec_file
fi

if [[ -f $service_file ]]; then
    rm -rf $service_file
fi

if [[ -d $log_folder ]]; then
    rm -rf $log_folder
fi

sed -i '/^VIRTUAL_DEV_NAME=/d' /etc/environment
sed -i "/^USB_TRIGGER=/d" /etc/environment

systemctl daemon-reload
