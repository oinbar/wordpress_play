#!/usr/bin/env bash



if [ ! -z $1 ]
then
    PROJECT_HOME=$1
else
    PROJECT_HOME=$(pwd)
fi


cd $PROJECT_HOME
service apache2 start
service apache2 restart