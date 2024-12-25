#!/bin/bash 
set -x

echo "install {$0}"

username=$1

version="8.6.1.6"
arch=$(uname -m)
cuda="cuda-12.0"
mv packages/TensorRT-${version}.Linux.${arch}-gnu.${cuda}.tar.gz .
tar -xzvf TensorRT-${version}.Linux.${arch}-gnu.${cuda}.tar.gz

# https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html#installing-tar
echo "export LD_LIBRARY_PATH=$(pwd)/TensorRT-${version}/lib:\$LD_LIBRARY_PATH" >> /home/$username/.bashrc




# python3 -m pip install tensorrt-*-cp3x-none-linux_x86_64.whl
python3 -m pip install TensorRT-${version}/python/tensorrt-*-cp$(python3 -c "import sys; print(f'{sys.version_info.major}{sys.version_info.minor}')")-none-linux_x86_64.whl


python3 -m pip install TensorRT-${version}/python/tensorrt_lean-*-cp$(python3 -c "import sys; print(f'{sys.version_info.major}{sys.version_info.minor}')")-none-linux_x86_64.whl
python3 -m pip install TensorRT-${version}/python/tensorrt_dispatch-*-cp$(python3 -c "import sys; print(f'{sys.version_info.major}{sys.version_info.minor}')")-none-linux_x86_64.whl



python3 -m pip install TensorRT-${version}/uff/uff-0.6.9-py2.py3-none-any.whl

python3 -m pip install TensorRT-${version}/graphsurgeon/graphsurgeon-0.4.6-py2.py3-none-any.whl

python3 -m pip install TensorRT-${version}/onnx_graphsurgeon/onnx_graphsurgeon-0.3.12-py2.py3-none-any.whl


