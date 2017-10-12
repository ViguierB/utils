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

function loadColor {
    if [ -z $1 ]; then
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
    echo -en $res;
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

next=$false;
for arg in ${@:1}; do
    if [ $next == $true ]; then
	if [ ! -f $arg ]; then
	    printError "Cannot find '$arg'";
	    exit 84;
	fi 
        next=$false;
        keyPath=$arg;
	isBasicPath=$false;
    elif [ "$arg" == "-f" ];then
	next=$true;
    elif [ -z $server ]; then
	server=$arg;
    fi
done

if [ -z $server ]; then
    printError "Server not specified !"
    printError "  usage: $0 [-f sshKey_path] USER@ADDRESS";
    exit 84;
fi

if [ $isBasicPath == $true ] && [ ! -f $keyPath ]; then
    loadColor $bold;
    ask "You haven't ssh key on you .ssh directory, create now ?";
    askResult=$?;
    loadColor $default;
    if [ $askResult == $true ]; then
	yes "" | ssh-keygen 2> /dev/null;
	if [ $? != $RETURN_SUCCESS ]; then
	    printError "ssh-keygen return an error code !!";
	    exit 84;
	fi
	printSuccess "key ssh generated";
    fi
    exit $RETURN_SUCCESS;
fi

request="key='$(cat $keyPath)';";
request+='cat ~/.ssh/authorized_keys | grep "$key" > /dev/null;';
request+='if [ $? != 0 ]; then';
request+=' echo $key >> ~/.ssh/authorized_keys;';
request+=" echo $true;";
request+='else';
request+=" echo $false;";
request+='fi;';

requestResult=$(echo "$request" | ssh $server 'bash -s');
if [ $? != $RETURN_SUCCESS ]; then
    printError "ssh connection failed !!";
    exit 84;
fi

if [ $requestResult == $true ]; then
    printSuccess "ssh key added on remote :P";
else
    printError "shh key already added on remote !!";
fi
