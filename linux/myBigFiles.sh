#!/bin/bash

# A simple script that will give you the top n files that
# are taking up +/-n bytes on your home directory
# 
# To use this script, you must 

echo "Top $2 files at '$HOME' larger than $1"
echo "============================================="

while read line; do
	echo $line 
done < <(find $HOME -type f -size $1 -exec ls -si {} \; | awk '{print $2 "      " $3}' | sort -n -r | head -$2)

