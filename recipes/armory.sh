#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $script_dir/../config.sh

declare -A recipe_info	
recipe_info['id']="armory"
recipe_info['hname']="Bitcoin Armory"
recipe_info['output']="package"

build_dir=$TMP/${recipe_info['id']}
target=$build_dir/armory_${ARMORY_DEBIAN_VERSION}_$ARCH.deb

function info() {
	echo ${recipe_info[$1]}
}

function setup() {
	aptitude -y --without-recommends install \
		debhelper \
		dh-make \
		git-core \
		build-essential \
		libcrypto++-dev \
		swig \
		libqtcore4 \
		libqt4-dev \
		python-qt4 \
		python-dev \
		python-twisted \
		pyqt4-dev-tools

	if ! [[ -d $build_dir ]]; then
		mkdir $build_dir
		cd $build_dir		
		git clone git://github.com/etotheipi/BitcoinArmory.git
		cd BitcoinArmory
		git checkout "$ARMORY_VERSION"
		sed -i 's/dh_make -s -e/dh_make -s -y -e/' dpkgfiles/make_deb_package.py
	fi
}

function build() {
	exists && rm $target #Force Build

	cd $build_dir/BitcoinArmory
	python dpkgfiles/make_deb_package.py
}

function copyPackage() {
	cp $target $1/
}

function exists() {
	[[ -f $target ]]
	return $?
}

$1 $2
