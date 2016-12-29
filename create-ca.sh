#!/bin/sh

CA_NAME="`basename \`dirname \\\`readlink -f $0\\\`\``"

if [ -f $CA_NAME.key ] || [ -f $CA_NAME.crt ] || [ -f $CA_NAME.serial ]
then
    echo "CA already created!"
    exit 1
fi

/usr/bin/openssl genrsa -out $CA_NAME.key 2048
/usr/bin/openssl req -new -x509 -sha256 -days 3650 -key $CA_NAME.key -out $CA_NAME.crt
/usr/bin/openssl rsa -in $CA_NAME.key -des3 -out $CA_NAME.key
/usr/bin/openssl x509 -in $CA_NAME.crt -text -noout > $CA_NAME.info
/usr/bin/openssl verify -CAfile $CA_NAME.crt $CA_NAME.crt || exit 1
echo 1 > $CA_NAME.serial

