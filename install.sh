#! /bin/bash
set -x

# 印出說明信息
print_help() {
    echo "使用方法: $0 <username> <checkpoint1> <checkpoint2> ..."
    echo "    username: 使用者名稱"
    echo "    checkpoint: 指定要安裝的套件 (nvidia_driver, cuda, cudnn, dependencies, opencv, tensorRt, virtualwebcam, amd_services, amd, eye_tracking, detect, launcher)"
    echo ""
    echo "範例:"
    echo "    $0 user1 nvidia_driver cuda cudnn"
}


# 檢查是否有傳遞 --help 參數
if [[ "$@" =~ "--help" || "$@" =~ "-h" ]]; then
    print_help
    exit 0
fi

# 如果沒有參數，則顯示幫助信息
if [ "$#" -lt 2 ]; then
    echo "錯誤: 缺少參數"
    print_help
    exit 1
fi

# 如果傳遞的參數包含 '*'
if [[ "$@" =~ "all" ]]; then
    username=$1
    checkpoint=("nvidia_driver" "cuda" "cudnn" "dependencies" "opencv" "tensorRt" "virtualwebcam" "amd_services" "amd" "eye_tracking" "detect" "launcher")
else
    username=$1
    shift 1
    checkpoint=("$@")
fi



# 函數：安裝軟體並記錄時間
install_with_time_record() {
    echo "----------------------------------------------" >> install_state.txt

    local software_name=$1
    local script_path=$2
    shift 2  # 移除前兩個參數，即 software_name 和 script_path
    local extra_args="$@"  # 保存剩餘的所有參數

    echo "安裝 $software_name...$(date +%Y-%m-%d\ %H:%M:%S)" >> install_state.txt
    start_time=$(date +%s)
    # sudo "$script_path" "$extra_args" && save_state "$software_name"
    # 執行安裝指令，並將輸出重定向到臨時文件
    temp_output=$(mktemp)
    sudo "$script_path" "$extra_args" > "$temp_output" 2>&1
    local status=$?
    if [ $status -eq 0 ]; then
        # 如果指令成功執行，則保存安裝狀態
        save_state "$software_name"
    else
        # 如果指令執行失敗，則將錯誤訊息寫入 install_state.txt
        echo "安裝 $software_name 失敗，錯誤訊息如下：" >> install_state.txt
        cat "$temp_output" >> install_state.txt
    fi
    # 刪除臨時文件
    rm "$temp_output"
    end_time=$(date +%s)
    time_diff=$((end_time - start_time))
    echo "安裝 $software_name 完成，花費時間：$time_diff 秒" >> install_state.txt

    echo "----------------------------------------------" >> install_state.txt
    # 根據退出狀態返回 1 或 0
    return $status
}

# 函數：安裝軟體並記錄時間
install_with_time_record_user() {
    local software_name=$1
    local script_path=$2
    shift 2  # 移除前兩個參數，即 software_name 和 script_path
    local extra_args=("$@")  # 保存剩餘的所有參數
    echo "**************************************" >> install_state.txt

    echo "安裝 $software_name...$(date +%Y-%m-%d\ %H:%M:%S)" >> install_state.txt
    start_time=$(date +%s)
    # sudo -u ${username} "$script_path" "${extra_args[@]}" && save_state "$software_name"
    # 執行安裝指令，並將輸出重定向到臨時文件
    temp_output=$(mktemp)
    sudo -u ${username} "$script_path" "${extra_args[@]}"
    local status=$?
    if [ $status -eq 0 ]; then
        # 如果指令成功執行，則保存安裝狀態
        save_state "$software_name"
    else
        # 如果指令執行失敗，則將錯誤訊息寫入 install_state.txt
        echo "安裝 $software_name 失敗，錯誤訊息如下：" >> install_state.txt
        cat "$temp_output" >> install_state.txt
        echo "==========================================" >> install_state.txt
    fi
    # 刪除臨時文件
    rm "$temp_output"
    end_time=$(date +%s)
    time_diff=$((end_time - start_time))
    echo "安裝 $software_name 完成，花費時間：$time_diff 秒" >> install_state.txt

    echo "**************************************" >> install_state.txt
    # 根據退出狀態返回 1 或 0
    return $status
}


# 函數：驗證軟體並記錄時間
verify_with_time_record() {
    echo "++++++++++++++++++++++++++++++++++" >> install_state.txt
    local software_name=$1
    local verify_command=$2

    echo "驗證 $software_name...$(date +%Y-%m-%d\ %H:%M:%S)" >> install_state.txt
    start_time=$(date +%s)
    check_state "$software_name"
    end_time=$(date +%s)
    time_diff=$((end_time - start_time))
    echo "驗證 $software_name 完成，花費時間：$time_diff 秒" >> install_state.txt

    echo "++++++++++++++++++++++++++++++++++" >> install_state.txt
}



