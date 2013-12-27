#!/bin/sh
secret="\
sites/default/files/newsletters/* \
sites/default/files/members-only/* \
"

tar -czvf secret.tgz $secret
rm -rf $secret

echo "Now go and delete all the real users.  There's no drush command for this, alas."
