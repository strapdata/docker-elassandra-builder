FROM ubuntu:16.04

# create builder user
RUN useradd -ms /bin/bash builder

# globals variables
ARG USER_HOME_DIR="/home/builder"
ENV DEBIAN_FRONTEND noninteractive

# load apt cache
RUN apt-get update

# install commmons utilities
RUN apt-get install -y --no-install-recommends apt-utils curl tar software-properties-common zip unzip

# install java
# RUN apt-get install -y --no-install-recommends openjdk-8-jdk
# ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64/"
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-add-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV GRADLE_VERSION 3.3
ENV GRADLE_URL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
#ENV GRADLE_SHA1
ENV GRADLE_HOME /usr/lib/gradle-${GRADLE_VERSION}
ENV GRADLE_REF /usr/lib/gradle-ref
ENV PATH $PATH:${GRADLE_HOME}/bin

ENV GRADLE_CONFIG /root/.gradle
VOLUME $GRADLE_CONFIG

ENV COPY_REFERENCE_FILE_LOG $GRADLE_CONFIG/copy_reference_file.log

RUN cd /usr/lib && \
    curl -fsSL $GRADLE_URL -o gradle-bin.zip && \
    unzip gradle-bin.zip && \
    ln -s "/usr/lib/gradle-${GRADLE_VERSION}/bin/gradle" /usr/bin/gradle && \
    rm gradle-bin.zip && \
    mkdir -p /src $GRADLE_REF

ENV GRADLE_CMD="gradle assemble"

# install rpmbuild
RUN apt-get install -y --no-install-recommends rpm

# remove apt cache
RUN rm -rf /var/lib/apt/lists/*

# setup source directory
ENV SOURCE_DIR $USER_HOME_DIR/src
RUN mkdir -p ${SOURCE_DIR}
RUN chown builder:builder ${SOURCE_DIR}
VOLUME "${SOURCE_DIR}"

COPY docker-entrypoint.sh /docker-entrypoint.sh
USER builder
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "package" ]
