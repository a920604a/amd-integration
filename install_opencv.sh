#!/bin/bash

echo "install {$0}"

sudo apt update 
sudo apt-get install -y \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libpostproc-dev \
    libswscale-dev \
    libeigen3-dev \
    libtbb-dev \
    libgtk2.0-dev \
    pkg-config


git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib/
git checkout 4.7.0
cd ../opencv/
git checkout 4.7.0

# https://github.com/opencv/opencv/issues/23893
# 修改 normalize_bbox.hpp 文件
sed -i '114s/if (weight != 1.0)/if (weight != static_cast<T>(1.0))/g' modules/dnn/src/cuda4dnn/primitives/normalize_bbox.hpp

# 修改 region.hpp 文件
sed -i '124s/if (nms_iou_threshold > 0)/if (nms_iou_threshold > static_cast<T>(0))/g' modules/dnn/src/cuda4dnn/primitives/region.hpp



mkdir build && cd build
# cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules -DOPENCV_GENERATE_PKGCONFIG=ON -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DWITH_QT=OFF -DWITH_OPENGL=OFF -DOPENCV_ENABLE_NONFREE=ON -DINSTALL_PYTHON_EXAMPLES=ON -DINSTALL_C_EXAMPLES=ON -DBUILD_EXAMPLES=ON -DWITH_CUDA=ON -DWITH_CUDNN=ON -DOPENCV_DNN_CUDA=ON -DCUDA_FAST_MATH=1 -DCUDA_ARCH_BIN="5.3,6.2,7.2,7.5,8.6" -DCUDA_VERSION="12.1" -DCUDA_ARCH_PTX="" -DPYTHON3_EXECUTABLE=$(which python3) -DPYTHON_DEFAULT_EXECUTABLE=$(which python3) -DPYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") -DPYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")

cmake .. \
        -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -DWITH_CUDA=ON \
        -DWITH_CUDNN=ON \
        -DOPENCV_DNN_CUDA=ON \
        -DENABLE_FAST_MATH=ON \
        -DCUDA_FAST_MATH=ON \
        -DCUDA_ARCH_BIN="5.2 5.3 6.0 6.1 6.2 7.0 7.2 7.5 8.0 8.6" \
        -DCUDA_ARCH_PTX="8.6" \
        -DWITH_CUBLAS=ON \
        -DOPENCV_ENABLE_NONFREE=ON \
        -DWITH_GSTREAMER=OFF \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DOPENCV_GENERATE_PKGCONFIG=ON \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_opencv_apps=ON \
        -DWITH_LAPACK=OFF \
        ..
make -j16
sudo make install

# opencv_version