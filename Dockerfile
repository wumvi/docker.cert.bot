FROM wumvi/php.base
MAINTAINER Vitaliy Kozlenko <vk@wumvi.com>

LABEL version="1.0.2"

ADD cmd/  /
ADD conf/ /root/conf/

ENV CODE_UPDATE_FOLDER /cron.ssl/

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get --no-install-recommends -qq -y install wget vim git gnupg apt-transport-https lsb-release ca-certificates procps cron certbot openssl && \
	#
	cd / && \
	git clone https://github.com/wumvi/docker.exec.git $CODE_UPDATE_FOLDER --depth=1 && \
	cd $CODE_UPDATE_FOLDER && \
	composer install --no-interaction --no-dev --no-progress --no-suggest --optimize-autoloader --prefer-dist --ignore-platform-reqs --no-plugins && \
	rm -rf .git && \
	#
	crontab /root/conf/crontab.txt && \
	#
    chmod +x /*.sh && \
	#
	apt-get remove -y git && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
	#
	echo 'end'

WORKDIR /cron.ssl/

CMD [ "/start.sh"]

HEALTHCHECK --interval=1m --timeout=1s CMD find /tmp/ . -cmin -3 -name cron_healthcheck.txt | egrep '.*'