#!/bin/bash

HADOOP_TMP_DIR=/usr/local/hadoop/tmp
JOURNAL_DATA_DIR=/usr/local/hadoop/journaldata

# Configuration of hadoop cluster
ZOOKEEPER_ADDRESSES=$ZOOKEEPER_SERVER_SERVICE_HOST:$ZOOKEEPER_PORT
NAMENODE_MASTER_HOSTNAME=hadoop-hdfs-namenode-0
NAMENODE_MASTER_HOST=$NAMENODE_MASTER_HOSTNAME.hadoop-namenode-headless.$MY_NAMESPACE.svc.cluster.local
NAMENODE_MASTER_RPC_NAME=dfs.namenode.rpc-address.masters.$NAMENODE_MASTER_HOST
NAMENODE_MASTER_HTTP_NAME=dfs.namenode.http-address.masters.$NAMENODE_MASTER_HOST
NAMENODE_STANDBY_HOSTNAME=hadoop-hdfs-namenode-1
NAMENODE_STANDBY_HOST=$NAMENODE_STANDBY_HOSTNAME.hadoop-namenode-headless.$MY_NAMESPACE.svc.cluster.local
NAMENODE_STANDBY_RPC_NAME=dfs.namenode.rpc-address.masters.$NAMENODE_STANDBY_HOST
NAMENODE_STANDBY_HTTP_NAME=dfs.namenode.http-address.masters.$NAMENODE_STANDBY_HOST
JOURNALNODE_HOSTNAME=hadoop-hdfs-journalnode
JOURNALNODE_HOST_0=hadoop-hdfs-journalnode-0.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local
JOURNALNODE_HOST_1=hadoop-hdfs-journalnode-1.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local
JOURNALNODE_HOST_2=hadoop-hdfs-journalnode-2.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local
RESOURCE_MANAGER_HOSTNAME=hadoop-hdfs-resourcemanager
RESOURCE_MANAGER_HOST_0=hadoop-hdfs-resourcemanager-0.hadoop-resourcemanager-headless.$MY_NAMESPACE.svc.cluster.local
RESOURCE_MANAGER_HOST_1=hadoop-hdfs-resourcemanager-1.hadoop-resourcemanager-headless.$MY_NAMESPACE.svc.cluster.local
DATANODES="hadoop-hdfs-journalnode-0.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local,hadoop-hdfs-journalnode-1.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local,hadoop-hdfs-journalnode-2.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local"
NODEMANAGERS="hadoop-hdfs-journalnode-0.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local,hadoop-hdfs-journalnode-1.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local,hadoop-hdfs-journalnode-2.hadoop-journalnode-headless.$MY_NAMESPACE.svc.cluster.local"
