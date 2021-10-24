# Dockerized Unifed-Agent

Refer to https://github.com/whitesource/unified-agent-distribution/blob/master/dockerized/README.md for customization and original setup directions

## Differences 

* Upgrade NodeJS to 12.x
* Downgrade Cocoapods to 1.10.2
* Uses ENV Variables & default values instead of a config file

## What's Installed??
### Full
* Java (1.8)
* Maven (3.5.4)
* Node.js (12.19.0)
* NPM (6.14.8)
* Yarn (1.5.1)
* Bower (1.8.2)
* Gradle (6.0.1)
* python 2.7 + 3.6 + 3.7 + 3.8 + pip + pip3 + pipenv
* Poetry (python)
* Ruby, rbenv and ruby-build
* Go (1.17.1)
* Scala 2.12.6, Sbt 1.1.6
* PHP (7.2)
* Composer
* PHP Plugins
* Mix, Hex, Erlang and Elixir
* Cocoapods (1.5.3)
* R + Packrat
* Haskel + Cabal
* dotnet-sdk-2.2, 3.1, 5.0, dotnet cli, Mono, and NuGet
* Paket
* Cargo

### Thin
* Java (1.8)
* Maven (3.5.4)
* Node.js (12.19.0)
* NPM (6.14.8)
* Yarn (1.5.1)
* Bower (1.8.2)
* Gradle (6.0.1)
* python 2.7 + 3.6 + 3.7 + 3.8 + pip + pip3 + pipenv
* dotnet-sdk-2.2, 3.1, 5.0, dotnet cli, Mono, and NuGet

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
* Required ENV Variables
    * WS_APIKEY
    * WS_PRODUCTNAME
    * WS_PROJECTNAME
    * SCANDIR
```
cd <your cloned directory>
export WS_APIKEY=<your-apikey>
export SCANDIR=$(pwd)
export WS_PRODUCTNAME=$(git config --get remote.origin.url | awk -F "/" '{print $4}')
export WS_PROJECTNAME=$(git config --get remote.origin.url | awk -F "/" '{print $5}' | awk -F "." '{print $1}')

docker run --rm --name dockerua \
--mount type=bind,source=$SCANDIR,target=/home/wss-scanner/Data/ \
-e WS_APIKEY=$WS_APIKEY \
-e WS_PRODUCTNAME=$WS_PRODUCTNAME \
-e WS_PROJECTNAME=$WS_PROJECTNAME dockerua:thin
```
