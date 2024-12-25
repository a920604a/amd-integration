

## Describe
This service provides creating virtual web camera 
## Install 
```shell
sudo ./install.sh
```


## How to use
`sudo systemctl status virtual-webCam.service` find which virtual camera you create

eg: after `sudo systemctl status virtual-webCam.service`, found log `[LOOK] Capture streaming /dev/video4 to /dev/video101` . Therefore, I know I create `/dev/video101` virtual Web camera.


## Uninstall 
```shell
sudo ./uninstall.sh
```


log file put on `/var/log/webCam/webCam.log` 
