#!/bin/bash

# get current path
reldir=`dirname $0`
cd $reldir
DIR=`pwd`

# Colorize and add text parameters
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldylw=${txtbld}$(tput setaf 3) #  yellow
bldblu=${txtbld}$(tput setaf 4) #  blue
bldppl=${txtbld}$(tput setaf 5) #  purple
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             # Reset

DEVICE="$1"
SYNC="$2"
THREADS="$3"

# get current version
VERSION=`date +%Y%m%d`

# get time of startup
res1=$(date +%s.%N)

# we don't allow scrollback buffer
echo -e '\0033\0143'
clear

echo -e "${cya}Building ${bldgrn}B ${bldppl}A ${bldblu}M ${bldylw}v$VERSION ${txtrst}";

# sync with latest sources
echo -e ""
if [ "$SYNC" == "sync" ]
then
   echo -e "${bldblu}Syncing latest jellybam sources ${txtrst}"
   repo sync -j"$THREADS"
   echo -e ""
fi

# setup environment
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh

# lunch device
echo -e ""
echo -e "${bldblu}Lunching your device ${txtrst}"
lunch "jellybam_$DEVICE-userdebug";

echo -e ""
echo -e "${bldblu}Starting to build jellybam ${txtrst}"

# start compilation
brunch "jellybam_$DEVICE-userdebug" -j"$THREADS";
echo -e ""

# finished? get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"

# Full rom builder
echo -e "now building the full rom package"
cd out/target/product/$DEVICE/ && mkdir tmp;
cd out/target/product/$DEVICE/ && mv jelly*.zip tmp/;
cd out/target/product/$DEVICE/tmp/ && unzip *.zip;
cd out/target/product/$DEVICE/tmp/ && rm -f system/app/Provision.apk system/app/QuickSearchBox.apk system/app/SetupWizard.apk system/app/Velvet.apk;
cd out/target/product/$DEVICE/tmp/ && cp -r jellybam/$DEVICE/system/* system/;
cd out/target/product/$DEVICE/tmp/ && rm -f *.zip;
cd out/target/product/$DEVICE/tmp/ && zip -r -q jellybam_$DEVICE.STABLE_4.0.0_$(date "+%Y%m%d").zip *;
cd out/target/product/$DEVICE/tmp/ && mv jell*.zip /var/rom/final/nightlies/;
cd out/target/product/$DEVICE/ && rm -f -r tmp && rm -f jellyb*;

