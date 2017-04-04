FROM phusion/baseimage:latest
MAINTAINER bedefaced

ENV OPENSSL_VERSION 1.1.0e
ENV OPENSSL_SHA1 8bbbaf36feffadd3cb9110912a8192e665ebca4b

ENV PYTHON_VERSION 3.6.0
ENV PYTHON_MD5 3f7062ccf8be76491884d0e47ac8b251

ENV BUILD_DEPS autoconf file gcc git libc-dev make pkg-config zlib1g-dev

ENV OPENSSL_URL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
ENV PYTHON_URL https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz

RUN set -x && \
    apt-get update && apt-get install -y \
        $BUILD_DEPS \
        bsdmainutils \
        ldnsutils \
        --no-install-recommends

RUN set -x && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    curl -sSL $OPENSSL_URL -o openssl.tar.gz && \
    echo "${OPENSSL_SHA1} openssl.tar.gz" | sha1sum -c - && \
    tar zxvf openssl.tar.gz && \
    rm -f openssl.tar.gz && \
    cd openssl-${OPENSSL_VERSION} && \
    ./config && make && make install && \
    ldconfig

RUN set -x && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    curl -sSL $PYTHON_URL -o python.tar.gz && \
    echo "${PYTHON_MD5} python.tar.gz" | md5sum -c - && \
    tar zxvf python.tar.gz && \
    rm -f python.tar.gz && \
    cd Python-${PYTHON_VERSION} && \
    sed -i -e 's/#_socket/_socket/g' Modules/Setup.dist && \
    sed -i -e 's/#SSL=\/usr\/local\/ssl/SSL=\/usr\/local/g' Modules/Setup.dist && \
    sed -i -e 's/#_ssl/_ssl/g' Modules/Setup.dist && \
    sed -i -e 's/#[[:space:]]\+-DUSE_SSL/-DUSE_SSL/g' Modules/Setup.dist && \
    sed -i -e 's/#[[:space:]]\+-L$(SSL)\/lib/-L$(SSL)\/lib/g' Modules/Setup.dist && \
    ./configure && make && make install

