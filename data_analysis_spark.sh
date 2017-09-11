#!/bin/bash

batchid=`cat /home/acadgild/project/logs/current-batch.txt`
LOGFILE=/home/acadgild/project/logs/log_batch_$batchid
HBASE_PATH=`/usr/local/hbase/bin/hbase classpath`

echo "Running spark script for data analysis..." >> $LOGFILE

chmod 775 /home/acadgild/project/MusicDataAnalysisProject/out/artifacts/MusicDataAnalysisProject_jar3/MusicDataAnalysisProject.jar

zip -d /home/acadgild/project/MusicDataAnalysisProject/out/artifacts/MusicDataAnalysisProject_jar3/MusicDataAnalysisProject.jar META-INF/*.RSA META-INF/*.DSA META-INF/*.SF

spark-submit \
--class DataAnalysisMain_1 \
--master local[2] \
--driver-class-path /usr/local/hive/lib/hive-hbase-handler-0.14.0.jar:/usr/local/hbase/lib/*:$HBASE_PATH \
/home/acadgild/project/MusicDataAnalysisProject/out/artifacts/MusicDataAnalysisProject_jar3/MusicDataAnalysisProject.jar \$batchid

spark-submit \
--class DataAnalysisReadFromHive \
--master local[2] \
--driver-class-path /usr/local/hive/lib/hive-hbase-handler-0.14.0.jar:/usr/local/hbase/lib/*:$HBASE_PATH \
/home/acadgild/project/MusicDataAnalysisProject/out/artifacts/MusicDataAnalysisProject_jar3/MusicDataAnalysisProject.jar

echo "Exporting data to mysql..." >> $LOGFILE

#Below script exports the data from hive tables to mysql tables
sh /home/acadgild/project/scripts/data_export.sh

echo "Incrementing batchid..." >> $LOGFILE

batchid=`expr $batchid + 1`

echo -n $batchid > /home/acadgild/project/logs/current-batch.txt
