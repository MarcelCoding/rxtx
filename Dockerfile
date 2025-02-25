FROM debian:bullseye

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget tar gcc-multilib lsb-release; \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/opt/java
ENV PATH=$JAVA_HOME/bin:$PATH

RUN set -ex; \
    mkdir -p $JAVA_HOME; \
    wget -c "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.19%2B7/OpenJDK11U-jdk_x64_linux_hotspot_11.0.19_7.tar.gz" -O - | tar -xz --strip-components=1 -C $JAVA_HOME

ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

RUN set -ex; \
    mkdir -p $MAVEN_HOME; \
    wget -c "https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz" -O - | tar -xz --strip-components=1 -C $MAVEN_HOME

RUN set -ex; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y --no-install-recommends gcc gcc-mingw-w64-i686 gcc-mingw-w64-x86-64 gcc-arm-linux-gnueabi gcc-arm-linux-gnueabihf libc6-dev-armel-cross libc6-dev-armhf-cross gcc-aarch64-linux-gnu libc6-dev-arm64-cross ; \
    rm -rf /var/lib/apt/lists/*

# mvn --batch-mode -Pwith-linux-x86,with-linux-x86_64,with-linux-armel,with-linux-armhf,with-linux-aarch64,with-windows-x86,with-windows-x86_64 package install --file pom.xml
