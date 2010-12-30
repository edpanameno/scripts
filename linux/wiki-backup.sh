#!/bin/bash

# 
# This small script will backup my wiki_db 
# Created: Feb 10th, 2008 @ 8:35 p.m.
#

## password removed, but is required after -p
mysqldump -u wikiuser -p<pass_word> wiki_db > ~/data/backups/mysql/wiki_db.sql
echo "wiki_db size:"
du -hs ~/data/backups/mysql 

