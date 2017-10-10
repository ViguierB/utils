#!/bin/bash

function getFiles {
    dirName=$1;
    first=0;
    if [ -z $2 ]; then
       first=1;
    fi

    whereiam=$(pwd);
    cd $dirName;
    for d in $(ls -a -I .. -I . -I .git); do
        if [ -d $d ]; then
            echo $(getFiles $d true);
        else
            if $(exit $first); then
                echo "$(pwd)/$d";
            fi;
        fi;
    done
    cd $whereiam
}

for a in $(getFiles $1); do
    res=$(cat $a | grep --color=always -n $2)
    if [ ! -z "$res" ]; then
        echo "On file $a";
        echo "$res";
        echo;
    fi
done