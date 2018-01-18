#!/bin/bash

# Directory to find config artifacts
HADOOP_PREFIX=/usr/local/hadoop
CONFIG_DIR=/etc/hadoop-config
JAVA_HOME_DIR=/usr/lib/jvm/jdk1.8.0_161
CONFIG_FILE=/tmp/hadoop/config.sh

# Default values of configuration (can be configure from Pod env)
ZOOKEEPER_PORT=${ZOOKEEPER_PORT:-2181}
HADOOP_NAMENODE_DFS_PORT=${HADOOP_NAMENODE_DFS_PORT:-9000}
HADOOP_NAMENODE_WEBHDFS_PORT=${HADOOP_NAMENODE_WEBHDFS_PORT:-50070}
HADOOP_JOURNALNODE_RPC_PORT=${HADOOP_JOURNALNODE_RPC_PORT:-8485}
MY_NAMESPACE=${MY_NAMESPACE:-'default'}

if [[ -f ! $CONFIG_FILE ]]; then
  echo "ERROR: Could not find $CONFIG_FILE"
  exit 1
fi

service ssh restart
chmod 755 $CONFIG_FILE
. $CONFIG_FILE
chmod 755 $HADOOP_PREFIX/etc/hadoop/*.sh
sed -i 's:${JAVA_HOME}:'$JAVA_HOME_DIR':' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
. $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# Copy config files to hadoop
for f in slaves core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml; do
  if [[ -e $CONFIG_DIR/$f ]]; then
    cp $CONFIG_DIR/$f $HADOOP_PREFIX/etc/hadoop/$f
  else
    echo "ERROR: Could not find $f in $CONFIG_DIR"
    exit 1
  fi
done

# All node configuration
sed -i "s:HADOOP_TMP_DIR:${HADOOP_TMP_DIR}:" $HADOOP_PREFIX/etc/hadoop/core-site.xml
sed -i 's/ZOOKEEPER_SERVERS/'$ZOOKEEPER_ADDRESSES'/' $HADOOP_PREFIX/etc/hadoop/core-site.xml

sed -i 's/NAMENODE_MASTER_HOST/'$NAMENODE_MASTER_HOST'/g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_MASTER_RPC_NAME/'$NAMENODE_MASTER_RPC_NAME'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_MASTER_RPC_PORT/'$HADOOP_NAMENODE_DFS_PORT'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_MASTER_HTTP_NAME/'$NAMENODE_MASTER_HTTP_NAME'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_MASTER_HTTP_PORT/'$HADOOP_NAMENODE_WEBHDFS_PORT'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_STANDBY_HOST/'$NAMENODE_STANDBY_HOST'/g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_STANDBY_RPC_NAME/'$NAMENODE_STANDBY_RPC_NAME'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_STANDBY_RPC_PORT/'$HADOOP_NAMENODE_DFS_PORT'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_STANDBY_HTTP_NAME/'$NAMENODE_STANDBY_HTTP_NAME'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_STANDBY_HTTP_PORT/'$HADOOP_NAMENODE_WEBHDFS_PORT'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/JOURNALNODE_HOST_0/'$JOURNALNODE_HOST_0'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/JOURNALNODE_HOST_1/'$JOURNALNODE_HOST_1'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/JOURNALNOD_HOSTE_2/'$JOURNALNODE_HOST_2'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/JOURNALNODE_PORT/'$HADOOP_JOURNALNODE_RPC_PORT'/g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i "s:JOURNAL_DATA_DIR:${JOURNAL_DATA_DIR}:" $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml 

sed -i 's/RESOURCE_MANAGER_HOST_0/'$RESOURCE_MANAGER_HOST_0'/' $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
sed -i 's/RESOURCE_MANAGER_HOST_1/'$RESOURCE_MANAGER_HOST_1'/' $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
sed -i 's/ZOOKEEPER_SERVERS/'$ZOOKEEPER_ADDRESSES'/' $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

if [[ "${HOSTNAME}" =~ "${NAMENODE_MASTER_HOSTNAME}" ]]; then
  
  # slaves是指定子节点的位置，因为要在master上启动HDFS，slaves文件指定的是datanode的位置
  IFS="," 
  datanodes=($DATANODES)
  for datanode in ${datanodes[@]}
  do
    echo $datanode >> $HADOOP_PREFIX/etc/hadoop/slaves
  done

  if [ "`ls -A $HADOOP_TMP_DIR`" = "" ]; then
    # $HADOOP_TMP_DIR is empty
    $HADOOP_PREFIX/bin/hdfs namenode -format -force -nonInteractive
    $HADOOP_PREFIX/bin/hdfs zkfc -formatZK -force -nonInteractive
  fi
    
    $HADOOP_PREFIX/sbin/start-dfs.sh

  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi
fi

if [[ "${HOSTNAME}" =~ "${NAMENODE_STANDBY_HOSTNAME}" ]]; then
  
  # slaves是指定子节点的位置，因为要在namenode上启动HDFS，slaves文件指定的是datanode的位置
  IFS="," 
  datanodes=($DATANODES)
  for datanode in ${datanodes[@]}
  do
    echo $datanode >> $HADOOP_PREFIX/etc/hadoop/slaves
  done

  if [ "`ls -A $HADOOP_TMP_DIR`" = "" ]; then
    scp -r $NAMENODE_MASTER_HOST:$HADOOP_TMP_DIR $HADOOP_TMP_DIR/../
  fi
  $HADOOP_PREFIX/sbin/start-dfs.sh

  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi
fi

if [[ "${HOSTNAME}" =~ "${RESOURCE_MANAGER_HOSTNAME_0}" ]]; then

  # slaves是指定子节点的位置，因为要在resourcemanager-0启动yarn，所以resourcemanager-0上的slaves文件指定的是nodemanager的位置
  IFS="," 
  nodemanagers=($NODEMANAGERS)
  for nodemanager in ${nodemanagers[@]}
  do
    echo $nodemanager >> $HADOOP_PREFIX/etc/hadoop/slaves
  done

  $HADOOP_PREFIX/sbin/start-yarn.sh
  $HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager
  
  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi
fi

if [[ "${HOSTNAME}" =~ "${JOURNALNODE_HOSTNAME}" ]]; then
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh start journalnode

  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
