FROM debian:latest

ENV NAME=cef-toolbox VERSION=zurg
LABEL com.github.containers.toolbox="true" \
      com.github.debarshiray.toolbox="true" \
      name="$NAME" \
      version="$VERSION" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Base image for creating Debian zurg toolbox containers"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install \
    bash-completion \
    git \
    keyutils \
    libcap2-bin \
    lsof \
    man-db \
    mlocate \
    mtr \
    rsync \
    sudo \
    tcpdump \
    time \
    traceroute \
    tree \
    unzip \
    wget \
    zip

RUN sed -i -e 's/ ALL$/ NOPASSWD:ALL/' /etc/sudoers

RUN echo VARIANT_ID=container >> /etc/os-release
RUN touch /etc/localtime

COPY files/install-cef-dependencies /

ARG CHROMIUM_VERSION=106.0.5226.1

RUN ["/install-cef-dependencies"]

CMD /bin/bash
