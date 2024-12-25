#!/bin/bash

LOG_FILE="/var/log/webCam/webCam.log"
variable_name="USB_TRIGGER"

create_log_directory() {
    if [ -d "/var/log/webCam" ]; then
        echo "$(date) $0 - /var/log/webCam exists" >> "$LOG_FILE"
    else
        mkdir /var/log/webCam
        touch $LOG_FILE
        echo "$(date) $0 - Successfully created log file" >> "$LOG_FILE"
    fi
}

install_if_not_package() {
    REQUIRED_PKGS=("v4l-utils" "ffmpeg")

    for pkg in "${REQUIRED_PKGS[@]}"; do
        PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $pkg | grep "install ok installed")
        echo "$(date) $0 - Checking for $pkg: $PKG_OK" >> "$LOG_FILE"
        if [ "" = "$PKG_OK" ]; then
            echo "$(date) $0 - Package $pkg not found. Installing $pkg." >> "$LOG_FILE"
            apt-get --yes install "$pkg"
        else
            echo "$(date) $0 - $pkg is already installed" >> "$LOG_FILE"
        fi
    done
}

scan_devices() {
    local list=""
    v=$(ls "/dev/" | grep "video*")
    for i in $v; do
        list+="${i} "
    done
    eval "$1='$list'"
}

get_max_video_number() {
    local max_number=0
    v=$(ls "/dev/" | grep "video*")
    for i in $v; do
        number=$(echo "$i" | sed 's/video//g')
        if [[ $number -gt $max_number ]]; then
            max_number=$number
        fi
    done
    max_number=$((max_number+1))
    echo "$max_number"
}


algo(){
    local arr=( ${list2[@]} )
    for i in ${list1[@]}; do
        for j in ${!arr[@]}; do   
            if [[ "$i" == ${arr[$j]} ]]; then
                unset arr["$j"]
                break
            fi
        done
    done
    # printf '%s ' "${arr[@]}"; echo
    local devnames=("/dev/${arr[@]}")
    echo "$(date) $0 - VIRTUAL_DEV_NAME=${devnames[@]}" >> "$LOG_FILE"
    sed -i "s/^$variable_name=.*/$variable_name=1/" /etc/environment
    echo "VIRTUAL_DEV_NAME=${devnames[@]}" | sudo tee -a /etc/environment
    echo "$(date) $0 - [LOOK] Capture streaming ${specific} to ${devnames[@]} " >> "$LOG_FILE"

    ffmpeg -f v4l2 -i $specific -vf format=yuyv422 -f v4l2 "${devnames[@]}" 2>> $LOG_FILE
}


create_log_directory
install_if_not_package

pat=$(v4l2-ctl --list-devices | grep -5 -A4 'RV1108.' | sed 's/RV1108: UVC DEPTH (usb-0000:00:14.0-3)://g')

specific=""
for i in $pat; do
    var=$(v4l2-ctl -d $i --list-formats-ext | grep "MJPG")
    if [[ "" != $var ]]; then
        specific=$i
        break
    fi
done

# Add a check for an empty specific before proceeding
if [ -z "$specific" ]; then
    echo "$(date) $0 - No specific device found. Exiting script." >> "$LOG_FILE"
    exit 1
fi



echo "$(date) $0 - Specific device: $specific">> "$LOG_FILE"

modprobe --remove v4l2loopback

list1=""
scan_devices list1
echo "$(date) $0 - [BEFORE] $list1" >> "$LOG_FILE"

modprobe v4l2loopback exclusive_caps=1 card_label="VirtualWebcam" max_buffers=8 video_nr=$(get_max_video_number)

list2=""
scan_devices list2
echo "$(date) $0 - [AFTER] $list2" >> "$LOG_FILE"

# Check if list1 is not equal to list2 before executing algo
if [ "$list1" != "$list2" ]; then
    algo
    RESULT="${VIRTUAL_DEV_NAME[@]}"
    echo "devnames: $RESULT" >> "$LOG_FILE"
else
    echo "$(date) $0 - No change in video devices. Not performing further actions." >> "$LOG_FILE"
fi
