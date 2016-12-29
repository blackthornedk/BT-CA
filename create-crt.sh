#!/bin/sh

if [ "$#" -lt 1 ]
then
    echo "Usage: $0 <domainname>"
    exit 1
fi

CA_NAME="`basename \`dirname \\\`readlink -f $0\\\`\``"
DOMAIN=$1
SERIAL="`cat $CA_NAME.serial`"

echo "Create key for $DOMAIN"
echo "Serial: $SERIAL"

/usr/bin/openssl genrsa -out $DOMAIN.key 2048
/usr/bin/openssl req -new -key $DOMAIN.key -days 365 -sha256 -out $DOMAIN.csr
/usr/bin/openssl x509 -req -in $DOMAIN.csr -days 365 -sha256 -CA $CA_NAME.crt -CAkey $CA_NAME.key -set_serial $SERIAL -out $DOMAIN.crt
/usr/bin/openssl x509 -in $DOMAIN.crt -text -noout > $DOMAIN.info
/usr/bin/openssl verify -CAfile $CA_NAME.crt $DOMAIN.crt || exit 1

SERIAL=$(($SERIAL+1))
echo "$SERIAL" > $CA_NAME.serial

