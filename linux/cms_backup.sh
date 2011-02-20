#!/bin/bash

##
## This script will allow you to backup the cms
## database on your mysql server. It will also
## backup the contents of the wiki.
##
## Created: Dec. 12th, 2010
## Last Modified: Feb 19th, 2011 @ 4:07 p.m.
##

DB_HOST=""
DB_NAME=""
DB_USERNAME=""
DB_PASSWORD=""
DB_FOLDER="db"
DB_FILENAME="cms_db.sql"

# the wiki location is where the wiki is installed.
# By default, this is located on the root of the 
# web site for the cms application. For example, if
# you have installed the web application on your 
# public home directory, then the path to the wiki
# should be as follows:
#	 /home/user/public_html/cms/wiki
WIKI_LOCATION=""

# These are the folders that will be used to 
# backup the wiki.  Note: the WIKI_FILES AND 
# WIKI_UPLOADS values that you see here are 
# for a default installation of the pmwiki
# software included.  If you changed this 
# on your installation, make the appropriate
# changes here.
WIKI_FILES="wiki.d"
WIKI_UPLOADS="uploads"
WIKI_FOLDER="wiki"

# this is the location where you want to store
# your backups
BACKUP_FOLDER=""

# Check to make sure that the backup directory
# exits first, if not then create it!
if [ ! -e $BACKUP_FOLDER ]; then
	mkdir -p $BACKUP_FOLDER 
fi

# Now check to see if the wiki folder under the
# backups directory exists, if not create it
if [ ! -e $BACKUP_FOLDER/$DB_FOLDER ]; then
	mkdir -p $BACKUP_FOLDER/$DB_FOLDER
fi

# Check to see that the wiki folder exists under
# backups folder, if not create it
if [ ! -e $BACKUP_FOLDER/$WIKI_FOLDER ]; then
	mkdir -p $BACKUP_FOLDER/$WIKI_FOLDER
fi

# We first check to see if a backup of the database
# already exists, if so then we remove it so that
# we can create a new backup of the database
if [ -e $BACKUP_FOLDER/$DB_FOLDER/$DB_FILENAME ]; then
	rm $BACKUP_FOLDER/$DB_FOLDER/$DB_FILENAME
fi

mysqldump -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME > $BACKUP_FOLDER/$DB_FOLDER/$DB_FILENAME

# Backups of the wiki are accomplished by using rsync to do
# incremental backups of the content on the wiki.
# pmwiki doesn't use a database as a backend and stores it content
# on the file system. 
rsync -av $WIKI_LOCATION/$WIKI_FILES $BACKUP_FOLDER/$WIKI_FOLDER/$WIKI_FILES

# wiki uploads are where your images and files that have
# been uploaded to the wiki are stored
rsync -av $WIKI_LOCATION/$WIKI_UPLOADS $BACKUP_FOLDER/$WIKI_FOLDER/$WIKI_UPLOADS

