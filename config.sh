#General Settings
CONF_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP=$CONF_BASE_DIR/tmp

ARCH=amd64
COMPILER_JOBS=9
LOCALE=en_US.UTF-8 #de_DE.UTF-8
KEYBOARD=en #de
BUILD_FOR_CD=true
NO_VIRTUALBOX=false


#Bitcoin-QT
BITCOIN_VERSION="v0.6.3"

#Armory
ARMORY_VERSION="v0.81-alpha"
ARMORY_DEBIAN_VERSION="0.81-1"


#Kernels
declare -A CUSTOM_KERNEL_HNAME

#Custom Offline Privacy-Kernel
PRIVACY_KERNEL=true
KERNEL_VERSION=3.2
KERNEL_VERSION_ESCAPED=$(echo $KERNEL_VERSION | sed 's/\./\\./g')
KERNEL_VERSION_REGEX="linux-image-($KERNEL_VERSION_ESCAPED\.[0-9]{1,2}-[0-9]{1,2})-$ARCH"
CUSTOM_KERNEL_NAME=privcoin
CUSTOM_KERNEL_REVISION=10.00.PrivCoin
CUSTOM_KERNEL_HNAME[privcoin]="Privacy Kernel"


#Helpers
[[ ! -d $TMP ]] && mkdir -p $TMP

#DEBIAN_KERNEL_VERSION=$(aptitude -F"%p" search $KERNEL_VERSION_REGEX'$' | sed -n 's/'$(echo $KERNEL_VERSION_REGEX | sed 's/[(){}$]/\\\0/g')'/\1/gp')
