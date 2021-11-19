FROM ubuntu:18.04

ARG JAVA_VERSION=8

ARG GRADLE_VERSION=6.0.1

ARG GOLANG_VERSION=1.17.1

ARG MAVEN_VERSION=3.5.4
ARG MAVEN_VERSION_SHA=CE50B1C91364CB77EFE3776F756A6D92B76D9038B0A0782F7D53ACF1E997A14D


ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH 	    	$JAVA_HOME/bin:$PATH
ENV LANGUAGE	en_US.UTF-8
ENV LANG    	en_US.UTF-8
ENV LC_ALL  	en_US.UTF-8

### Install wget, curl, git, unzip, gnupg, locales
RUN apt-get update && \
	apt-get -y install wget curl git unzip gnupg locales && \
	locale-gen en_US.UTF-8 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### add a new group + user without root premmsions
ENV WSS_GROUP wss-group
ENV WSS_USER wss-scanner
ENV WSS_USER_HOME=/home/${WSS_USER}

RUN groupadd ${WSS_GROUP} && \
	useradd --gid ${WSS_GROUP} --groups 0 --shell /bin/bash --home-dir ${WSS_USER_HOME} --create-home ${WSS_USER} && \
	passwd -d ${WSS_USER}

### Install Java openjdk 8
RUN echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu bionic main" | tee /etc/apt/sources.list.d/ppa_openjdk-r.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys DA1A4A13543B466853BAF164EB9B1D8886F44E2A && \
    apt-get update && \
    apt-get -y install openjdk-${JAVA_VERSION}-jdk && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*


### Install Maven (3.5.4)
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref && \
	curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
	echo "${MAVEN_VERSION_SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - && \
	tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 && \
	rm -f /tmp/apache-maven.tar.gz && \
	ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
	mkdir -p -m 777 ${WSS_USER_HOME}/.m2/repository && \
	chown -R ${WSS_USER}:${WSS_GROUP} ${WSS_USER_HOME}/.m2 && \
	rm -rf /tmp/*

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG ${WSS_USER_HOME}/.m2


### Install Node.js (12.19.0) + NPM (6.14.8)
RUN apt-get update && \
	curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -y nodejs build-essential && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### Install Yarn
RUN npm i -g yarn@1.5.1

### Install Bower + provide premmsions
RUN npm i -g bower --allow-root && \
	echo '{ "allow_root": true }' > ${WSS_USER_HOME}/.bowerrc && \
	chown -R ${WSS_USER}:${WSS_GROUP} ${WSS_USER_HOME}/.bowerrc


### Install Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm gradle-${GRADLE_VERSION}-bin.zip
### Set Gradle in the environment variables
ENV GRADLE_HOME /opt/gradle-${GRADLE_VERSION}
ENV PATH $PATH:/opt/gradle-${GRADLE_VERSION}/bin


### Install all the python2.7 + python3.6 packages
RUN apt-get update && \
	apt-get install -y python3-pip python3.6-venv && \
    apt-get install -y python-pip && \
    pip3 install pipenv && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### python utilities
RUN python -m pip install --upgrade pip && \
    python3 -m pip install --upgrade pip && \
    python -m pip install virtualenv && \
    python3 -m pip install virtualenv

#### python3.7 (used with UA flag: 'python.path')
RUN apt-get update && \
    apt-get install -y python3.7 python3.7-venv && \
    python3.7 -m pip install --upgrade pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
#### optional: python3.8 (used with UA flag: 'python.path')
RUN apt-get update && \
    apt-get install -y python3.8 python3.8-venv && \
    python3.8 -m pip install --upgrade pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*


#### Install GO:
USER ${WSS_USER}
RUN mkdir -p ${WSS_USER_HOME}/goroot && \
    curl https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar xvzf - -C ${WSS_USER_HOME}/goroot --strip-components=1
### Set GO environment variables
ENV GOROOT ${WSS_USER_HOME}/goroot
ENV GOPATH ${WSS_USER_HOME}/gopath
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH
### Install package managers

RUN go install github.com/tools/godep@latest
RUN go install github.com/LK4D4/vndr@latest
RUN go install  github.com/kardianos/govendor@latest

USER root

### Install dotnet cli/ sdk-2.2 and sdk-3.1 and sdk-5.0
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
	dpkg -i packages-microsoft-prod.deb && \
	apt-get update && \
	apt-get install -y apt-transport-https && \
	apt-get install -y dotnet-sdk-2.2 && \
	apt-get install -y dotnet-sdk-3.1 && \
	apt-get install -y dotnet-sdk-5.0 && \
	rm packages-microsoft-prod.deb && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

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
    wget -O nuget.zip https://www.nuget.org/api/v2/package/NuGet.CommandLine/5.10.0 && \
	unzip nuget.zip && \
    install -d $LIB/nuget  && \
    install ./tools/NuGet.exe $LIB/nuget/ && \
	echo '#!/usr/bin/env bash\nexec mono /usr/local/lib/nuget/NuGet.exe "$@"\n' > $BIN/nuget && \
	chmod a+x $BIN/nuget && \
	rm -rf $TMP

### Switch User ###
ENV HOME ${WSS_USER_HOME}
WORKDIR ${WSS_USER_HOME}
USER ${WSS_USER}

### Download Unified Agent
RUN curl -LJO https://github.com/whitesource/unified-agent-distribution/releases/latest/download/wss-unified-agent.jar

### Turn on necessary PreSteps
ENV WS_PYTHON_RUNPIPENVPRESTEP=true
ENV WS_GO_COLLECTDEPENDENCIESATRUNTIME=true

### Make Data Dir for scanning
RUN mkdir Data

### base command
CMD java -jar ./wss-unified-agent.jar -d ./Data