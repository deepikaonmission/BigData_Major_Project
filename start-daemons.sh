#!/bin/bash

if [ -f "/home/acadgild/project/logs/current-batch.txt" ]
then
	echo "Batch file found!"
else
	echo -n "1" > "/home/acadgild/project/logs/current-batch.txt"
fi

chmod 777 /home/acadgild/project/logs/current-batch.txt

batchid=`cat /home/acadgild/project/logs/current-batch.txt`
LOGFILE=/home/acadgild/project/logs/log_batch_$batchid

chmod 777 /home/acadgild/project/logs/*

echo "Starting daemons..." >> $LOGFILE

#To start hadoop daemons, following command is used
$HADOOP_HOME/sbin/start-all.sh

#To start hbase, following command is used
$HBASE_HOME/bin/start-hbase.sh

#To start history server, following command is used
mr-jobhistory-daemon.sh start historyserver

#To start mysqld service, following command is used
sudo service mysqld start

#To start hive metastore, following command is used
hive --service metastore
