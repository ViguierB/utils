#!/bin/bash

true=1;
false=0;

function getFiles {
    dirName=$1;
    first=0;
    if [ -z $2 ]; then
	first=1;
    fi

    whereiam=$(pwd);
    cd $dirName;
    for d in $(ls -A); do
        if [ -d $d ]; then
	    if [ $d != '.git' ]; then
		echo $(getFiles $d true);
	    fi
        else
            if $(exit $first); then
                echo "$(pwd)/$d";
            fi;
        fi;
    done
    cd $whereiam
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

pwd=$(pwd);
files=$(getFiles $pwd)
for script in $files; do
    linkName="$HOME/.bin/$(basename $script)";
    
    if [ -f $linkName ] && [ $(readlink $linkName) == $script ]; then
	rm $linkName;
    elif [ -f $linkName ]; then
        ask "$linkName exists, Overwrite ?";
        if [ $? == $true ]; then
            rm $linkName;
        fi
    fi
    if [ ! -f $linkName ]; then
	ln -s $script $linkName
	echo "$linkName --> $script"
    fi
    
done

echo "done"
