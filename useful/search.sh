#!/bin/bash

true=1;
false=0;

[ -t 1 ]
isatty=$?;

bold='1';
default='0';

function loadColor {
    if [ -z $1 ] || ! $(exit $isatty); then
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
    echo -en "$res";
}

function getFiles {
    dirName=$1;

    whereiam=$(pwd);
    cd $dirName;
    for d in $(ls -a -I .. -I . -I .git); do
        if [ -d $d ]; then
            echo $(getFiles $d);
        else
            echo "$(pwd)/$d";
        fi;
    done;
    cd $whereiam;
}

for a in $(getFiles $1); do
    res=$(cat $a | grep $(if $(exit $isatty); then echo '--color=always'; fi) -n ${@:2})
    if [ ! -z "$res" ]; then
        printf $(loadColor $bold)"Found on file: $a\n"$(loadColor $default)
        echo "$res";
        echo;
    fi
done