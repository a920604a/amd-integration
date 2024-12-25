# terminate_process_and_children.sh

function terminate_process_and_children() {
    local process_name="$1"
    local log_file="$LOG_FILE"  # 使用全局變數

    if pgrep -o -f "$process_name" > /dev/null; then
        local pid=$(pgrep -o -f "$process_name")

        # 使用 pkill 終止所有子進程
        pkill -P $pid

        # 等待一段時間，讓子進程有機會正常退出
        sleep 5

        # 如果子進程仍在運行，使用 SIGKILL 信號終止
        if pgrep -o -f "$process_name" > /dev/null; then
            pkill -9 -P $pid
        fi

        # 使用 SIGTERM 信號終止父進程
        kill -TERM $pid

        # 等待一段時間，讓父進程有機會正常退出
        sleep 5

        # 如果父進程仍在運行，使用 SIGKILL 信號終止
        if pgrep -o -f "$process_name" > /dev/null; then
            pkill -9 -f "$process_name"
        fi

        # 列印出被終止的所有進程及其子進程的 PID
        echo "$(date) $0 - 刪除 $process_name 及其所有子進程，被終止的進程 PID: $pid" >> "$log_file"
        pkill -f mouse_limit.sh
        pkill -f executable
        sleep 2
        poweroff
    else
        echo "$(date) $0 - $process_name 進程不存在，無需刪除。" >> "$log_file"
    fi
}

