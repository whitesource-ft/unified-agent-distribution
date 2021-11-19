# Dockerized Unifed-Agent

Refer to https://github.com/whitesource/unified-agent-distribution/blob/master/dockerized/README.md for customization and original setup directions

## [GitHub for Dockerfile Customization](https://github.com/whitesource-ft/unified-agent-distribution)

## Changes from Template
* Upgrade SBT to 1.5.1
* Downgrade Cocoapods to 1.10.2
* Uses ENV Variables & default values instead of a config file
* Certain necessary package manager PreSteps=true

## Installation Differences

Tool | Thin | Full
--- | --- | ---
Java (1.8) | X | X
Maven (3.5.4) | X | X
Node.js (12.19.0) | X | X
NPM (6.14.8) | X | X
Yarn (1.5.1) | X | X
Bower (1.8.2) | X | X
Gradle (6.0.1) | X | X
python 2.7 + 3.6 + 3.7 + 3.8 + pip + pip3 + pipenv | X | X
Conda (2021.05) |  | X
Poetry (python) |  | X
Ruby, rbenv and ruby-build |  | X
Go (1.17.1) | X | X
Scala 2.12.6, Sbt 1.5.1 |  | X
PHP (7.2) |  | X
Composer |  | X
PHP Plugins |  | X
Mix, Hex, Erlang and Elixir |  | X
Cocoapods (1.5.3) |  | X
R + Packrat |  | X
Haskel + Cabal |  | X 
dotnet-sdk-2.2, 3.1, 5.0, dotnet cli, Mono, and NuGet |  | X
Paket |  | X
Cargo |  | X
dotnet-sdk-2.2, 3.1, 5.0, dotnet cli, Mono, and NuGet | X | X


## Build Directions: 

### All Package Managers
```
cd ./Full
docker build ./ -t dockerua:full
```

### Less Package Managers
```
docker build ./ -t dockerua:thin
```

## Usage Directions
#### Required ENV Variables
    * WS_APIKEY
    * WS_PRODUCTNAME
    * WS_PROJECTNAME
    * SCANDIR


* To use the latest full image: ```docker pull whitesourceft/dockerua:full```
* To use the latest thin image: ```docker pull whitesourceft/dockerua:thin```

### Linux Instructions
#### Set Required Configurations
```
cd <your cloned directory>
export WS_APIKEY=<your-apikey>
export SCANDIR=$(pwd)
export WS_PRODUCTNAME=$(git config --get remote.origin.url | awk -F "/" '{print $4}')
export WS_PROJECTNAME=$(git config --get remote.origin.url | awk -F "/" '{print $5}' | awk -F "." '{print $1}')
```
* Add any additional env variables for [configuration parameters](https://whitesource.atlassian.net/wiki/spaces/WD/pages/1544880156/Unified+Agent+Configuration+Parameters)


#### Run Scan via Terminal
```
docker run --rm --name dockerua \
--mount type=bind,source=$SCANDIR,target=/home/wss-scanner/Data/ \
-e WS_APIKEY=$WS_APIKEY \
-e WS_PRODUCTNAME=$WS_PRODUCTNAME \
-e WS_PROJECTNAME=$WS_PROJECTNAME whitesourceft/dockerua:thin
```
### Windows Instructions
#### Set Required Configurations
```
cd <your cloned directory>
set WS_APIKEY=<your-apikey>
set SCANDIR=%cd%
set WS_PRODUCTNAME=<my-product-name>
set WS_PROJECTNAME=<my-project-name>
```
#### Run Scan via Windows Command Prompt
```
docker run --rm --name dockerua --mount type=bind,source=%SCANDIR%,target=/home/wss-scanner/Data/ -e WS_APIKEY=%WS_APIKEY% -e WS_PRODUCTNAME=%WS_PRODUCTNAME% -e WS_PROJECTNAME=%WS_PROJECTNAME% whitesourceft/dockerua:thin
```
