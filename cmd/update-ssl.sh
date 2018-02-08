#!/bin/bash

certbot renew --renew-hook "php "$CODE_UPDATE_FOLDER"run.php -s $CONTAINER" >> /dev/stdout

exit $@