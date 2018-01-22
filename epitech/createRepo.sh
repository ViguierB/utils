#!/bin/bash
##
## ----------------------------------------------------------------------------
## "THE BEER-WARE LICENSE" (Revision 42):
## <benjamin.viguier@epitech.eu> wrote this file. As long as you retain this
## notice you can do whatever you want with this stuff. If we meet some day,
## and you think this stuff is worth it, you can buy me a beer in return 
## Benjamin Viguier
## ----------------------------------------------------------------------------
##

login="benjamin.viguier@epitech.eu"
repo=$1

true=1;
false=0;

function ask {
    msg=$1;
    echo -n "$msg (Y/n): ";
    read -t 25 res;
    case $res in
	    n|N) return $false;;
        *)   return $true;;
    esac;
}

echo -n Password: 
read -s password
echo
token=$(echo -e "import hashlib\nprint (hashlib.sha512(bytes(\"$password\", 'utf8')).hexdigest(), end='')" | python3)
password="";
if ! blih -u $login -t $token repository create $repo; 
then
    echo "error"
    exit 1
fi
if ! blih -u $login -t $token repository setacl $repo ramassage-tek r;
then
    echo "error"
    exit 1
fi
if ! blih -u $login -t $token repository getacl $repo;
then
    echo "error"
    exit 1
fi
token="";

ask "Clone here ?";
execClone=$?;
if [ $execClone == $true ]; then
    git clone git@git.epitech.eu:/$login/$repo;
    if [ $? == 0 ]; then
        cd $repo;
    else
        echo "Error";
        exit 1;
    fi
fi