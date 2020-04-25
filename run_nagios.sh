#!/bin/bash

CurrectPath=`pwd`
OneStopShop="OSS"
INFLUXDB_PATH="${CurrectPath}/${OneStopShop}/influxdb"
NAGIOS_PATH="${CurrectPath}/${OneStopShop}/nagios"
GRAFANA_PATH="${CurrectPath}/${OneStopShop}/grafana"

#mkdir -p ${CurrectPath}/${OneStopShop}/{influxdb/db,nagios/{etc,var,plugin,rrd,log,graphios},grafana}

# step1: influxdb
docker run -d --name=influxdb --rm -h influxdb \
	-p 0.0.0.0:443:443 \
	-p 0.0.0.0:3000:3000 \
	-p 0.0.0.0:8086:8086 \
	-v ${INFLUXDB_PATH}/db:/var/lib/influxdb  \
	muyiziye/influxdb

# should add database:nagios, username:nagiosadmin password:nagios


# step2: nagios
docker run -d --name=nagios --rm  --net=container:influxdb  \
	-v ${NAGIOS_PATH}/etc:/opt/nagios/etc/   \
	-v ${NAGIOS_PATH}/var:/opt/nagios/var/   \
	-v ${NAGIOS_PATH}/graphios:/opt/nagios/graphios/   \
	-v ${NAGIOS_PATH}/plugin:/opt/Custom-Nagios-Plugins \
	-v ${NAGIOS_PATH}/rrd:/opt/nagiosgraph/var/rrd \
	muyiziye/nagios


echo ${NAGIOS_PATH}/etc/objects/graphios_service.cfg
# copy graphios
if [ ! -e ${NAGIOS_PATH}/etc/objects/graphios_service.cfg ];then
	echo "add graphios_service to nagios"
	cp replace_files/nagios_cfg/graphios_service.cfg  ${NAGIOS_PATH}/etc/objects/
	cp replace_files/nagios_cfg/nagios.cfg ${NAGIOS_PATH}/etc/
	docker restart nagios
fi


# step3: graphios
docker run -d -it --rm --name=graphios --net=container:influxdb \
	-v ${NAGIOS_PATH}/log:/var/log   \
	-v ${NAGIOS_PATH}/graphios:/var/spool/graphios   \
	muyiziye/graphios 


# step4: grafana
docker run -d --name=grafana --user=root --rm --net=container:influxdb \
	-v ${GRAFANA_PATH}:/var/lib/grafana \
	muyiziye/grafana

