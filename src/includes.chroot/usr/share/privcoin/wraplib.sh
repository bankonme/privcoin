#!/bin/bash

function getDir() {
	zenity \
		--file-selection \
		--directory \
		--title="$1" \
		--text="$1"
}

function getArg() {
	tmp=$(getDir "$1")
	if [[ $? -eq 0 ]]; then
		echo "$2""\"$tmp\""
	fi
}
