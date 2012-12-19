#!/bin/bash
# build_spawn.sh  12/19/2012  Greg Newton gdndude@gmail.com
#Creates a new spawn_assets gem from git
#Also based on the environment variable BUILD_NUMBER or 
#this can be passed on command line, command line version takes precedence
#for in-flight build versions the build will pull from the HEAD branch

TMP="/tmp"
PACKAGE="spawnpocassets"
VERSION="0.0.1"
if [ -n "${BUILD_NUMBER:+x}" ]
	then VERSION=$BUILD_NUMBER
fi

if [ -n "${1:+1}" ]
	then VERSION=$1
fi
echo "Building " $VERSION

#Retrieve the correct version into a tmp directory
cd $TMP
#First let's clean out the working directory to avoid any issues
rm -rf $TMP/$PACKAGE
#Then we are going to remove the gem, strictly speaking this is not required but we're doing it to avoid confusion

gem uninstall spawnpocassets

git clone https://github.com/gdndude/spawnpocassets.git
cd $PACKAGE
git checkout $VERSION

#Build the gem and install it using the native tools, this makes the deb packing irrelevant
#But we will to that anyway since averyone asked so nicely

mkdir /var/assets/spawnpocassets/$VERSION
gem install spawnpocassets --install-dir=/var/assets/spawnpocassets/$VERSION

#Some of this is brute force, we're pushing the asset each time which might be redundant
gem push spawnpocassets-$VERSION.gem

#We install into the local CI environment to allow fpm to perform it's magic
bundle
rake -T
rake build
rake install
rake release

#Create a deb package using fpm and we will also go ahead and install it
gem fetch $PACKAGE --version $VERSION
fpm -s gem -t deb spawnpocassets-$VERSION.gem
dpkg --purge rubygem-$PACKAGE
dpkg --install *.deb
 
#Grab the CI build hash so that we can track build success and failures
BUILD=`git describe --all --long ` 
#Check if there is an error
if [ $? -gt 0 ]
	then git tag build-failure-$BUILD
	else git tag build-success-$BUILD
fi 

#We push an updated tag that indicates if $VERSION was built and deployed successfully or not
git push --tags 
