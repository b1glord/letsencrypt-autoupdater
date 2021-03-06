#!/bin/sh

MONTH=`date +%-m`

if [[ $(( $MONTH % 2 )) -eq 0 ]]; then
    exit;
fi

LINK=$(readlink -f "$0");

if [ -z $LINK ]; then
    DIR=$PWD
else
    DIR=$(dirname $LINK);
fi

cd $DIR

if [ -z $LETSENCRYPT_BASE_DIR ]; then

    if [ ! -f ./.env ]; then
	    echo 'Warning: .env file missing';
    else
        source ./.env
    fi

    if [ -z $LETSENCRYPT_BASE_DIR ]; then
      LETSENCRYPT_BASE_DIR=$PWD
      echo 'Warning: LETSENCRYPT_BASE_DIR not defined, using current directory: ' $LETSENCRYPT_BASE_DIR
    fi

fi

cd ${LETSENCRYPT_BASE_DIR}

printf "Updating Certificates ... \n\n"

./letsencrypt-auto -c /etc/letsencrypt/cli.ini certonly

printf "reloading httpd\n";
systemctl reload httpd;

