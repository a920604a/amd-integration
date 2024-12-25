#!/bin/bash

LOG_FILE="/var/log/mouse_limit.log"

# 腳本開始時，先設定滑鼠限制的範圍，以主要螢幕為基準
# 可以使用 xrandr 命令來獲取主要螢幕的解析度和位置信息
screen_info=$(xrandr --query | grep " primary " | awk '{print $4}')
screen_name=$(xrandr --query | grep " primary " | awk '{print $1}')
screen_width=$(echo "$screen_info" | cut -d "x" -f1)
screen_height=$(echo "$screen_info" | cut -d "x" -f2)
screen_x=$(echo "$screen_info" | cut -d "+" -f2)
screen_y=$(echo "$screen_info" | cut -d "+" -f3)
echo "$(date) $0 - 取主要螢幕的解析度和位置信息 screen_x $screen_x screen_y $screen_y screen_width $screen_width screen_height $screen_height" >> "$LOG_FILE"

# 滑鼠限制範圍的左上角座標
x_min=$screen_x
y_min=$screen_y
# 滑鼠限制範圍的右下角座標
x_max=$((screen_x + screen_width))
y_max=$((screen_y + screen_height))

echo "$(date) $0 - 滑鼠限制範圍的右下角座標 x_max $y_max x_max $y_max" >> "$LOG_FILE"
# 執行 xdotool 命令來限制滑鼠活動範圍
while true; do

    mouse_location=$(xdotool getmouselocation)
    x=$(echo "$mouse_location" | awk '{print $1}' | cut -d ":" -f2)
    y=$(echo "$mouse_location" | awk '{print $2}' | cut -d ":" -f2)
    # echo "$(date) $0 -執行 xdotool 命令來限制滑鼠活動範圍 $x $y" >> "$LOG_FILE"
    if [[ $x -lt $x_min || $x -gt $x_max || $y -lt $y_min || $y -gt $y_max ]]; then
        # 如果滑鼠位置在限制範圍之外，將滑鼠位置重設到限制範圍內
        if [ $x -lt $x_min ]; then 
            xfix=$(echo "$x_min")
        elif [ $x -gt $x_max ]; then 
            xfix=$(echo "$x_max")
        else
            xfix=$(echo "$x")
        fi

        if [ $y -lt $y_min ]; then 
            yfix=$(echo "$y_min") 
        elif [ $y -gt $y_max ] ; then 
            yfix=$(echo "$y_max")
        else
            yfix=$(echo "$y")
        fi

        # echo "$x" "$y" "$xfix" "$yfix"
        xdotool mousemove --screen "$screen_name" $xfix $yfix

        echo "$(date) $0 - mousemove --screen  $xfix $yfix" >> "$LOG_FILE"
        # xdotool mousemove $(($($x<$x_min?$x_min:$x>$x_max?$x_max:$x) + $screen_x)) $(($($y<$y_min?$y_min:$y>$y_max?$y_max:$y) + $screen_y))
    fi
done
