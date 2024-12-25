#!/bin/bash

# 获取当前正在运行的内核版本
desired_kernel_version=$(uname -r)

# 获取所有匹配的内核版本在GRUB菜单中的序号和版本号
kernel_info=$(awk -v ver="$desired_kernel_version" '$0 ~ ver {print NR-1, $0}' /boot/grub/grub.cfg)

if [ -z "$kernel_info" ]; then
    echo "找不到版本号为 $desired_kernel_version 的内核。"
    exit 1
fi

# 打印所有匹配的内核序号和版本号
echo "匹配的内核序号和版本号："
echo "$kernel_info"

# 选择第一个匹配的内核序号作为默认内核
default_kernel_index=$(echo "$kernel_info" | head -n 1 | awk '{print $1}')

# 更新GRUB默认内核设置
sudo sed -i "s/^GRUB_DEFAULT=.*/GRUB_DEFAULT=\"$default_kernel_index\"/" /etc/default/grub

# 更新GRUB配置
sudo update-grub

echo "已将内核版本 $desired_kernel_version 设置为默认内核。"
