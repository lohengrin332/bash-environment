#!/bin/bash

/usr/bin/sudo /usr/bin/rsync -aP /etc /home /var/svn /opt/storage/
/usr/bin/sudo /usr/bin/rsync -aP /opt/storage/* /opt/backup/ --exclude movies