# 保存安裝狀態
save_state() {
    echo "$1: 完成" >> install_state.txt
}

# 檢查安裝狀態
check_state() {
    echo "$1: 驗證" >> install_state.txt
}


# 主邏輯
main() {
    # 檢查並加載之前的安裝狀態
    if [ -e install_state.txt ]; then
        source install_state.txt
    else
        touch install_state.txt
    fi

    # 根據 checkpoint 安裝指定的套件
    for cp in "${checkpoint[@]}"; do
        case $cp in
            "nvidia_driver")
                # 安裝NVIDIA驅動程式
                if ! grep -q "install_nvidia_driver: 完成" install_state.txt; then
                    install_with_time_record "install_nvidia_driver" "./install_nvidia_driver.sh" && reboot
                    exit 0
                fi

                # 驗證 NVIDIA 
                if ! grep -q "install_nvidia_driver: 驗證" install_state.txt; then
                    verify_with_time_record "install_nvidia_driver" "nvidia-smi"
                fi
                ;;
            "cuda")
                # 安裝CUDA
                if ! grep -q "install_cuda: 完成" install_state.txt; then
                    install_with_time_record "install_cuda" "./install_cuda.sh" "${username}" && reboot
                    exit 0
                fi

                # 驗證 CUDA
                if ! grep -q "install_cuda: 驗證" install_state.txt; then
                    verify_with_time_record "install_cuda" "/usr/local/cuda/bin/nvcc --version"
                fi
                ;;
            "cudnn")    
                # 安裝cuDNN
                if ! grep -q "install_cudnn: 完成" install_state.txt; then
                    install_with_time_record "install_cudnn" "./install_cudnn.sh"
                fi
                ;;
            "dependencies")
                # 安裝依賴項
                if ! grep -q "install_dependencies: 完成" install_state.txt; then
                    install_with_time_record "install_dependencies" "./install_dependencies.sh"
                fi
                ;;
            "opencv")
                # 安裝 OPNECV
                if ! grep -q "install_opencv: 完成" install_state.txt; then
                    install_with_time_record "install_opencv" "./install_opencv.sh"
                fi
            
                # 驗證 OPNECV
                if ! grep -q "install_opencv: 驗證" install_state.txt; then
                    verify_with_time_record "install_opencv" "sudo opencv_version"
                fi
                ;;
            "tensorRt")
                # 安裝TensorRT
                if ! grep -q "install_tensorRt: 完成" install_state.txt; then
                    install_with_time_record "install_tensorRt" "./install_tensorRt.sh" "${username}"
                fi
                ;;
            "virtualwebcam")
                # 安裝 virtualwebcam
                if ! grep -q "install_virtualwebcam: 完成" install_state.txt; then
                    install_with_time_record "install_virtualwebcam" "./virtualwebcam/install.sh" "virtualwebcam"
                fi
                ;;
            "amd_services")
                # 安裝 related AMD services 
                if ! grep -q "install_amd_services: 完成" install_state.txt; then
                    install_with_time_record "install_amd_services" "./install_amd.sh"
                fi
                ;;
            "amd")
                # 安裝 AMD
                if ! grep -q "install_amd: 完成" install_state.txt; then
                    install_with_time_record_user "install_amd" "cp" "-r" "./src/build" "/home/${username}/Desktop/amd"
                fi
                ;;
            "eye_tracking")
                # 執行 eye_tracking
                if ! grep -q "eye_tracking: 完成" install_state.txt; then
                    install_with_time_record_user "eye_tracking" "./eye_tracking/install.sh" "$(pwd)/eye_tracking"
                fi
                ;;
            "detect")
                # 執行 detect_LID
                if ! grep -q "detect_LID: 完成" install_state.txt; then
                    install_with_time_record_user "detect_LID" "./DetectLID/install.sh" "$(pwd)/DetectLID" "${username}" 
                fi

                # 執行 DetectMonitor
                if ! grep -q "DetectMonitor: 完成" install_state.txt; then
                    install_with_time_record_user "DetectMonitor" "./DetectMonitor/install.sh" "$(pwd)/DetectMonitor" "${username}" 
                fi
                ;;
            "launcher")
                # 執行 DetectMonitor
                if ! grep -q "Launcher: 完成" install_state.txt; then
                    install_with_time_record_user "Launcher" "./Launcher/install.sh" "$(pwd)/Launcher" "${username}" 
                fi
                ;;
        esac
    done
}

# 執行主邏輯
main
