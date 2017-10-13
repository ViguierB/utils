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

function getRandomName {
    rand=$(cat /dev/urandom | head -c 32 | $(if [ $(uname) == "Darwin" ]; then echo md5; else echo sha256sum; fi) | base64 | tr -cd '[[:alnum:]]._-')
    echo "/tmp/$rand";
}

if ! emacs --version > /dev/null 2> /dev/null; then
    echo "Please install emacs."
    exit 84;
fi


if [ -z $2 ] || [ ! -d $1 ]; then
    echo "Usage : $0 PATH EXTENSION [EXTENTION ...]";
    echo -e "\tExemple : '$0 $(pwd) .c .h' will indent all .c and .h files in current and sub directories"
    exit 84;
fi

taskList=();
for elem in ${@:2}; do
    printf "$(loadColor 1)Indent all $elem...$(loadColor 0)\n";
    filesList=$(find $1 -iname \*$elem);
    for file in $filesList; do
	if [ ! -L $file ]; then
            tmpFile=$(getRandomName);
            (cp $file $tmpFile;
		echo -n "" > $file;
		while IFS='' read -r line || [[ -n "$line" ]]; do
		    echo "$line" >> $file;
		done < $tmpFile
		rm $tmpFile;
		emacs -nw -q --batch $file --eval "(mark-whole-buffer)" --eval "(indent-region (point-min) (point-max) nil)" --eval "(save-buffer)" --kill > /dev/null 2> /dev/null; 
		if [ -f $file'~' ]; then
                    rm $file'~';
		fi
		printf "\t$file $(loadColor 1 32)Ok$(loadColor 0)\n"; ) &
            taskList+=($!);
	fi
    done 
    for task in ${taskList[@]}; do
        wait $task;
    done
    printf "$(loadColor 1 32)Done$(loadColor 0)\n";
done
