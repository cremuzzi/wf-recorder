FROM debian:10-slim as base

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    libavcodec-dev \
    libavdevice-dev \
    libavformat-dev \
    libavutil-dev \
    libpulse-dev \
    libswscale-dev \
    libwayland-dev \
    meson \
    wayland-protocols \
  && useradd -m -u 1000 -s /bin/bash wfrecorder \
  && mkdir /app \
  && chown -R wfrecorder:wfrecorder /app

WORKDIR /app
USER wfrecorder

FROM base as source

COPY --chown=wfrecorder . .

FROM source as build

RUN meson build --prefix=/usr --buildtype=release \
  && ninja -C build
