#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $script_dir/wraplib.sh

args="${args} "$(getArg "Select Datadir: (Cancel for defaults)" "-datadir=")
eval /usr/bin/bitcoin-qt ${args}
