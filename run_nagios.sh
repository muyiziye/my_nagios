#!/bin/bash
NGS_PATH=`pwd`"/nagios/"

docker run -d --name nagios1 --rm   \
	-v ${NGS_PATH}etc:/opt/nagios/etc/   \
	-v ${NGS_PATH}var:/opt/nagios/var/   \
	-v ${NGS_PATH}plugin:/opt/Custom-Nagios-Plugins \
	-v ${NGS_PATH}data/rrd:/opt/nagiosgraph/var/rrd \
       	-p 0.0.0.0:443:443 muyiziye/my_nagios:version-1.0.3


