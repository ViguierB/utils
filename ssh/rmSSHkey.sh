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

true=1;
false=0;

RETURN_SUCCESS=0;

bold='1';
red='31';
green='32';
default='0';

[ -t 1 ];
isatty=$?;

function loadColor {
    if [ -z $1 ] || [ $isatty != 0 ]; then
	return;
    fi
    res='\e[';
    first=$true;
    for color in "$@"; do
	if [ $first == $false ]; then
	    res+=';';
	else
	    first=$false;
	fi
 	res+=$color;
    done
    res+='m';
    printf $res;
}

function printError {
    loadColor $bold $red;
    echo "$1";
    loadColor $default;
}

function printSuccess {
    loadColor $bold $green;
    echo "$1";
    loadColor $default;
}


function ask {
    msg=$1;
    echo -n "$msg (Y/n): ";
    read -t 25 res;
    case $res in
	n|N) return $false;;
*)   return $true;;
esac;
}

##BEGINING

if [ -z $1 ] || [ -z $2 ]; then
    printError "usage: $0 USER@IPADDRESS KEY !!";
    exit 84;
fi
server=$1;
key=$2

request="key='$key';";
request+='cat ~/.ssh/authorized_keys | grep "$key" > /dev/null;';
request+='if [ $? != 0 ]; then';
request+=" echo $false;";
request+='else';
request+=' file=($(cat ~/.ssh/authorized_keys));';
request+=' rm ~/.ssh/authorized_keys;'
request+=' touch ~/.ssh/authorized_keys;';
request+=' chmod 600 ~/.ssh/authorized_keys;';
request+=' len=${#file[*]};';
request+=' for (( i=0; i<=$(( $len -1 )); i+=3 )); do';
request+='  if [ $key != ${file[$i+2]} ]; then';
request+='   echo "${file[$i]} ${file[$i+1]} ${file[$i+2]}" >> ~/.ssh/authorized_keys;';
request+='  fi;';
request+=' done;';
request+=" echo $true;";
request+='fi;';

requestResult=$(echo "$request" | ssh $server 'bash -s');
if [ $? != $RETURN_SUCCESS ]; then
    printError "ssh connection failed !!";
    exit 84;
fi

if [ $requestResult == $true ]; then
    printSuccess "ssh key successfully deleted :P";
else
    printError "shh key already deleted on remote !!";
fi
