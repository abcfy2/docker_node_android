FROM node:alpine
LABEL Maintainer="Feng Yu<abcfy2@163.com>"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV JDK_VERSION 8
ENV JAVA_HOME /usr/lib/jvm/zulu${JDK_VERSION}-ca

# Install glibc
# Reference: https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/8/jdk/alpine/Dockerfile.hotspot.releases.slim
RUN apk add --virtual .build-deps binutils && \
    GLIBC_VER="2.30-r0" \
    && ALPINE_GLIBC_REPO="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
    && GCC_LIBS_URL="https://archive.archlinux.org/packages/g/gcc-libs/gcc-libs-9.1.0-2-x86_64.pkg.tar.xz" \
    && GCC_LIBS_SHA256="91dba90f3c20d32fcf7f1dbe91523653018aa0b8d2230b00f822f6722804cf08" \
    && ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.11-3-x86_64.pkg.tar.xz" \
    && ZLIB_SHA256=17aede0b9f8baa789c5aa3f358fbf8c68a5f1228c5e6cba1a5dd34102ef4d4e5 \
    && wget https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub \
    && SGERRAND_RSA_SHA256="823b54589c93b02497f1ba4dc622eaef9c813e6b0f0ebbb2f771e32adf9f4ef2" \
    && echo "${SGERRAND_RSA_SHA256} */etc/apk/keys/sgerrand.rsa.pub" | sha256sum -c - \
    && wget ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-${GLIBC_VER}.apk -O /tmp/glibc-${GLIBC_VER}.apk \
    && wget ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk -O /tmp/glibc-bin-${GLIBC_VER}.apk \
    && wget ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-i18n-${GLIBC_VER}.apk -O /tmp/glibc-i18n-${GLIBC_VER}.apk \
    && apk add /tmp/glibc-${GLIBC_VER}.apk /tmp/glibc-bin-${GLIBC_VER}.apk /tmp/glibc-i18n-${GLIBC_VER}.apk \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
    && wget ${GCC_LIBS_URL} -O /tmp/gcc-libs.tar.xz \
    && echo "${GCC_LIBS_SHA256} */tmp/gcc-libs.tar.xz" | sha256sum -c - \
    && mkdir /tmp/gcc \
    && tar -xf /tmp/gcc-libs.tar.xz -C /tmp/gcc \
    && mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib \
    && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
    && wget ${ZLIB_URL} -O /tmp/libz.tar.xz \
    && echo "${ZLIB_SHA256} */tmp/libz.tar.xz" | sha256sum -c - \
    && mkdir /tmp/libz \
    && tar -xf /tmp/libz.tar.xz -C /tmp/libz \
    && mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib \
    && apk del --purge .build-deps glibc-i18n \
    && rm -rf /etc/apk/keys/sgerrand.rsa.pub /tmp/*.apk /tmp/gcc /tmp/gcc-libs.tar.xz /tmp/libz /tmp/libz.tar.xz /var/cache/apk/*

RUN wget --quiet https://cdn.azul.com/public_keys/alpine-signing@azul.com-5d5dc44c.rsa.pub -P /etc/apk/keys/ && \
    echo "https://repos.azul.com/zulu/alpine" >> /etc/apk/repositories && \
    apk --no-cache add zulu${JDK_VERSION}-jdk-headless && \
    rm -fr /etc/apk/keys/alpine-signing@azul.com-5d5dc44c.rsa.pub /var/cache/apk/*

# download and install Gradle
# https://services.gradle.org/distributions/
ARG GRADLE_VERSION=4.1
ARG GRADLE_DIST=all
RUN cd /opt && \
    wget -q https://services.gradle.org/distributions/gradle-5.6.4-bin.zip && \
    unzip -q gradle*.zip && \
    mkdir -p "gradle-${GRADLE_VERSION}-${GRADLE_DIST}-wrapper" && \
    cd "gradle-${GRADLE_VERSION}-${GRADLE_DIST}-wrapper" && \
    /opt/gradle-5.6.4/bin/gradle wrapper --no-daemon --gradle-version "${GRADLE_VERSION}" --distribution-type "${GRADLE_DIST}" && \
    ln -s "/opt/gradle-${GRADLE_VERSION}-${GRADLE_DIST}-wrapper/gradlew" /usr/local/bin/gradle && \
    rm -fr /opt/gradle*.zip /opt/gradle-5.6.4

# download and install Android SDK
# https://developer.android.com/studio/#downloads
ARG ANDROID_SDK_VERSION=4333796
ARG ANDROID_BUILD_TOOL_VERSION=29.0.2
ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV ANDROID_HOME ${ANDROID_SDK_ROOT}
RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip && \
    unzip -q *tools*linux*.zip && \
    rm *tools*linux*.zip && \
    ln -s "${ANDROID_HOME}/tools/bin/sdkmanager" /usr/local/bin
RUN yes | sdkmanager "build-tools;${ANDROID_BUILD_TOOL_VERSION}" || true && \
    yes | sdkmanager --licenses || true && rm -fr ~/.android
