FROM node:20-alpine
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
RUN npm install @salesforce/cli --global
RUN echo "Y" | sf plugins:install @salesforce/sfdx-scanner
RUN echo "Y" | sf plugins install sfdx-git-delta

# Allow execution of pip install commmands
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Set up Java 8
RUN apk add openjdk11
# ENV JAVA_HOME="/usr/lib/jvm/java-1.11-openjdk"
# Set up PMD
ENV PMD_VERSION=7.4.0
RUN apk add curl
RUN wget https://github.com/pmd/pmd/releases/download/pmd_releases%2F${PMD_VERSION}/pmd-dist-${PMD_VERSION}-bin.zip
RUN unzip pmd-dist-${PMD_VERSION}-bin.zip
RUN alias pmd="$HOME/pmd-bin-${PMD_VERSION}/bin/pmd"