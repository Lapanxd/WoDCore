FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    libmysqlclient-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libncurses5-dev \
    libboost-all-dev \
    libxml2-dev \
    libmariadb-dev \
    wget \
    unzip \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /wodcore
WORKDIR /wodcore
