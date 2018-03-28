#!/bin/bash

CONF_PATH_FOLDER="`dirname "$(realpath $0)"`/conf";
CONF_PATH_FILE="$CONF_PATH_FOLDER/permissions.conf";
SCRIPT_PATH=`realpath $0`;

if [ ! -f $CONF_PATH_FILE ]
then
  echo "Configuration file not found."
  exit 1;
fi

source $CONF_PATH_FILE

VARIABLES_CONFIG=(PROJECT_PATH PROJECT_USER WEBSERVER_GROUP);

for variable in ${VARIABLES_CONFIG[*]}
do
  if [ -z ${!variable} ]
  then
    echo "Configuration variable \"$variable\" not found."
    exit 1;
  fi
done

if [ ! -d "$PROJECT_PATH" ]
then
  echo "Path : $PROJECT_PATH is not a directory";
  exit 1;
fi

find $PROJECT_PATH -type d -not -path "$CONF_PATH_FOLDER" -exec chmod 755 {} \;
find $PROJECT_PATH -type f -not -path "$SCRIPT_PATH" -not -path "$CONF_PATH_FILE" -exec chmod 644 {} \;

find $PROJECT_PATH/generated $PROJECT_PATH/var $PROJECT_PATH/vendor $PROJECT_PATH/pub/static $PROJECT_PATH/pub/media $PROJECT_PATH/app/etc -type f -exec chmod g+w {} \;
find $PROJECT_PATH/generated $PROJECT_PATH/var $PROJECT_PATH/vendor $PROJECT_PATH/pub/static $PROJECT_PATH/pub/media $PROJECT_PATH/app/etc -type d -exec chmod g+w {} \;

chgrp -R www-data $PROJECT_PATH
chmod g+x $PROJECT_PATH/bin/magento
