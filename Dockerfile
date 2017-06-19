FROM python:3.6.1-slim

# Install opencv prerequisites...
RUN apt-get update -qq && apt-get install -y --force-yes \
    curl \
    git \
    g++ \
    autoconf \
    automake \
    build-essential \
    checkinstall \
    cmake \
    pkg-config \
    yasm \
    libtiff5-dev \
    libpng-dev \
    libjpeg-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libdc1394-22-dev \
    libxine2-dev \
    libgstreamer0.10-dev \
    libgstreamer-plugins-base0.10-dev \
    libv4l-dev \
    libtbb-dev \
    libgtk2.0-dev \
    libmp3lame-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    libtool \
    v4l-utils \
    default-jdk \
    wget \
    tmux \
    libqt4-dev \
    libphonon-dev \
    libxml2-dev \
    libxslt1-dev \
    qtmobility-dev \
    libqtwebkit-dev \
    unzip; \
    apt-get clean

RUN pip3 install --no-cache-dir numpy

ENV OPENCV_VERSION=3.2.0

WORKDIR /tmp
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
RUN unzip ${OPENCV_VERSION}.zip

WORKDIR /tmp/opencv-${OPENCV_VERSION}
RUN mkdir /tmp/opencv-${OPENCV_VERSION}/build

WORKDIR /tmp/opencv-${OPENCV_VERSION}/build

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D WITH_TBB=ON \
          -D BUILD_PYTHON_SUPPORT=ON \
          -D WITH_V4L=ON \
#          -D INSTALL_C_EXAMPLES=ON \     bug w/ tag=3.2.0: cmake has error
          -D INSTALL_PYTHON_EXAMPLES=ON \
          -D BUILD_EXAMPLES=ON \
          -D BUILD_DOCS=ON \
#          -D OPENCV_EXTRA_MODULES_PATH=/usr/local/src/opencv_contrib/modules \
          -D WITH_XIMEA=YES \
#          -D WITH_QT=YES \
          -D WITH_FFMPEG=YES \
          -D WITH_PVAPI=YES \
          -D WITH_GSTREAMER=YES \
          -D WITH_TIFF=YES \
          -D WITH_OPENCL=YES \
          -D BUILD_opencv_python2=OFF \
          -D BUILD_opencv_python3=ON \
          -D PYTHON3_EXECUTABLE=/usr/local/bin/python \
          -D PYTHON3_INCLUDE_DIR=/usr/local/include/python3.6m \
          -D PYTHON3_LIBRARY=/usr/local/lib/libpython3.so \
          -D PYTHON_LIBRARY=/usr/local/lib/libpython3.so \
          -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.6/site-packages \
          -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.6/site-packages/numpy/core/include \
          ..

RUN make -j2
RUN make install
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
RUN ldconfig

RUN ln /dev/null /dev/raw1394
