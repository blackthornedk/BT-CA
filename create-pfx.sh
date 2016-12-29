#!/bin/sh

if [ "$#" -lt 1 ]
then
    echo "Usage: $0 <domainname>"
    exit 1
fi

DOMAIN=$1
if [ ! -r $DOMAIN.crt ]
then
    echo "Cannot find certificate file: $DOMAIN.crt"
    exit 1
fi
if [ ! -r $DOMAIN.key ]
then
    echo "Cannot find certificate key: $DOMAIN.key"
    exit 1
fi

/usr/bin/openssl pkcs12 -export -out $DOMAIN.pfx -inkey $DOMAIN.key -in $DOMAIN.crt

