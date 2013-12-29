uusm-demo
=========

To set up a clone of the uusm web site:

1. Install a fresh copy of Ubuntu 10.04 in a real or virtual machine.
For convenience, on Ubuntu 12.04 or later, you can set one up in an
lxc container with

    sh busyuusm.sh createlxc

2. Log into the Ubuntu 10.04 system and install dependencies with

    sh busyuusm.sh deps

3. Create an empty database with

    sh busyuusm.sh newdb

4. Unpack the sanitized tarball of the web site:

    tar -C $HOME -xzvf public_html-sanitized.tgz

5. Restore the database (this takes 20 minutes on my laptop):

    zcat ~/public_html/sites/default/files/backup_migrate/manual/UUCCSM-2013-12-27T15-37-17.mysql.gz > uusm.sql
    sh busyuusm.sh restoredb

6. Edit /etc/apache2/sites-available/default to say

    DocumentRoot /home/ubuntu/public_html
    <Directory />
            Options FollowSymLinks
            AllowOverride All
    </Directory>

   and enable mod_rewrite with

    sudo a2enmod rewrite

   then do sudo service apache2 restart.

7. Find the IP address of the web server with 'ifconfig',
   and plop it into ~/public_html/sites/default/settings.php
   in the base_url variable.

8. Make sure /usr/tmp exists, e.g.

    sudo ln -s /var/tmp /usr/tmp

9. Make sites/defaults/files writable by the web server, e.g. (insecure!)

    chmod -R 777 ~/public_html/sites/default/files

10. In a web browser running on the host, visit that IP address.
   You should see the uusm web site come up!
   (If you want to see the web site from other systems, you
    may need to configure the virtual machine's networking to give
    it a real IP address on your LAN.)

11. Log in to the site via the web browser using username 'admin'
   and password 'spamuusm99'.   (The log in link uses Lightbox2,
   which didn't work for me when I followed these instructions;
   if that happens, append /user to the main url to get a login page.)

12. Go to /admin/reports/status and make sure it's not too upset
   (it will probably complain that wkhtmltopdf is an unsupported version),
   then click on 'Run cron manually'.  This takes several minutes.
   Visit /admin/settings/search and verify that 5% or so of the site
   has been indexed.
   Verify that searching for 'sermon' or 'the' finds a document or two.

Known issues compared to live site:

a. /user/login/lightbox2 doesn't work (use /user)
b. /admin/reports/status complains that wkhtmltopdf is unsupported version
c. Menu items in left sidebar of main page have turds on end
   (probably some plugin out of date with respect to this version of php)

