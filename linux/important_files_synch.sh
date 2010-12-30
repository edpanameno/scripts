#!/bin/bash

#
# This file will be used to backup important 
# files in my current installation of Linux 
# which is my primary server (Mainsrv).
# I will be using rsync to keep the files 
# synchronized
#

# apache configuration file
rsync -av /etc/httpd/conf/httpd.conf ~/data/backups/important_files/httpd.conf.bak

# svn/apcahe configuration file
rsync -av /etc/httpd/conf.d/subversion.conf ~/data/backups/important_files/subversion.conf.bak

# samba configuration file
rsync -av /etc/samba/smb.conf ~/data/backups/important_files/smb.conf.bak

# wiki LocalSettings.php
rsync -av /www/wiki/LocalSettings.php ~/data/backups/wiki/LocalSettings.php

