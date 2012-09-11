#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $script_dir/wraplib.sh

args=$(getArg "Select Armory-Datadir: (Cancel for defaults)" "--datadir ")" "$(getArg "Select Bitcoin-Datadir: (Cancel for defaults)" "--satoshi-datadir ")

eval python /usr/share/armory/ArmoryQt.py ${args}
