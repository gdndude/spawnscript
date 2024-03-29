#!/bin/bash
# build_spawn.sh  12/19/2012  Greg Newton gdndude@gmail.com
#Creates a new spawn_assets gem from git
#Also based on the environment variable BUILD_NUMBER or 
#this can be passed on command line, command line version takes precedence
#for in-flight build versions the build will pull from the HEAD branch

TMP="/tmp"
PACKAGE="spawnpocassets"
VERSION=""
INSTALLDIR="/var/assets/spawnpocassets/"

#Check to see if a version number is set or passed
	
	if [ -n "${BUILD_NUMBER:+x}" ]
		then VERSION=$BUILD_NUMBER
	fi

	if [ -n "${1:+1}" ]
		then VERSION=$1
	fi

#Retrieve the correct version into a temp directory
	
	cd $TMP

#First let's clean out the working directory to avoid any issues

	rm -rf $TMP/$PACKAGE

#Then we are going to remove the existing gem, strictly speaking 
#this is not required but we're doing it to avoid confusion

	gem uninstall spawnpocassets

#Clone the head repository, we extract out the tag (version) later as needed

	git clone https://github.com/gdndude/spawnpocassets.git

#In the event the VERSION was empty we sync to head now 

	if [ -z "$VERSION" ]
		then VERSION=`git describe --all`
	fi

	echo " Building from " $VERSION
	cd $PACKAGE
	git checkout $VERSION

#Build the gem and install it using the native tools, this makes the deb packing irrelevant
#But we will to that anyway since averyone asked so nicely


	INSTALLDIR=$INSTALLDIR$VERSION
	mkdir $INSTALLDIR

	gem install spawnpocassets --install-dir=$INSTALLDIR

#Some of this is brute force, we're pushing the asset each time which might be redundant
#Consider using a yank in the future, or checking the existing gem for integrity

	gem push $PACKAGE-$VERSION.gem

#We install into the local CI environment to allow fpm to perform it's magic

	bundle
	rake -T
	rake build
	rake install
	rake release

#Create a deb package using fpm and we will also go ahead and install it
#First we remove the old package if it exists

	gem fetch $PACKAGE --version $VERSION
	fpm -s gem -t deb $PACKAGE-$VERSION.gem
	dpkg --purge rubygem-$PACKAGE > /dev/null
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

#That's it hombre
