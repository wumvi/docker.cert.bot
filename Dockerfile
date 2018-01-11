FROM wumvi/php
MAINTAINER Vitaliy Kozlenko <vk@wumvi.com>

LABEL version="1.0"

ENV LOG_FILES /var/log/cron.log /var/log/certbot-renew.log

ADD common-files/lib-utils  /
ADD certbot/cmd/  /
ADD common-files/multi-tail.sh  /
ADD certbot/conf/ /root/conf/

ENV CODE_UPDATE_FOLDER /docker-exec/

RUN DEBIAN_FRONTEND=noninteractive && \
    rm /etc/apt/sources.list && \
	
    echo "deb http://mirror.yandex.ru/debian stretch main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirror.yandex.ru/debian stretch main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirror.yandex.ru/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirror.yandex.ru/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
	
    apt-get update && \
	
    apt-get --no-install-recommends -qq -y install wget vim git gnupg apt-transport-https lsb-release ca-certificates procps cron certbot openssl && \
	
	cd / && \
	git clone https://github.com/wumvi/docker.exec.git $CODE_UPDATE_FOLDER --depth=1 && \
	cd $CODE_UPDATE_FOLDER && \
	composer install --no-interaction --no-dev --no-progress --no-suggest --optimize-autoloader --prefer-dist --ignore-platform-reqs --no-plugins && \
	rm -rf .git && \
	
	crontab /root/conf/crontab.txt && \
	
    mkfifo --mode 0666 $LOG_FILES && \
    chmod +x /*.sh && \
	
	apt-get remove -y git && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
	
	echo 'end'
	
	
WORKDIR /root/

CMD [ "/start.sh" ]