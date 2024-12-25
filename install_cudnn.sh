#!/bin/bash

set -x
# distro=ubuntu2204
# arch=x86_64
# sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/3bf863cc.pub


mv packages/cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar.xz .
# wget https://developer.nvidia.com/downloads/compute/cudnn/secure/8.9.7/local_installers/12.x/cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar.xz/
tar -xvf cudnn-linux-x86_64-8.9.7.29_cuda12-archive.tar.xz
# tar -xvf cudnn-linux-x86_64-8.9.6.50_cuda12-archive.tar.xz


sudo cp cudnn-*-archive/include/cudnn*.h /usr/local/cuda/include 
sudo cp -P cudnn-*-archive/lib/libcudnn* /usr/local/cuda/lib64 
sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

