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

keyPath=~/.ssh/id_rsa.pub;
isBasicPath=$true;

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

if [ -z $1 ]; then
    printError "Unspecified host !!";
    exit 84;
fi
server=$1;

authFile=($(ssh $server "bash -c 'cat "'~/.ssh/authorized_keys'";'")); 

if [ $? != $RETURN_SUCCESS ]; then
    printError "ssh connection failed !!";
    exit 84;
fi

length=${#authFile[*]};
    loadColor $bold;
    for (( i=2; i<=$(( $length -1 )); i+=3 )); do
	echo ${authFile[$i]};
    done
    loadColor $default;
