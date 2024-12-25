#!/bin/bash


sudo cp terminate_process_and_children.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/terminate_process_and_children.sh


# DETCTED USB AND TRIGGER VIRTUAL WEM CAMERA SERVICE
sudo cp DetectUSB/99-usb-monitor.rules /etc/udev/rules.d  
sudo chmod +x /etc/udev/rules.d/99-usb-monitor.rules
sudo cp DetectUSB/detectUSB.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/detectUSB.sh

# DETECTED HDMI AND STRAT MOUSE LIMIT SERVICE
sudo cp DetectHDMI/99-hdmi-monitor.rules /etc/udev/rules.d  
sudo chmod +x /etc/udev/rules.d/99-hdmi-monitor.rules
sudo cp DetectHDMI/detectHDMI.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/detectHDMI.sh

sudo udevadm control --reload-rules

sudo cp Mouse_limit/mouse_limit.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/mouse_limit.sh
