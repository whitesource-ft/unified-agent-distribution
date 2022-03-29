# This default may be swapped for any compatible base image
ARG BASE_IMAGE=amd64/ubuntu:18.04

# This buildpack is used for tool installation and user/directory setup
FROM containerbase/buildpack:3.2.4@sha256:31e3b85387934e330d9fcddf793ae07c60d23e6ad3d01a070b4060594eedb8f7 AS buildpack

FROM ${BASE_IMAGE} as base

### Image containing:
### base Ubuntu:18.04
### 1.  utility apps
### 2.  Java (11.0.13+8)
### 3.  Maven (3.6.3)
### 4.  Node.js (16.10.0)
### 5.  NPM (7.24.0)
### 6.  Yarn (1.22.17)
### 7.  Bower (1.8.13)
### 8.  Gradle (6.9.1)
### 9.  python 2.7 + 3.6 + pip + pip3 + pipenv
### 10. python 3.7
### 11. [optional] python 3.8
### 12. Poetry (python)
### 13. Ruby 2.7.5 + bundle 2.3.4, rbenv and ruby-build
### 14. Go (1.12.6)
### 15. Scala 2.13.5, Sbt 1.5.7
### 16. PHP (7.2)
### 17. Composer
### 18. PHP Plugins
### 19. Mix, Hex, Erlang and Elixir
### 20. Cocoapods (1.11.2)
### 21. R + Packrat
### 22. Haskel + Cabal
### 23. dotnet-sdk-2.2,dotnet cli and NuGet
### 24. Paket
### 25. Cargo

# The buildpack supports custom user
ARG USER_NAME=wss-scanner
ARG USER_ID=1000
ARG USER_HOME=/home/${USER_NAME}
ARG APT_HTTP_PROXY

# Set env and shell
ENV BASH_ENV=/usr/local/etc/env
SHELL ["/bin/bash" , "-c"]

# Set up buildpack
COPY --from=buildpack /usr/local/bin/ /usr/local/bin/
COPY --from=buildpack /usr/local/buildpack/ /usr/local/buildpack/
RUN install-buildpack

# renovate: datasource=github-tags depName=git lookupName=git/git
ARG GIT_VERSION=2.34.1
RUN install-tool git

# renovate: datasource=docker depName=node versioning=docker
ARG NODE_VERSION=16.10.0
RUN install-tool node

# renovate: datasource=npm depName=yarn
ARG YARN_VERSION=1.22.17
RUN install-tool yarn

# renovate: datasource=npm depName=bower
ARG BOWER_VERSION=1.8.13
RUN install-npm bower

### provide permissions
RUN echo '{ "allow_root": true }' > ${USER_HOME}/.bowerrc && \
	chown -R ${USER_NAME}:${GROUP_NAME} ${USER_HOME}/.bowerrc

# renovate: datasource=docker depName=openjdk versioning=docker
ARG JAVA_VERSION=11.0.13+8
RUN install-tool java

# renovate: datasource=gradle-version depName=gradle versioning=gradle
ARG GRADLE_VERSION=6.9.1
RUN install-tool gradle

# renovate: datasource=docker depName=golang versioning=docker
ARG GOLANG_VERSION=1.17.6
RUN install-tool golang

USER ${USER_ID}
## Install package managers

RUN go install github.com/tools/godep@latest
RUN go install github.com/LK4D4/vndr@latest
RUN go install  github.com/kardianos/govendor@latest

#All Deparacted/archived go package managers
# RUN go install  github.com/gpmgo/gopm@latest
# RUN go install  github.com/golang/dep/cmd/dep@latest
# RUN go install github.com/Masterminds/glide@latest
# RUN curl https://glide.sh/get | sh
USER 0
RUN chgrp -R 0 /go && chmod -R g=u /go

# renovate: datasource=maven depName=maven lookupName=org.apache.maven:maven
ARG MAVEN_VERSION=3.6.3
RUN install-tool maven

# renovate: datasource=github-releases depName=scala lookupName=scala/scala
ARG SCALA_VERSION=2.13.5
RUN install-tool scala

# renovate: datasource=github-releases depName=sbt lookupName=sbt/sbt
ARG SBT_VERSION=1.5.7
RUN install-tool sbt

# renovate: datasource=github-releases depName=python lookupName=containerbase/python-prebuild
ARG PYTHON_VERSION=3.6.15
RUN install-tool python

