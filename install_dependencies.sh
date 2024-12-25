#!/bin/bash

echo "install {$0}"

sudo apt install --no-install-recommends --no-install-suggests -y python3-pip python3-dev git \
    cmake make wget build-essential

sudo apt install --no-install-recommends --no-install-suggests -y ffmpeg v4l-utils xdotool libspdlog-dev



wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.18-stable.tar.gz 
tar xf libsodium-1.0.18-stable.tar.gz
cd libsodium-stable
./configure
make && make check
sudo make install


sudo apt install --no-install-recommends --no-install-suggests -y libzmq3-dev
git clone https://github.com/zeromq/zmqpp.git
cd zmqpp
mkdir build && cd build
cmake ..
make -j 16
sudo make install


