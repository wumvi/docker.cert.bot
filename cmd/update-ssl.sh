#!/bin/bash

certbot renew --renew-hook "/hook.sh -s $CONTAINER" >> /var/log/certbot-renew.log