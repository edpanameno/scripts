#!/bin/bash

##
## This script will allow you to backup the cms
## database on your mysql server. It will also
## backup the contents of the wiki.
##
## Created: Dec. 12th, 2010
##

DB_HOST=""
DB_NAME=""
DB_USERNAME=""
DB_PASSWORD=""
DB_FOLDER="db"
DB_FILENAME="cms_db.sql"

WIKI_LOCATION=""
WIKI_FILES="wiki.d"
WIKI_UPLOADS="uploads"
WIKI_FOLDER="wiki"

BACKUP_FOLDER="/home/$USER/backups"

# Check to make sure that the backup directory
# exits first, if not then create it!
if [ ! -e $BACKUP_FOLDER ]; then
	mkdir -p /home/$USER/backups/
fi

# Now check to see if the wiki folder under the
# backups directory exists, if not create it
if [ ! -e $BACKUP_FOLDER/$DB_FOLDER ]; then
	mkdir -p /home/$USER/backups/
fi

# Check to see that the wiki folder exists under
# backups folder, if not create it
if [ ! -e $BACKUP_FOLDER/$WIKI_FOLDER ]; then
	mkdir -p /home/$USER/backups/$WIKI_FOLDER
fi

# We first check to see if a backup of the database
# already exists, if so then we remove it so that
# we can create a new backup of the database
if [ -e $BACKUP_FOLDER/$DB_FOLDER/$DB_FILENAME ]; then
	rm $BACKUP_FOLDER/$DB_FOLDER/$DB_FILENAME
fi

mysqldump -u $DB_USERNAME -p$DB_PASSWORD $DB_NAME > $BACKUP_FOLDER/$DB_FOLDER/$DB_FILENAME

## Backups of the wiki are accomplished by using rsync to do
## incremental backups of the content on the wiki.
# pmwiki doesn't use a database as a backend and stores it content
# on the file system. 
#echo "Backing up \"$WIKI_FILES\""
rsync -av $WIKI_LOCATION/$WIKI_FILES $BACKUP_FOLDER/$WIKI_FOLDER/$WIKI_FILES

# wiki uploads are where your images and files that have
# been uploaded to the wiki are stored
#echo "Backing up \"$WIKI_UPLOADS\""
rsync -av $WIKI_LOCATION/$WIKI_UPLOADS $BACKUP_FOLDER/$WIKI_FOLDER/$WIKI_UPLOADS

