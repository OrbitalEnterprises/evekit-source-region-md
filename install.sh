#!/bin/bash
#
# Install script for tools.  Must be run at top of project directory after project is built.
#
# $1 - install dir
#
target=$1
mkdir -p ${target}
cp scripts/markethistory_driver ${target}
cp scripts/markethistory ${target}
cp scripts/orderbook_driver ${target}
cp scripts/orderbook ${target}
cp scripts/contracts_driver ${target}
cp scripts/contracts ${target}
jarfile=$(basename $(find target -name '*jar-with-dependencies*'))
cp target/${jarfile} ${target}
escapedloc=$(echo ${target}/${jarfile} | sed -e 's/\//\\\//g')
cat scripts/ekdptool | sed -e "s/INSTALLCONFIG/${escapedloc}/g" > ${target}/ekdptool
chmod ugo+rx ${target}/ekdptool
