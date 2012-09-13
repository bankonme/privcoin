#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $script_dir/../config.sh

declare -A recipe_info	
recipe_info['id']="bitcoin"
recipe_info['hname']="Bitcoin (Satoshi Client)"
recipe_info['output']="files"

build_dir=$TMP/${recipe_info['id']}
target_qt=$build_dir/bitcoin/bitcoin-qt


function info() {
	echo ${recipe_info[$1]}
}

function setup() {
	[[ ! -d $build_dir ]] && mkdir -p $build_dir	
	
	cd $build_dir
	if ! [[ -d bitcoin ]]; then
		git clone https://github.com/bitcoin/bitcoin.git
		cd $build_dir/bitcoin		
		git checkout "$BITCOIN_VERSION"
	fi

	if ! [[ -f $build_dir/bitcoin/miniupnpc.tar.gz ]]; then
		wget -O $build_dir/miniupnpc.tar.gz \
			"http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-1.7.tar.gz"
		tar -C $build_dir/bitcoin/ -xf $build_dir/miniupnpc.tar.gz
	fi

	
	aptitude -y --without-recommends install \
		qt4-qmake \
		libqt4-dev \
		build-essential \
		libboost-dev \
		libboost-system-dev \
		libboost-filesystem-dev \
		libboost-program-options-dev \
		libboost-thread-dev \
		libssl-dev \
		libdb5.1++-dev	
}

function build() {
	cd $build_dir/bitcoin

	if ! [[ -h build/miniupnpc ]]; then
		[[ ! -d build ]] && mkdir build
		make -C miniupnpc-1.7
		ln -s ../miniupnpc-1.7 build/miniupnpc
	fi

	exists && rm $target_qt #Force Build

	qmake "RELEASE=1" "USE_UPNP=0"
	make -j $COMPILER_JOBS
}

function copyFiles() {
	mkdir -p $1/usr/bin	
	cp $target_qt $1/usr/bin/
}

function exists() {
	[[ -f $target_qt ]]
	return $?
}

$1 $2
