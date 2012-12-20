#Spawn POC Build script v0.1 12/19/2012

##Author:
	Greg Newton - gdndude@gmail.com

##Location:
	git@github.com:gdndude/spawnscript

##Summary:

	The build script is used to demonstrate a method of using Git, Rails and Ubuntu to achieve 
	a CI interaction that supports developers and testers.  The script uses a pre-built gem that will be used
	to house the assets of the Rails3 application and is packaged separately.  In the CI environment
	the gem is installed natively and a deb package is created and also installed.  This was done to show flexibility 
	on a single server, but in real use likely the later option would be chosen.

##Usage:

	The script is directly usable from Git and expects a bash interpreter, no specific installation or build steps are required.


##From the installation directory

	./build_spawn.sh <version>
	
	If the version number is missing (ex 0.0.1)  then the script uses the environment value of
	BUILD_NUMBER.  In the event both are present the command line value takes precedence.  If neither 
	are present the script will pull from <HEAD>.

##Installation Directories:

	The script can be installed anywhere, but it does expect certain directories to exist for deploying the gem, 
	the values of these directories as well as package and asset names can be modified in the script variables declarations

	/tmp  <Working area for git clone>
	/var/assets/spawnpocassets <A directory corresponding to the version # will be added>



##Example:

	The following is an example of using the script to retrieve version 0.0.1 of the spawnpocassets gem

		$ root@ubuntu-poc:/spawn/working/scripts# ./build_spawn.sh 0.0.1
		Successfully uninstalled spawnpocassets-0.0.1
		Cloning into 'spawnpocassets'...
		remote: Counting objects: 24, done.
		remote: Compressing objects: 100% (17/17), done.
		remote: Total 24 (delta 5), reused 21 (delta 2)
		Unpacking objects: 100% (24/24), done.
 		Building from  0.0.1
		Note: checking out '0.0.1'.

		You are in 'detached HEAD' state. You can look around, make experimental
		changes and commit them, and you can discard any commits you make in this
		state without impacting any branches by performing another checkout.

		If you want to create a new branch to retain commits you create, you may
		do so (now or later) by using -b with the checkout command again. Example:

  		git checkout -b new_branch_name

		HEAD is now at 7c5d9dc... Updating gemspec to include package information
		Successfully installed spawnpocassets-0.0.2
		1 gem installed
		Installing ri documentation for spawnpocassets-0.0.2...
		Installing RDoc documentation for spawnpocassets-0.0.2...
		Pushing gem to https://rubygems.org...
		Fetching gem metadata from https://rubygems.org/..
		Using spawnpocassets (0.0.1) from source at /tmp/spawnpocassets 
		Using bundler (1.2.3) 
		Your bundle is complete! Use `bundle show [gemname]` to see where a bundled gem is installed.
		rake build    # Build spawnpocassets-0.0.1.gem into the pkg directory
		rake install  # Build and install spawnpocassets-0.0.1.gem into system gems
		rake release  # Create tag v0.0.1 and build and push spawnpocassets-0.0.1.gem to Rubygems
		spawnpocassets 0.0.1 built to pkg/spawnpocassets-0.0.1.gem
		spawnpocassets 0.0.1 built to pkg/spawnpocassets-0.0.1.gem
		spawnpocassets (0.0.1) installed
		Tasks: TOP => release
		(See full trace by running task with --trace)
		Fetching: spawnpocassets-0.0.1.gem (100%)
		Downloaded spawnpocassets-0.0.1
		Successfully installed spawnpocassets-0.0.1
		1 gem installed
		Created deb package {"path":"rubygem-spawnpocassets_0.0.1_all.deb"}
		Selecting previously unselected package rubygem-spawnpocassets.
		(Reading database ... 65559 files and directories currently installed.)
		Unpacking rubygem-spawnpocassets (from rubygem-spawnpocassets_0.0.1_all.deb) ...
		Setting up rubygem-spawnpocassets (0.0.1) ...
		Total 0 (delta 0), reused 0 (delta 0)
		To https://github.com/gdndude/spawnpocassets.git
 		* [new tag]         build-success-0.0.1-0-g7c5d9dc -> build-success-0.0.1-0-g7c5d9dc

#Dependencies:

	Any recent linux debian based linux environment will work, with a slight alteration any linux can be used 
	as either the CI/Build server or the target.

#The following base packages are required (Ubuntu 12.10)

	rails3
	ruby
	fpm
	rake
	
	

