#!/bin/bash
# This will generate every possible local MAC address available.  Works on any system that can run the bash shell.
localoctet="26AE"
hexchars="0123456789ABCDEF"
local=$( echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; echo -n ${localoctet:$(( $RANDOM % 4 )):1} )
mac=$( for i in {1..10} ; do echo -n ${hexchars:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
echo $local$mac