# renovate: datasource=github-releases depName=python lookupName=containerbase/python-prebuild
ARG PYTHON_VERSION=2.7.18
RUN install-tool python

# renovate: datasource=github-releases depName=python lookupName=containerbase/python-prebuild
ARG PYTHON_VERSION=3.7.12
RUN install-tool python

ARG PHP_VERSION=7.4.27
RUN install-tool php

# renovate: datasource=github-releases depName=composer lookupName=composer/composer
ARG COMPOSER_VERSION=2.0.13
RUN install-tool composer

ARG DOTNET_VERSION=2.2.207
RUN install-tool dotnet

ARG DOTNET_VERSION=3.1.416
RUN install-tool dotnet

ARG DOTNET_VERSION=5.0.404
RUN install-tool dotnet

ARG RUST_VERSION=1.58.1
RUN install-tool rust

# optional: python3.8 (used with UA flag: 'python.path')
# renovate: datasource=github-releases depName=python lookupName=containerbase/python-prebuild
# ARG PYTHON_VERSION=3.8.12
# RUN install-tool python

# pip user install (so available for all python versions)
USER ${USER_ID}

## pipenv depends on virtualenv
# renovate: datasource=pypi depName=virtualenv
ARG VIRTUALENV_VERSION=20.13.0
RUN install-pip virtualenv

# renovate: datasource=pypi depName=pipenv
ARG PIPENV_VERSION=2022.1.8
RUN install-pip pipenv

# renovate: datasource=pypi depName=checkov
ARG CHECKOV_VERSION=2.0.707
RUN install-pip checkov

USER 0

# renovate: datasource=pypi
ARG POETRY_VERSION=1.1.12
RUN install-tool poetry

# renovate: datasource=github-releases depName=ruby lookupName=containerbase/ruby-prebuild
ARG RUBY_VERSION=2.7.5
RUN install-tool ruby

# renovate: datasource=rubygems depName=bundler versioning=ruby
ARG BUNDLER_VERSION=2.3.4
RUN install-gem bundler

ARG ERLANG_VERION=22.0
RUN install-tool erlang

ARG ELIXIR_VERSION=1.13.3
RUN install-tool elixir

#### Install rbenv and ruby-build
### or maybe be saved to /etc/profile instead of /etc/profile.d/
# RUN git clone https://github.com/sstephenson/rbenv.git ${USER_HOME}/.rbenv; \
#	git clone https://github.com/sstephenson/ruby-build.git ${USER_HOME}/.rbenv/plugins/ruby-build; \
#	${USER_HOME}/.rbenv/plugins/ruby-build/install.sh && \
#	echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
#	echo 'eval "$(rbenv init -)"' >> ${USER_HOME}/.bashrc && \
#	chown -R ${USER_NAME}:${GROUP_NAME} ${USER_HOME}/.rbenv ${USER_HOME}/.bashrc
# ENV PATH ${USER_HOME}/.rbenv/bin:$PATH

# renovate: datasource=rubygems depName=cocoapods versioning=ruby
ARG COCOAPODS_VERSION=1.11.2
RUN install-gem cocoapods
RUN adduser cocoapods
USER cocoapods
RUN pod setup
USER 0

## No renovate datasource exists yet
ARG HASKELL_GHC_VERSION=8.6.5

## No renovate datasource exists yet
ARG CABAL_VERSION=3.2

ENV DEBIAN_FRONTEND noninteractive
ENV LANGUAGE	en_US.UTF-8
ENV LANG    	en_US.UTF-8
ENV LC_ALL  	en_US.UTF-8

### Install wget, curl, unzip, gnupg, locales
RUN apt-get update && \
	apt-get -y install wget curl unzip gnupg locales && \
	locale-gen en_US.UTF-8 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*


#### Install Conda (python)
#USER ${USER_NAME}
#RUN cd ${USER_HOME} && \
#    wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh && \
#    bash Anaconda3-2021.05-Linux-x86_64.sh -b && \
#    rm Anaconda3-2021.05-Linux-x86_64.sh
#
#USER 0
#RUN echo '#!/usr/bin/env bash' >> /usr/bin/conda && \
#    echo 'source ${USER_HOME}/anaconda3/etc/profile.d/conda.sh' >> /usr/bin/conda && \
#    echo '${USER_HOME}/anaconda3/bin/conda "$@"' >> /usr/bin/conda && \
#    chmod +x /usr/bin/conda


