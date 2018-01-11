#### Создание сертификата
certbot certonly --agree-tos --email $EMAIL -d $DOMAIN --standalone --preferred-challenges http


docker volume create domain.ssl
docker run --restart always -ti -d -e CONTAINER=domain -v domain.ssl:/etc/letsencrypt/ -v /var/run/docker.sock:/var/run/docker.sock -e EMAIL=login@mymail.ru -e DOMAIN=domain --hostname certbot --name certbot wumvi/certbot

docker exec -ti certbot bash




#!/bin/bash
cd /opt/certbot
certbot renew --renew-hook "service postfix reload" --renew-hook "service dovecot restart"  -q > /var/log/certbot-renew.log | mail -s "CERTBOT Renewals" $EMAIL  < /var/log/certbot-renew.log
exit 0


/var/log/letsencrypt/letsencrypt.log


openssl x509 -checkend 432000 -noout -in /etc/letsencrypt/live/$DOMAIN_FOLDER/cert.pem


apt-get --no-install-recommends -qq -y install sendmail
mail -s "CERTBOT Renewals" $EMAIL