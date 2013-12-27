#!/bin/sh
# Simple script to set up clone of uusm.org
# DO NOT RUN ON SYSTEMS WITH MYSQL INSTALLED.  IT WILL NUKE ALL MYSQL DATA.

set -e
set -x

drupalmajor=6
drupalminor=28

# Don't use this password if your MySQL server is on the public internet
sqluser="root"
sqlrootpw="q9z7a1"

projectname="uusm-demo"

# Ubuntu packages we need to install and uninstall in order to
# reproduce everything cleanly.
pkgs="mysql-client-5.1 mysql-server-5.1 drush apache2 libapache2-mod-php5 php5-gd wkhtmltopdf"

do_nuke() {
    echo "=== Warning, destroying all mysql data; also removing $srctop ==="
    set -x
    sudo apt-get remove $pkgs || true
    sudo apt-get purge $pkgs || true
    sudo apt-get autoremove || true
}

do_deps() {
    echo "When prompted, enter $sqlrootpw for the sql root password."
    sleep 4
    set -x
    sudo apt-get install -y $pkgs
}

usage() {
    echo "Usage: $0 [nuke|deps]"
    echo "Example of how to create a Drupal project using git, and benchmark it."
    echo "DO NOT RUN ON SYSTEMS WITH MYSQL INSTALLED.  IT WILL NUKE ALL MYSQL DATA."
    echo "Run each of the verb in order (e.g. $0 nuke; $0 deps; ...)"
}

do_newdb() {
    mysqladmin -u $sqluser -p$sqlrootpw create uuccsm_drupal 
    mysql -u $sqluser -p$sqlrootpw  <<_EOF_
GRANT ALL PRIVILEGES ON uuccsm_drupal.* TO $sqluser@localhost IDENTIFIED BY '$sqlrootpw'; 
flush privileges; 
_EOF_
}

do_restoredb() {
    zcat ~/public_html/sites/default/files/backup_migrate/scheduled/UUCCSM-2013-12-25T23-08-03.mysql.gz > uusm.sql
    mysql -u $sqluser -p$sqlrootpw -D uuccsm_drupal <<_EOF_
source uusm.sql;
_EOF_
}

case $1 in
nuke) do_nuke;;
deps) do_deps;;
newdb) do_newdb;;
restoredb) do_restoredb;;
*) usage; exit 1;;
esac
