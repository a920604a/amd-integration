#!/bin/bash

sudo rm -rf /etc/udev/rules.d/99-usb-monitor.rules
sudo rm -rf /etc/udev/rules.d/99-hdmi-monitor.rules

sudo rm -rf /usr/local/bin/detectUSB.sh
sudo rm -rf /var/log/detectUSB.log

sudo rm -rf /usr/local/bin/detectHDMI.sh
sudo rm -rf /var/log/detectHDMI.log

sudo rm -rf /usr/local/bin/mouse_limit.sh
sudo rm -rf /var/log/mouse_limit.log

sudo rm -rf /usr/local/bin/terminate_process_and_children

cd virtualwebcam/
sudo ./uninstall.sh