#### Important note ###
#### uncomment for:
####    Scala
####    SBT
####    Mix/ Hex/ Erlang/ Elixir
####    dotnet/nuget cli's
RUN apt-get update && \
	apt-get install -y --force-yes build-essential && \
	apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

## Install PHP Plugins
RUN apt-get update && \
	apt-get install -y php7.2-mbstring && \
	apt-get install -y php7.2-dom && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

#### Install R and Packrat
RUN apt-get update && \
	apt-get install -y r-base libopenblas-base r-base gdebi && \
	wget https://download1.rstudio.org/rstudio-xenial-1.1.419-amd64.deb && \
	gdebi rstudio-xenial-1.1.419-amd64.deb && \
	rm rstudio-xenial-1.1.419-amd64.deb && \
	R -e 'install.packages("packrat" , repos="http://cran.us.r-project.org");'  && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*


#### Install Cabal
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 063DAB2BDC0B3F9FCEBC378BFF3AEACEF6F88286 && \
	echo "deb http://ppa.launchpad.net/hvr/ghc/ubuntu bionic main " | tee /etc/apt/sources.list.d/ppa_hvr_ghc.list && \
	apt-get update && \
	apt-get install -y ghc-${HASKELL_GHC_VERSION} cabal-install-${CABAL_VERSION} && \
	PATH="/opt/ghc/bin:${PATH}" && \
	cabal update && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*
ENV PATH /opt/ghc/bin:$PATH


#### Install Mono
RUN apt-get update && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates && \
    echo "deb https://download.mono-project.com/repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-devel && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

#### Install Nuget CLI
RUN TMP=/tmp/nuget  && \
    LIB=/usr/local/lib && \
    BIN=/usr/local/bin && \
    rm -rf $TMP $LIB/nuget $BIN/nuget && \
    mkdir -p $TMP && \
    cd $TMP && \
    wget -O nuget.zip https://www.nuget.org/api/v2/package/NuGet.CommandLine/5.11.0 && \
	unzip nuget.zip && \
    install -d $LIB/nuget  && \
    install ./tools/NuGet.exe $LIB/nuget/ && \
	echo '#!/usr/bin/env bash\nexec mono /usr/local/lib/nuget/NuGet.exe "$@"\n' > $BIN/nuget && \
	chmod a+x $BIN/nuget && \
	rm -rf $TMP

## Install Paket
RUN mozroots --import --sync && \
    TMP=/tmp/paket/src  && \
    LIB=/usr/local/lib && \
    BIN=/usr/local/bin && \
    rm -rf $TMP && \
    mkdir -p $TMP && \
    cd $TMP && \
    wget -O paket.zip https://www.nuget.org/api/v2/package/Paket/5.257.0 && \
    unzip paket.zip && \
    rm -rf $LIB/paket && \
    install -d $LIB/paket  && \
    install ./tools/paket.exe $LIB/paket/ && \
    rm -rf $BIN/paket && \
    echo $'!/usr/bin/env bash exec mono\n\
    exec mono /usr/local/lib/paket/paket.exe "$@"\n'\
    >> $BIN/paket && \
    chmod a+x $BIN/paket


ENV LOG4J_FORMAT_MSG_NO_LOOKUPS=true
### Switch User ###
ENV HOME ${USER_HOME}
WORKDIR ${USER_HOME}
USER ${USER_ID}

### Download Unified Agent
RUN curl -LJO https://github.com/whitesource/unified-agent-distribution/releases/latest/download/wss-unified-agent.jar

### Turn on necessary PreSteps
ENV WS_PYTHON_RUNPIPENVPRESTEP=true
ENV WS_PYTHON_RUNPOETRYPRESTEP=true
ENV WS_RUBY_RUNBUNDLEINSTALL=true
ENV WS_GO_COLLECTDEPENDENCIESATRUNTIME=true
ENV WS_SBT_RUNPRESTEP=true
ENV WS_PHP_RUNPRESTEP=true
ENV WS_HEX_RUNPRESTEP=true
ENV WS_COCOAPODS_RUNPRESTEP=true
ENV WS_R_RUNPRESTEP=true
ENV WS_HASKELL_RUNPRESTEP=true
ENV WS_CARGO_RUNPRESTEP=true
ENV WS_PAKET_RUNPRESTEP=true

### Make Data Dir for scanning
RUN mkdir Data

### base command
CMD java -jar ./wss-unified-agent.jar -d ./Data