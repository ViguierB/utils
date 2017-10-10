#!/bin/bash

echo -n Password: 
read -s password
echo
token=$(echo -e "import hashlib\nprint (hashlib.sha512(bytes(\"$password\", 'utf8')).hexdigest(), end='')" | python3)
password="";
if ! blih -u benjamin.viguier@epitech.eu -t $token repository create $1; 
then
    echo "error"
    exit 1
fi
if ! blih -u benjamin.viguier@epitech.eu -t $token repository setacl $1 ramassage-tek r;
then
    echo "error"
    exit 1
fi
if ! blih -u benjamin.viguier@epitech.eu -t $token repository getacl $1;
then
    echo "error"
    exit 1
fi
token="";
