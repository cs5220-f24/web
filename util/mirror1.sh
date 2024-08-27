#!/bin/bash

if [[ -z $DBUS_SESSION_BUS_ADDRESS ]]; then
  dbus_file=/home/bindel/.dbus/session-bus/$(dbus-uuidgen --get)-0
  if [[ -f $dbus_file ]]; then
    source $dbus_file
    export DBUS_SESSION_BUS_ADDRESS
  fi
fi

cd /home/bindel/work/class/cs5220-f24/
git pull origin
cd web
rake deploy
cd ../docs
rake deploy
