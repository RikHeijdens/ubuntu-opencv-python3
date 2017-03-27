#!/usr/bin/env bash
# From http://docs.opencv.org/3.2.0/d7/d9f/tutorial_linux_install.html
set -e

# Install dependencies for OpenCV
# Compiler:
apt-get install -y --no-install-recommends build-essential curl ca-certificates
# Required dependencies:
apt-get install -y --no-install-recommends cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
# Optional dependencies:
apt-get install -y --no-install-recommends python3-dev python3-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
# Install ffmpeg and friends:
apt-get install -y --no-install-recommends ffmpeg x264

# Download the OpenCV package
curl -OL "https://github.com/opencv/opencv/archive/$1.tar.gz"

# Untar
tar -zxvf $1.tar.gz
rm -rf $1.tar.gz
cd opencv-$1/
rm -rf build/
mkdir build/
cd build/

# Configure
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D PYTHON3_EXECUTABLE=/usr/bin/python3 -D PYTHON_INCLUDE_DIR=/usr/include/python3.5 -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.5m -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.5m.so -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ ..

# Build
make -j$(($(nproc) + 1))

# Install
make install

echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
ldconfig

cd ../../
rm -rf opencv-$1/

echo "OpenCV $1 installed"