# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.22
ARG VERSION

USER root

RUN \
    apk add --no-cache \
        bash \
        catatonit \
        eudev \
        hidapi \
        libusb \
		libltdl \
    && \
    apk add --no-cache --virtual=.build-deps \
        autoconf \
        automake \
        build-base \
        git \
        libtool \
        libusb-dev \
        openssl-dev>3 \
        python3 \
    && \
    git clone https://github.com/networkupstools/nut.git /tmp/nut \
    && \
    cd /tmp/nut \
    && \
    git checkout "v${VERSION}" \
    && \
    ./autogen.sh \
    && \
    ./configure \
        --datadir=/usr/share/nut \
        --disable-static \
        --libexecdir=/usr/lib/nut \
        --prefix=/usr \
        --sysconfdir=/etc/nut \
        --with-altpidpath=/var/run/nut \
        --with-drvpath=/usr/lib/nut \
        #--with-user=nobody \
        #--with-group=nogroup \
        --with-libltdl \
        --with-openssl \
        --with-serial \
        --with-statepath=/var/run/nut \
        --with-udev-dir=/usr/lib/udev \
        --with-usb \
        --without-avahi \
        --without-cgi \
        --without-freeipmi \
        --without-ipmi \
        --without-modbus \
        --without-neon \
        --without-nss \
        --without-powerman \
        --without-snmp \
        --without-wrap \
    && \
    make && make install \
    && \
	mkdir -p /var/run/nut \
	&& \
    apk del --purge .build-deps \
    && \
    rm -rf /tmp/*

COPY . /

#USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
