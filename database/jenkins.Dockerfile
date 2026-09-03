FROM jenkins/jenkins:lts-jdk21

USER root

# Install required Linux packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Android SDK environment
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=/opt/android-sdk

ENV PATH=$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools

# Create Android SDK directory
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools

# Download Android Command Line Tools
RUN wget -q \
    https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    -O /tmp/cmdline-tools.zip

# Extract Android Command Line Tools
RUN unzip -q \
    /tmp/cmdline-tools.zip \
    -d ${ANDROID_SDK_ROOT}/cmdline-tools

# Rename command line tools directory
RUN mv \
    ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools \
    ${ANDROID_SDK_ROOT}/cmdline-tools/latest

# Remove installer
RUN rm /tmp/cmdline-tools.zip

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses

# Install Android SDK 36
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-36" \
    "build-tools;36.0.0"

# Give Jenkins access to Android SDK
RUN chown -R jenkins:jenkins ${ANDROID_SDK_ROOT}

USER jenkins