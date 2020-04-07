FROM node:13-stretch

MAINTAINER Mister Tzu <mister.tzu@gmail.com>

RUN apt-get update && apt-get install -y apt-transport-https
RUN echo "deb https://notesalexp.org/tesseract-ocr/stretch/ stretch main" >> /etc/apt/sources.list
RUN wget -O - https://notesalexp.org/debian/alexp_key.asc | apt-key add -
RUN apt-get update
RUN  apt-get install -y tesseract-ocr

# RUN apt install -y python3-pip
# RUN echo "pip3 --versionpip 9.0.1 from /usr/lib/python3/dist-packages (python 3.5)"
# RUN pip3 install -y pytesseract tox pillow imutils net-tools vim

RUN apt-get -y install python-pip
RUN pip install pytesseract
RUN pip install tox
# RUN tox

RUN pip install pillow
RUN pip install imutils

RUN pip install opencv-python-headless
RUN pip install opencv-contrib-python-headless

RUN apt install -y libgtk2.0-dev pkg-config libqt4-dev

RUN cd /usr/local/lib
RUN git clone https://github.com/tesseract-ocr/tessconfigs

RUN apt install -y build-essential cmake git pkg-config libgtk-3-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev

WORKDIR /root

RUN mkdir /root/opencv_build
WORKDIR /root/opencv_build

RUN git clone https://github.com/opencv/opencv.git
RUN git clone https://github.com/opencv/opencv_contrib.git

WORKDIR /root/opencv_build/opencv/

RUN mkdir build

WORKDIR /root/opencv_build/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_build/opencv_contrib/modules -D BUILD_EXAMPLES=ON ..

RUN make -j2
RUN make install
RUN pkg-config --modversion opencv4

WORKDIR /root

WORKDIR /usr/local/lib
RUN git clone https://github.com/tesseract-ocr/tessconfigs

WORKDIR /usr/local/share/tessdata/
wget https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata
wget https://github.com/tesseract-ocr/tessdata/raw/master/ita.traineddata
