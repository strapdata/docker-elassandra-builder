FROM ubuntu:16.04

# globals variables
ARG USER_HOME_DIR="/root"
ENV DEBIAN_FRONTEND noninteractive

# load apt cache
RUN apt-get update

# install commmons utilities
RUN apt-get install -y --no-install-recommends apt-utils curl tar git

# install java
RUN apt-get install -y --no-install-recommends openjdk-8-jdk
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64/"

# install maven
# see https://github.com/carlossg/docker-maven
ARG MAVEN_VERSION=3.5.0
ARG MAVEN_SHA=beb91419245395bd69a4a6edad5ca3ec1a8b64e41457672dc687c173a495f034
ARG MAVEN_BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  && echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV MAVEN_CMD "mvn clean package -DskipTests"
# allow maven cache reuse
VOLUME "${MAVEN_CONFIG}"

# install rpmbuild
RUN apt-get install -y --no-install-recommends rpm

# remove apt cache
RUN rm -rf /var/lib/apt/lists/*

# setup source directory
ENV SOURCE_DIR /src
RUN mkdir -p ${SOURCE_DIR}
VOLUME "${SOURCE_DIR}"

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "package" ]
