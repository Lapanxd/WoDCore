FROM ubuntu:16.04

RUN echo "mysql-server mysql-server/root_password password feur" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password feur" | debconf-set-selections

RUN apt-get update && \
    apt-get install -y \
    nano \
    git \
    build-essential \
    cmake \
    libmysqlclient-dev \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libncurses5-dev \
    libboost-all-dev \
    libxml2-dev \
    libace-dev \
    wget \
    unzip \
    sudo \
    mysql-server \
    mysql-client \
    unrar \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /wodcore
WORKDIR /wodcore

RUN mkdir -p /root/.ssh

COPY ./id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone --branch main git@github.com:Lapanxd/WoDCore.git .

RUN mkdir build && \
    cd build && \
    cmake .. -DCMAKE_CXX_STANDARD=14 -DOPENSSL_ROOT_DIR=/usr -DOPENSSL_INCLUDE_DIR=/usr/include -DOPENSSL_LIBRARIES=/usr/lib/x86_64-linux-gnu/libssl.so -DACE_INCLUDE_DIR=/usr/include/ace -DACE_LIBRARY=/usr/lib/x86_64-linux-gnu -DUSE_PCH=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_CXX_FLAGS="-D__STRICT_ANSI__" -DCMAKE_EXE_LINKER_FLAGS="-fPIC"  && \
    rm -rf CMakeCache.txt CMakeFiles/ && \
    make -j$(nproc)

COPY ./maps /wodcore/build/src/server/worldserver/

RUN find /wodcore/build/src/server/worldserver/maps -name "*.zip" -exec unzip -o {} -d /wodcore/build/src/server/worldserver/maps/ \;

run mv /wodcore/build/src/server/worldserver/worldserver.conf /usr/local/etc/firestorm/

run mv /wodcore/build/src/server/authserver/authserver.conf /usr/local/etc/firestorm/

RUN service mysql start

RUN wodcore/start_servers.sh
RUN chmod +x wodcore/start_servers.sh

EXPOSE 8085 3724 8086 3306