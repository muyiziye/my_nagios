#!/bin/bash
NGS_PATH="/home/ly/data/code/my_nagios/nagios_opt/"
GRAPH_PATH="/home/ly/data/code/my_nagios/nagios_graph/"

docker run -d --name nagios1 --rm   \
	-v ${NGS_PATH}etc/:/opt/nagios/etc/   \
	-v ${NGS_PATH}var:/opt/nagios/var/   \
	-v ${GRAPH_PATH}custom_plugin:/opt/Custom-Nagios-Plugins \
	-v ${GRAPH_PATH}nagiosgraph-rrd:/opt/nagiosgraph/var/rrd \
       	-p 0.0.0.0:8080:80 muyiziye/my_nagios:version-1.0.0
	#-v ${GRAPH_PATH}nagiosgraph-etc:/opt/nagiosgraph/etc \


