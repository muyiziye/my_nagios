FROM jasonrivers/nagios@sha256:5d62f0ed5927c049e1f2c808fcd2fc2e53cb90ed3dbb32b9fde3fe4c6ec9897f

COPY replace_files/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf 
COPY replace_files/nagios_cfg/nagios.cfg /opt/nagios/etc/nagios.cfg
COPY replace_files/nagios_cfg/graphios_service.cfg /opt/nagios/etc/objects/graphios_service.cfg

RUN echo "export APACHE_RUN_USER=nagios" >> /etc/apache2/envvars && echo "export APACHE_RUN_GROUP=nagios" >> /etc/apache2/envvars

RUN a2ensite default-ssl 
RUN a2enmod ssl 

