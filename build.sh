#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $script_dir/config.sh


function setup() {
	for recipe in $script_dir/recipes/*.sh; do
		echo "===Setup: "$($recipe info hname)" ==="
		$recipe setup
	done
}

function build() {
	for recipe in $script_dir/recipes/*.sh; do
		echo "===Build: "$($recipe info hname)" ==="
		
		if $recipe exists; then
			echo "Skipping "$($recipe info hname)" --> Already exists"
		else
			$recipe build 2>&1 | tee build_$($recipe info id).log
		fi
	done
}

function copy() {
	for recipe in $script_dir/recipes/*.sh; do
		echo "===Copy: "$($recipe info hname)" ==="
		if [[ "package" == $($recipe info output) ]]; then
			$recipe copyPackage $script_dir/config/packages.chroot
		elif [[ "files" == $($recipe info output) ]]; then
			$recipe copyFiles $script_dir/config/includes.chroot
		fi
	done
}


$1 $2 $3 $4
