#!/bin/bash

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

pwd=$(pwd);
files=$(getFiles $pwd)
for script in $files; do
    linkName="$HOME/bin/$(basename $script)";
    
    if [ -f $linkName ] && [ $(readlink $linkName) == $script ]; then
	rm $linkName;
    fi
    ln -s $script $linkName
    echo "$linkName --> $script"
done

echo "done"
