#!/bin/bash

# Hadoop 临时数据存储目录
HADOOP_TMP_DIR=/usr/local/hadoop/tmp
JOURNAL_DATA_DIR=/usr/local/hadoop/journaldata

# Zookeeper cluster address
ZOOKEEPER_ADDRESSES=$ZOOKEEPER_SERVER_SERVICE_HOST:$ZOOKEEPER_PORT
# Namenode master hostname
NAMENODE_MASTER_HOSTNAME=hadoop-hdfs-namenode-1
# Namenode master hostname can be accessed from other pods
NAMENODE_MASTER_HOST=$NAMENODE_MASTER_HOSTNAME.hadoop-namenode-headless.$MY_NAMESPACE.svc.cluster.local
# Namenode standby hostname
NAMENODE_STANDBY_HOSTNAME=hadoop-hdfs-namenode-0
# Namenode standby hostname can be accessed from other pods
NAMENODE_STANDBY_HOST=$NAMENODE_STANDBY_HOSTNAME.hadoop-namenode-headless.$MY_NAMESPACE.svc.cluster.local
# Journalnode hostname
JOURNALNODE_HOSTNAME=hadoop-hdfs-journalnode
# Journalnodes hostname can be accessed from other pods
JOURNALNODE_HOST_0=hadoop-hdfs-journalnode-0.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local
JOURNALNODE_HOST_1=hadoop-hdfs-journalnode-1.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local
JOURNALNODE_HOST_2=hadoop-hdfs-journalnode-2.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local
# Resourcemanager hostname
RESOURCE_MANAGER_HOSTNAME=hadoop-hdfs-resourcemanager
# Resourcemanagers hostname can be accessed from other pods
RESOURCE_MANAGER_HOST_0=hadoop-hdfs-resourcemanager-0.hadoop-resourcemanager-headless.$MY_NAMESPACE.svc.cluster.local
RESOURCE_MANAGER_HOST_1=hadoop-hdfs-resourcemanager-1.hadoop-resourcemanager-headless.$MY_NAMESPACE.svc.cluster.local
# Tell the namenode what the datanode is
DATANODES="hadoop-hdfs-datanode-0.hadoop-datanode-headless.$MY_NAMESPACE.svc.cluster.local,hadoop-hdfs-datanode-1.hadoop-datanode-headless.$MY_NAMESPACE.svc.cluster.local,hadoop-hdfs-datanode-2.hadoop-datanode-headless.$MY_NAMESPACE.svc.cluster.local"
# Tell the resourcemanager what the nodemanager is
NODEMANAGERS="hadoop-hdfs-datanode-0.hadoop-datanode-headless.$MY_NAMESPACE.svc.cluster.local,hadoop-hdfs-datanode-1.hadoop-datanode-headless.$MY_NAMESPACE.svc.cluster.local,hadoop-hdfs-datanode-2.hadoop-datanode-headless.$MY_NAMESPACE.svc.cluster.local"