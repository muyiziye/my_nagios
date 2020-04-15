#!/bin/bash
#########################################################################
# File Name: nrpe_install_client.sh
# Author: liuyang
# mail: liu-yang91@qq.com
# Created Time: Tue 07 Apr 2020 07:00:11 PM CST
#########################################################################

nrpe_version=3.2.1

echo "step 1, add account for nagios"
useradd nagios
groupadd nagios
usermod -a -G nagios nagios
chown nagios.nagios /usr/local/nagios
chown -R nagios.nagios /usr/local/nagios/libexec

echo "setp 2, download source code of nrpe:"
mkdir ./download
cd ./download
wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-${nrpe_version}/nrpe-${nrpe_version}.tar.gz
tar -zxf nrpe-${nrpe_version}.tar.gz

echo "step 3, compile nrpe"
cd nrpe-${nrpe_version}
./configure
make all
make install-groups-users
make install
make install-config
make install-inetd
make install-init

# vi /etc/xinetd.d/nrpe, set the disable to no

echo "step4, restart xinetd"
service xinetd restart
systemctl reload xinetd
systemctl enable nrpe && systemctl start nrpe

