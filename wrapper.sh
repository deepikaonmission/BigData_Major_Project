#!/bin/bash

#This script calls other scripts in sequential fashion

#Below scripts work on the data present inside web and mob folders which are already provided as part of this project

#Below script starts all required services
sh /home/acadgild/project/scripts/start-daemons.sh

#Below script creates hbase lookup tables
sh /home/acadgild/project/scripts/populate-lookup.sh

#Below script creates hive tables on top of hbase tables
sh /home/acadgild/project/scripts/data_enrichment_filtering_schema.sh

#Below script collects web and mob data, and creates a table accordingly
sh /home/acadgild/project/scripts/dataformatting_hadoop.sh

#Below script enriches and filters the data
sh /home/acadgild/project/scripts/data_enrichment.sh

#Below script performs analysis on filtered and enriched data
sh /home/acadgild/project/scripts/data_analysis.sh


