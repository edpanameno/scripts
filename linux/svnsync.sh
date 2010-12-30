#!/bin/bash

#
# Description: This script will backup the changes that have
# been made to any one of your subversion repositories.  All
# Subversion repositories are stored in /www/svn/.
# 
# Date Created: Dec. 7th, 2007
# Moved to github on 12/30/10 

rsync -av /www/svn/ ~/data/backups/svn

# I want to show how big my SVN Repositories are
echo "SVN Backup Directory Size:" 
du -hs ~/data/backups/svn

