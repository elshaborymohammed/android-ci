FROM fedora
# MAINTAINER Mohammed Elshabory <elshaborymohammed@gmail.com>

RUN dnf -qy update && \
    dnf group install -qy "C Development Tools and Libraries" && \
    dnf -qy install git-core \
        curl \
        glibc-locale-source \
        glibc-langpack-en \
        unzip \
        java-1.8.0-openjdk-devel \
        ruby-devel \
        redhat-rpm-config \
        patch && \
        gem install fastlane -NV

ENV VERSION_SDK_TOOLS "6858069"
ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV LANG=en_US.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java

RUN localedef -f UTF-8 -i en_US en_US.UTF-8
RUN curl -sL https://firebase.tools | bash

RUN curl -s https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip > /sdk.zip && \
    unzip /sdk.zip -d /sdk && \
    rm -v /sdk.zip

ADD packages.txt ${ANDROID_HOME}
RUN mkdir -p /root/.android && \
    touch /root/.android/repositories.cfg && \
    ${ANDROID_HOME}/tools/bin/sdkmanager --update
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
