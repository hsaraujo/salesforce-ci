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
RUN npm install -g sf-packager
RUN npm install -g jsforce-metadata-tools
RUN npm install -g sfdx-cli@7.209.6
RUN npm install -g sfdx-packager
RUN npm install -g semver
RUN echo "Y" | sfdx plugins:install sfdx-git-packager
RUN echo "Y" | sfdx plugins:install @salesforce/sfdx-scanner
RUN echo "Y" | sfdx plugins:install sfdx-git-delta

# Set up Java 8
RUN apk add openjdk11
ENV JAVA_HOME="/usr/lib/jvm/java-1.11-openjdk"
# Set up PMD
ENV PMD_VERSION=6.49.0
RUN apk add curl
RUN curl -sLO https://github.com/pmd/pmd/releases/download/pmd_releases%2F${PMD_VERSION}/pmd-bin-${PMD_VERSION}.zip && \
    unzip pmd-bin-*.zip && \
    rm pmd-bin-*.zip && \
    echo '#!/bin/bash' >> /usr/local/bin/pmd && \
    echo '#!/bin/bash' >> /usr/local/bin/cpd && \
    echo '/pmd-bin-${PMD_VERSION}/bin/run.sh pmd "$@"' >> /usr/local/bin/pmd && \
    echo '/pmd-bin-${PMD_VERSION}/bin/run.sh cpd "$@"' >> /usr/local/bin/cpd && \
    chmod +x /usr/local/bin/pmd && \
    chmod +x /usr/local/bin/cpd