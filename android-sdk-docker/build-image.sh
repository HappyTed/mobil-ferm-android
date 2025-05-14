#!/usr/bin/bash

source .env

docker build --build-arg ANDROID_VERSION=$ANDROID_VERSION \
             --build-arg ANDROID_BUILD_TOOLS_VERSION=$ANDROID_BUILD_TOOLS_VERSION \
             --build-arg CMDLINE_TOOLS_VERSION=$CMDLINE_TOOLS_VERSION\
             --no-cache -t android-build:$TAG .
