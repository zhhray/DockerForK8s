#!/bin/bash

SLAVES_PATH="/tmp/hadoop/hdfs/slaves"

if [ $1 = 'resourcemanager' ]; then
  SLAVES_PATH="/tmp/hadoop/resourcemanager/slaves" 
fi   

while true;
do
  cat /dev/null > /usr/local/hadoop/etc/hadoop/slaves;

  for node in  `cat $SLAVES_PATH`
  do
   eval echo $node >> /usr/local/hadoop/etc/hadoop/slaves;
  done

  sleep 5;
done
