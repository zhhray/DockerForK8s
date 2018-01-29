#!/bin/bash

while true;
do
  cat /dev/null > /usr/local/hadoop/etc/hadoop/slaves;

  for node in  `cat /tmp/hadoop/slaves`
  do
   eval echo $node >> /usr/local/hadoop/etc/hadoop/slaves;
  done

  sleep 5;
done
