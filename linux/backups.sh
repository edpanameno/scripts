#!/bin/bash

# This script will be used to backup
# both my svn repositories and my wiki
# database.
# 
# Modification History:
# - Created: 12/10/2009 @ 7:23 p.m.
# - Moved to github: 12/30/10 @ 2:00 p.m. And
#   removed passwords and other misc comments.

################################################
#################### SVN #######################
################################################
# Varibles that hold the path of the source and
# destination of the backup.
SVN_REPOS_DIR=/var/www/svn-repos

# The two different directories where the svn backups
# will be stored in.
SVN_BACKUP_DIR=~/data/backups/svn
#SVN_BACKUP_DIR1=~/data1/backups/svn

echo "Backing up to $SVN_BACKUP_DIR."
rsync -av $SVN_REPOS_DIR $SVN_BACKUP_DIR

#echo "Backing up to $SVN_BACKUP_DIR1."
#rsync -av $SVN_REPOS_DIR $SVN_BACKUP_DIR1

# I want to show how big my SVN Repositories are
echo "$SVN_BACKUP_DIR Directory Size:" 
du -hs $SVN_BACKUP_DIR 

################################################
################### WIKI #######################
################################################
WIKI_DB_NAME=wiki_db
WIKI_DB_USER=wikiuser
WIKI_DB_USER_PASSWORD=

WIKI_BACKUP_NAME=wiki_db.sql
WIKI_BACKUP_DIR=~/data/backups/mysql/$WIKI_BACKUP_NAME 
#WIKI_BACKUP_DIR1=~/data1/backups/mysql/$WIKI_BACKUP_NAME 

# backup to main backup dir (data)
mysqldump -u $WIKI_DB_USER -p$WIKI_DB_USER_PASSWORD $WIKI_DB_NAME > $WIKI_BACKUP_DIR

# backup to secondary backup dir (data1)
#mysqldump -u $WIKI_DB_USER -p$WIKI_DB_USER_PASSWORD $WIKI_DB_NAME > $WIKI_BACKUP_DIR1

echo "wiki_db size:"
du -hs $WIKI_BACKUP_DIR 

