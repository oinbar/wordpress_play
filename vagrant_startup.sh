#!/usr/bin/env bash



if [ ! -z $1 ]
then
    PROJECT_HOME=$1
else
    PROJECT_HOME=$(pwd)
fi


cd $PROJECT_HOME

# modify pythonpath
export PYTHONPATH=$PYTHONPATH:$(pwd)/src/
export PYTHONPATH=$PYTHONPATH:$(pwd)/src/CommonUtils


# launch services and servers
ipython notebook --ip=0.0.0.0 &                                                     # ipython notebook
python wooey_ui/manage.py runserver 0.0.0.0:8000 &                                  # wooey server
python wooey_ui/manage.py celery worker -c 1 --beat -l info &                       # wooey worker