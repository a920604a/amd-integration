#!/bin/bash

# 定義進程名稱
PROCESS_NAME="detect_terminate"

# 查找進程並終止它
pid=$(pgrep -f "$PROCESS_NAME")  # 使用 pgrep 查找進程的 PID
if [ -n "$pid" ]; then  # 如果找到了進程
    echo "找到進程 $PROCESS_NAME，PID: $pid，正在終止..."
    kill $pid  # 使用 kill 命令終止進程
    echo "進程已終止。"
else
    echo "未找到進程 $PROCESS_NAME。"
fi
