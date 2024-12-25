#!/bin/bash

# 設定變數
build_directory="$HOME/Desktop/amd/"
executable_name="launcher.x86_64"

# 進入 build 目錄
cd "$build_directory"

version="8.6.1.6"
export LD_LIBRARY_PATH=$HOME/Desktop/Install_packages/TensorRT-${version}/lib:$LD_LIBRARY_PATH

# 執行 launcher.x86_64
./"$executable_name"
