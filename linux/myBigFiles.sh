#!/bin/bash

# A simple script that will show you the biggest files on
# the specified directory. Two parameters are needed for
# this script to run, the first one being the location and
# the second one being the size of the files
RESULT=`find $1 -type f -size +$2M -print -exec ls -s {} \; | awk '{print $1 " " $2}' | sort -n`

for ENTRY in $RESULT
do
	echo $ENTRY
done

