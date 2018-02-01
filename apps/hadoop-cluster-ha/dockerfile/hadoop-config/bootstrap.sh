#!/bin/bash

# Directory to find config artifacts
HADOOP_PREFIX=/usr/local/hadoop
CONFIG_DIR=/etc/hadoop-config
JAVA_HOME_DIR=/usr/lib/jvm/jdk1.8.0_161
HDFS_CONFIG_FILE=/tmp/hadoop/hdfs/config.sh
RM_CONFIG_FILE=/tmp/hadoop/resourcemanager/config.sh

# Default values of configuration (can be configure from Pod env)
ZOOKEEPER_PORT=${ZOOKEEPER_PORT:-2181}
HADOOP_NAMENODE_DFS_PORT=${HADOOP_NAMENODE_DFS_PORT:-9000}
HADOOP_NAMENODE_WEBHDFS_PORT=${HADOOP_NAMENODE_WEBHDFS_PORT:-50070}
HADOOP_JOURNALNODE_RPC_PORT=${HADOOP_JOURNALNODE_RPC_PORT:-8485}
MY_NAMESPACE=${MY_NAMESPACE:-'default'}

if [ ! -f  $HDFS_CONFIG_FILE ]; then
  echo "ERROR: Could not find $HDFS_CONFIG_FILE"
  exit 1
fi

service ssh restart
# Get config from external
chmod 755 $HDFS_CONFIG_FILE
. $HDFS_CONFIG_FILE
if [ -f  $RM_CONFIG_FILE ]; then
  . $RM_CONFIG_FILE
fi
chmod 755 $HADOOP_PREFIX/etc/hadoop/*.sh
sed -i 's:${JAVA_HOME}:'$JAVA_HOME_DIR':' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
. $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# Copy config files to hadoop
for f in core-site.xml hdfs-site.xml mapred-site.xml yarn-site.xml; do
  if [[ -e $CONFIG_DIR/$f ]]; then
    cp $CONFIG_DIR/$f $HADOOP_PREFIX/etc/hadoop/$f
  else
    echo "ERROR: Could not find $f in $CONFIG_DIR"
    exit 1
  fi
done

# All node configuration
sed -i 's/DEFAULT_FS_NAME/'$DEFAULT_FS_NAME'/' $HADOOP_PREFIX/etc/hadoop/core-site.xml
sed -i "s:HADOOP_TMP_DIR:${HADOOP_TMP_DIR}:" $HADOOP_PREFIX/etc/hadoop/core-site.xml
sed -i 's/ZOOKEEPER_SERVERS/'$ZOOKEEPER_ADDRESSES'/' $HADOOP_PREFIX/etc/hadoop/core-site.xml

sed -i 's/DEFAULT_FS_NAME/'$DEFAULT_FS_NAME'/g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_MASTER_HOST/'$NAMENODE_MASTER_HOST'/g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_MASTER_RPC_PORT/'$HADOOP_NAMENODE_DFS_PORT'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_MASTER_HTTP_PORT/'$HADOOP_NAMENODE_WEBHDFS_PORT'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_STANDBY_HOST/'$NAMENODE_STANDBY_HOST'/g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_STANDBY_RPC_PORT/'$HADOOP_NAMENODE_DFS_PORT'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/NAMENODE_STANDBY_HTTP_PORT/'$HADOOP_NAMENODE_WEBHDFS_PORT'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/JOURNALNODE_HOST_0/'$JOURNALNODE_HOST_0'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/JOURNALNODE_HOST_1/'$JOURNALNODE_HOST_1'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/JOURNALNODE_HOST_2/'$JOURNALNODE_HOST_2'/' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i 's/JOURNALNODE_PORT/'$HADOOP_JOURNALNODE_RPC_PORT'/g' $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
sed -i "s:JOURNAL_DATA_DIR:${JOURNAL_DATA_DIR}:" $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml 

if [ -f  $RM_CONFIG_FILE ]; then
  sed -i 's/RM_HA_ID/'$RM_HA_ID'/' $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
  sed -i 's/RESOURCE_MANAGER_HOST_0/'$RESOURCE_MANAGER_HOST_0'/' $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
  sed -i 's/RESOURCE_MANAGER_HOST_1/'$RESOURCE_MANAGER_HOST_1'/' $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
  sed -i 's/ZOOKEEPER_SERVERS/'$ZOOKEEPER_ADDRESSES'/' $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
  sed -i "s:ZK_STATE_STORE_PATH:${ZK_STATE_STORE_PATH}:" $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
fi

if [[ "${HOSTNAME}" =~ "${NAMENODE_MASTER_HOSTNAME}" ]]; then
  
  # slaves是指定子节点的位置，因为要在master上启动HDFS，slaves文件指定的是datanode的位置
  chmod 755 $CONFIG_DIR/slaves-change.sh
  $CONFIG_DIR/slaves-change.sh hdfs &

  if [ "`ls -A $HADOOP_TMP_DIR`" = "" ]; then
    # $HADOOP_TMP_DIR is empty
    $HADOOP_PREFIX/bin/hdfs namenode -format -force -nonInteractive
    $HADOOP_PREFIX/bin/hdfs zkfc -formatZK -force -nonInteractive
    $HADOOP_PREFIX/sbin/start-dfs.sh
  else
    $HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode
    $HADOOP_PREFIX/sbin/hadoop-daemon.sh start zkfc
  fi	

  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi

elif [[ "${HOSTNAME}" =~ "${NAMENODE_STANDBY_HOSTNAME}" ]]; then
  
  # slaves是指定子节点的位置，因为要在namenode上启动HDFS，slaves文件指定的是datanode的位置
  chmod 755 $CONFIG_DIR/slaves-change.sh
  $CONFIG_DIR/slaves-change.sh hdfs &

  if [ "`ls -A $HADOOP_TMP_DIR`" = "" ]; then
    scp -r $NAMENODE_MASTER_HOST:$HADOOP_TMP_DIR $HADOOP_TMP_DIR/../
  fi

  $HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh start zkfc
  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi

elif [[ "${HOSTNAME}" =~ "${RESOURCE_MANAGER_HOSTNAME}" ]]; then

  # slaves是指定子节点的位置，因为要在resourcemanager启动yarn，所以resourcemanager上的slaves文件指定的是nodemanager的位置
  chmod 755 $CONFIG_DIR/slaves-change.sh
  $CONFIG_DIR/slaves-change.sh resourcemanager &

  # $HADOOP_PREFIX/sbin/start-yarn.sh
  $HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager
  
  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi

elif [[ "${HOSTNAME}" =~ "${JOURNALNODE_HOSTNAME}" ]]; then
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh start journalnode

  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi

else
  # Datanode
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh start datanode
  $HADOOP_PREFIX/sbin/yarn-daemon.sh start nodemanager
  
  if [[ $1 == "-d" ]]; then
    until find ${HADOOP_PREFIX}/logs -mmin -1 | egrep -q '.*'; echo "`date`: Waiting for logs..." ; do sleep 2 ; done
    tail -F ${HADOOP_PREFIX}/logs/* &
    while true; do sleep 1000; done
  fi  
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
