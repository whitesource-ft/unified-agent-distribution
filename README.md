# Dockerized Unified-Agent
:no_entry: [DEPRECATED] This repository will be inaccessible starting January 9th, 2023.  

Refer to https://github.com/whitesource/unified-agent-distribution/blob/master/dockerized/README.md for customization and original setup directions

## [GitHub](https://github.com/whitesource-ft/unified-agent-distribution)

## Changes from Original Template
* Package Manager versions match repository integration
* Uses environment variables & default values instead of a config file
* Certain package manager PreSteps=true

## Usage Directions
#### Required ENV Variables
    * WS_APIKEY
    * WS_PRODUCTNAME
    * WS_PROJECTNAME
    * SCANDIR


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
-e WS_PROJECTNAME=$WS_PROJECTNAME whitesourceft/dockerua
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
docker run --rm --name dockerua --mount type=bind,source=%SCANDIR%,target=/home/wss-scanner/Data/ -e WS_APIKEY=%WS_APIKEY% -e WS_PRODUCTNAME=%WS_PRODUCTNAME% -e WS_PROJECTNAME=%WS_PROJECTNAME% whitesourceft/dockerua
```
