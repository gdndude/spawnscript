#!/bin/bash
#Creates a new spawn_assets gem from git
#Also based on the environment variable BUILD_NUMBER or 
#this can be passed on command line, command line version takes precedence
#for in-flight build versions the build will pull from the HEAD branch

TMP="/tmp"
PACKAGE="spawnpoc"
VERSION="master"
if [ -n "${BUILD_NUMBER:+x}" ]
	then VERSION=$BUILD_NUMBER
fi

if [ -n "${1:+1}" ]
	then VERSION=$1
fi
echo $VERSION

#Retrieve the correct version into a tmp directory
cd $TMP
#First let's clean out the working directory to avoid any issues
rm -rf $TMP/$PACKAGE
git clone -b $VERSION git://github.com/gdndude/spawnpoc.git

#Build the gem
cd $PACKAGE
gem build spawnpoc_assets.gemspec

#Check if there is an error
if [ $? -gt 0 ]
	then git tag build-failure-$VERSION
	else git tag build-success-$VERSION
fi 
git push --tags https://github.com/gdndude/spawnpoc.git
