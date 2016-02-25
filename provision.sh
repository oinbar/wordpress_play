#!/usr/bin/env bash

# THIS ALL ASSUMES PYTHON 2.7.6
# IF UBUNTU 14.04 decides to ship a different python might need to work around that.


if [ ! -z $1 ]
then
    PROJECT_HOME=$1
else
    PROJECT_HOME=$(pwd)
fi




cd $PROJECT_HOME

apt-get update
apt-get -y install git
apt-get -y install unzip

