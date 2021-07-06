FROM node:14-alpine
LABEL maintainer="Heitor Araujo <heitor.saraujo@gmail.com>"
RUN apk update
RUN apk add bash
RUN apk add openssh
RUN apk add git
RUN apk add zip
RUN apk add --no-cache wget
RUN apk add jq
RUN apk add xmlstarlet
RUN apk add python3
RUN apk add py3-pip
RUN npm install -g sf-packager
RUN npm install -g jsforce-metadata-tools
RUN npm install -g sfdx-cli
RUN npm install -g sfdx-packager
RUN npm install -g semver
RUN echo "Y" | sfdx plugins:install sfdx-git-packager
RUN echo 'y' | sfdx plugins:install sfpowerkit
# Set up Java 8
RUN apk add openjdk8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
# Set up Salesforce ANT Migration Tool
RUN apk add apache-ant
RUN wget https://gs0.salesforce.com/dwnld/SfdcAnt/salesforce_ant_50.0.zip
ENV ANT_HOME /usr/share/java/apache-ant
ENV PATH $PATH:$ANT_HOME/bin
RUN unzip salesforce_ant_50.0.zip -d ./salesforce_ant
RUN cp ./salesforce_ant/ant-salesforce.jar $ANT_HOME/lib/
# Set up PMD
ENV PMD_VERSION=6.29.0
RUN apk add curl
RUN curl -sLO https://github.com/pmd/pmd/releases/download/pmd_releases%2F${PMD_VERSION}/pmd-bin-${PMD_VERSION}.zip && \
    unzip pmd-bin-*.zip && \
    rm pmd-bin-*.zip && \
    echo '#!/bin/bash' >> /usr/local/bin/pmd && \
    echo '#!/bin/bash' >> /usr/local/bin/cpd && \
    echo '/pmd-bin-6.29.0/bin/run.sh pmd "$@"' >> /usr/local/bin/pmd && \
    echo '/pmd-bin-6.29.0/bin/run.sh cpd "$@"' >> /usr/local/bin/cpd && \
    chmod +x /usr/local/bin/pmd && \
    chmod +x /usr/local/bin/cpd

# PROVAR SETUP 

RUN echo "http://dl-2.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-2.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# install chromium
RUN apk -U --no-cache \
    --allow-untrusted add \
    zlib-dev \
    chromium \
    xvfb \
    wait4ports \
    xorg-server \
    dbus \
    ttf-freefont \
    grep \ 
    udev

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/
ENV PROVAR_HOME=/develop/ProvarHome

RUN mkdir -p $PROVAR_HOME
RUN curl -O https://download.provartesting.com/latest/Provar_ANT_latest.zip
RUN unzip -o Provar_ANT_latest.zip -d $PROVAR_HOME
# Creates xvfb-run script because it doesn't exist in Alpine Distribution
RUN curl -o /usr/bin/xvfb-run https://raw.githubusercontent.com/hsaraujo/salesforce-ci/main/xvfb-run
RUN chmod +x /usr/bin/xvfb-run

RUN apk add chromium-chromedriver
ENV ANT_OPTS=-Dcom.provar.chromedriver.versioningSupported=true
RUN cp /usr/bin/chromedriver $PROVAR_HOME/lib/com.provar.core.lib.selenium_3.4.0/drivers/linux/
