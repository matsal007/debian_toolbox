FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive \
    apt update -y \
    && apt install -y python3 \
    build-essential \
    xz-utils \
    curl \
    libssl-dev \
    git \
    wget \
    curl \
    vim \
    fuseiso

RUN useradd -ms /bin/bash salvadego
RUN cd /home/salvadego/
