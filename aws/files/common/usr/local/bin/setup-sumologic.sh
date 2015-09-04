#!/bin/bash

SLROLE="spt-microservices"

set -e

if [ -f /etc/sumo.conf ]
then
	#Parse user-data
	userdata=$(curl --silent "http://169.254.169.254/latest/user-data/")
	if [[ "${userdata}" =~ CLOUD_ENVIRONMENT[[:blank:]]*=[[:blank:]]*\"?([[:alnum:]._-]+)\"? ]]
	then
		CLOUD_ENVIRONMENT=${BASH_REMATCH[1]}
	fi

	if [[ "${userdata}" =~ CLOUD_APP[[:blank:]]*=[[:blank:]]*\"?([[:alnum:]._-]+)\"? ]]
	then
		CLOUD_APP=${BASH_REMATCH[1]}
	fi
	EC2_INSTANCE_ID=$(curl -s 'http://169.254.169.254/latest/meta-data/instance-id')
	slname="${SLROLE}-${CLOUD_ENVIRONMENT}-${CLOUD_APP}-${HOSTNAME}"
	echo "name=${slname}" >> /etc/sumo.conf
	chkconfig collector on
	service collector start
	sleep 6
	rm -f /etc/sumo.conf
	logger -t setup-sumologic.sh -p user.info -s "INFO instance ${EC2_INSTANCE_ID} SL ${slname} ready"
fi
