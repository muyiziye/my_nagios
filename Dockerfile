FROM jasonrivers/nagios:latest

COPY replace_files/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf 

RUN echo "export APACHE_RUN_USER=nagios" >> /etc/apache2/envvars && echo "export APACHE_RUN_GROUP=nagios" >> /etc/apache2/envvars

#RUN a2ensite default-ssl && a2enmod ssl && service apache2 reload 
RUN a2ensite default-ssl 
RUN a2enmod ssl 
