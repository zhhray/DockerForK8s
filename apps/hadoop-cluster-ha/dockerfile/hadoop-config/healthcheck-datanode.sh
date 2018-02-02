#!/bin/bash
res1=`jps | grep -c NodeManager`
res2=`jps | grep -c DataNode`

#echo $res1
#echo $res2

if [ $res1 -ge 1 ] && [ $res2 -ge 1 ]; then
  #echo '0'
  exit 0
else
  echo 'DataNode or NodeManager is dead.'
  exit 1
fi
