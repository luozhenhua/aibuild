# Use an official Python runtime as a parent image
FROM nxpml/armv8:lsdk1806_ml_baseline

# Set the working directory to /app
WORKDIR /app

# wipe out previous content
# RUN rm -rf /app/*

# Copy the current directory contents into the container at /app
ADD . /app


#disable interactive mode in tzdata installation
#ENV DEBIAN_FRONTEND noninteractive

#Install required Ubuntu packages
RUN apt-get update && apt-get install -y --fix-missing $(awk '{print $1'} apt_packages.txt)

#Instal protobuf
RUN wget https://github.com/google/protobuf/releases/download/v3.6.1/protobuf-cpp-3.6.1.tar.gz &&\
    tar zxvf protobuf-cpp-3.6.1.tar.gz                                                        &&\
    cd protobuf-3.6.1                                                                     &&\
    ./configure                                                                               &&\
    make -j 4                                                                                 &&\
    make install                                                                              &&\
    ldconfig

RUN rm -rf protobuf*

RUN git clone https://github.com/Tencent/ncnn.git                                       &&\
    cd ncnn                                                                             &&\
    git checkout af806a2d8dbc75698350db70c5148b3d03df6c9c                               &&\
    git apply --verbose --ignore-whitespace --reject ../ncnn_patch.diff                 &&\
    mkdir build                                                                         &&\
    cd build                                                                            &&\
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..                                          &&\
    make -j 4                                                                           










