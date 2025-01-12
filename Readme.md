# 應用程式與依賴服務自動化部署腳本

此專案包含一個自動化部署腳本 `install.sh`，用於安裝應用程式 AMD 及相關依賴服務，並確保安裝狀態與驗證過程的準確性與可追溯性。部署腳本支援多個安裝檢查點，可根據需求指定安裝的組件。

## 主要功能

- **多模組安裝**：支援安裝 NVIDIA 驅動、CUDA、cuDNN、TensorRT 等核心依賴，以及 AMD 應用程式與其相關服務。
- **錯誤追蹤與紀錄**：每個模組的安裝與驗證過程均記錄詳細的狀態與耗時，並將錯誤資訊寫入日誌。
- **靈活配置**：可選擇單獨安裝特定模組，或透過 `all` 參數一次安裝所有模組。

## 使用說明

### 安裝腳本

```bash
#! /bin/bash
set -x

# 使用方法
print_help() {
    echo "使用方法: $0 <username> <checkpoint1> <checkpoint2> ..."
    echo "    username: 使用者名稱"
    echo "    checkpoint: 指定要安裝的套件"
    echo "    支援的 checkpoint 包括: "
    echo "        nvidia_driver, cuda, cudnn, dependencies, opencv,"
    echo "        tensorRt, virtualwebcam, amd_services, amd, eye_tracking,"
    echo "        detect, launcher"
    echo ""
    echo "範例:"
    echo "    $0 user1 nvidia_driver cuda cudnn"
}

# 例子見 install.sh 文件
```

### 安裝流程

1. 請確認腳本的執行權限已開啟：
    ```bash
    chmod +x install.sh
    ```

2. 執行安裝：
    ```bash
    ./install.sh <username> <checkpoint1> <checkpoint2> ...
    ```
    例如：
    ```bash
    ./install.sh user1 all
    ```

3. 安裝完成後，可檢查生成的日誌檔案 `install_state.txt` 確認狀態。

### 功能模組列表

- **nvidia_driver**: 安裝 NVIDIA 驅動，並進行版本驗證。
- **cuda**: 安裝 CUDA，驗證 `nvcc --version` 是否正確。
- **cudnn**: 安裝 cuDNN，適用於深度學習框架。
- **opencv**: 安裝 OpenCV，驗證影像處理功能。
- **tensorRt**: 安裝 TensorRT，加速推理工作負載。
- **virtualwebcam**: 安裝虛擬攝像頭模組。
- **amd_services**: 安裝與 AMD 應用相關的後台服務。
- **amd**: 部署 AMD 應用程式至指定用戶桌面。
- **eye_tracking**: 安裝並配置眼球追蹤模組。
- **detect**: 安裝 LID 檢測與監控服務。
- **launcher**: 部署啟動器以整合所有模組。

## 部署架構

該腳本的設計支援以模組化方式部署應用程式，並確保安裝環境的安全與穩定性。
