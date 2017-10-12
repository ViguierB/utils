#!/bin/bash

function loadColor {
    if [ -z $1 ]; then
	return;
    fi
    res='\e['
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

if ! emacs --version > /dev/null 2> /dev/null; then
    echo "Please install emacs."
    echo 84;
fi


if [ -z $1 ]; then
    echo "Usage : $0 EXTENSION [EXTENTION ...]";
    echo -e "\tExemple : '$0 .c .h' will indent all .c and .h files in current and sub directories"
    exit 84;
fi

for elem in ${@:1}; do
    printf "Indent all .$elem...\n";
    sleep 0.5;
    filesList=$(find . -iname \*.$elem);
    for file in $filesList; do
	emacs -nw -q --batch $file --eval "(mark-whole-buffer)" --eval "(indent-region (point-min) (point-max) nil)" --eval "(save-buffer)" --kill > /dev/null 2> /dev/null &
	wait $!;
	printf "\t$file $(loadColor 1 32)Ok$(loadColor 0)\n";
    done 
    printf "$(loadColor 1 32)Done$(loadColor 0)\n";
done