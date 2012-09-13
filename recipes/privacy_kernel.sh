#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $script_dir/../config.sh

declare -A recipe_info	
recipe_info['id']="privacy_kernel"
recipe_info['hname']="Privacy Kernel"
recipe_info['output']="package"


KSRC=/usr/src/linux-source-$KERNEL_VERSION
DEB_PATTERN=(/usr/src/linux-{image,headers}-$KERNEL_VERSION."*"-privcoin_"*"_$ARCH.deb)


function info() {
	echo ${recipe_info[$1]}
}

function setup() {
	aptitude -y --without-recommends install \
		libncurses-dev \
		kernel-package \
		linux-source-$KERNEL_VERSION

	tar -C /usr/src -xf /usr/src/linux-source-$KERNEL_VERSION.tar.bz2
}

function needsSetup() {
	if [ -d /usr/src/linux-source-$KERNEL_VERSION ]; then
		return 1
	else
		return 0
	fi
}

function resetConfig() {
	cp -f /boot/config-$KERNEL_VERSION*-$ARCH $KSRC/.config
}

function copyConfig() {
	cp -f $script_dir/${recipe_info['id']}/config-$KERNEL_VERSION-$ARCH $KSRC/.config
}

function doPatch() {
	cd $KSRC
	for patchfile in $script_dir/${recipe_info['id']}/patches/*; do
		patch -p0 < $patchfile
	done
}

function build() {	
	exists && cleanTarget	
	
	cd $KSRC
	make-kpkg \
		-j $COMPILER_JOBS \
		--initrd \
		--revision $CUSTOM_KERNEL_REVISION \
		--append-to-version -$CUSTOM_KERNEL_NAME \
		kernel_image \
		kernel_headers
}

function cleanTarget() {
	for file in ${DEB_PATTERN[@]}; do
		if [[ -f $file ]]; then
			rm $file
		fi
	done
}

function cleanSetup() {
	rm -r $KSRC/
}

function copyPackage() {
	# $1 is target
	
	if ! $PRIVACY_KERNEL; then
		return 0
	fi	

	for file in ${DEB_PATTERN[@]}; do
		if [[ -f $file ]]; then
			cp $file $1/
		else
			echo "Kernel Image not found."
			return 1
		fi
	done
}

function exists() {
	for file in ${DEB_PATTERN[@]}; do
		if ! [[ -f $file ]]; then
			return 1
		fi
	done	
	return 0
}

function kernelMinor() {
	kernel_minor=$(cd $KSRC && make kernelversion | sed -n 's/.*3\.2\.\(..\).*/\1/p')
	echo $kernel_minor
}


case $1 in

	setup)
		if needsSetup; then
			echo "Setup build of privacy-kernel"
			setup
			copyConfig
			doPatch
		else
			echo "Nothing to do"
		fi
		;;

	*)
		$1 $2 $3
		;;
esac
