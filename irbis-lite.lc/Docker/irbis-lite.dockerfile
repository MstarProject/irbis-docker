FROM ubuntu:19.10
#
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
#
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf
#
RUN apt -y install aptitude apache2 mc unzip git
RUN apt -y install php7.3-mysql php7.3-mbstring php7.3-pdo php7.3 php7.3-odbc php7.3-fpm php7.3-xml php7.3-zip libapache2-mod-php7.3 
#
RUN sed -i "s|short_open_tag = Off|short_open_tag = On|g" /etc/php/7.3/apache2/php.ini
RUN sed -i "s|post_max_size = 8M|post_max_size = 2G|g" /etc/php/7.3/apache2/php.ini
RUN sed -i "s|upload_max_filesize = 2M|upload_max_filesize = 2G|g" /etc/php/7.3/apache2/php.ini
RUN sed -i "s|memory_limit = 128M|memory_limit = 2G|g" /etc/php/7.3/apache2/php.ini
#
RUN sed -i "s|short_open_tag = Off|short_open_tag = On|g" /etc/php/7.3/cli/php.ini
RUN sed -i "s|post_max_size = 8M|post_max_size = 2G|g" /etc/php/7.3/cli/php.ini
RUN sed -i "s|upload_max_filesize = 2M|upload_max_filesize = 2G|g" /etc/php/7.3/cli/php.ini
RUN sed -i "s|memory_limit = 128M|memory_limit = 2G|g" /etc/php/7.3/cli/php.ini
#
RUN sed -i "s|AllowOverride None|AllowOverride All|g" /etc/apache2/apache2.conf
RUN a2enmod rewrite
#
RUN unlink /etc/apache2/sites-available/000-default.conf
RUN touch /etc/apache2/sites-available/000-default.conf
RUN echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/000-default.conf
RUN echo "        #ServerName www.example.com" >> /etc/apache2/sites-available/000-default.conf
RUN echo "        ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/000-default.conf
RUN echo "        DocumentRoot /var/www/html/www/public" >> /etc/apache2/sites-available/000-default.conf
RUN echo "" >> /etc/apache2/sites-available/000-default.conf
RUN echo "<Directory "/var/www/html/www/public">" >> /etc/apache2/sites-available/000-default.conf
RUN echo "        AllowOverride all" >> /etc/apache2/sites-available/000-default.conf
RUN echo "</Directory>" >> /etc/apache2/sites-available/000-default.conf
RUN echo "" >> /etc/apache2/sites-available/000-default.conf
RUN echo "        ErrorLog /var/log/apache2/error.log" >> /etc/apache2/sites-available/000-default.conf
RUN echo "        CustomLog /var/log/apache2/access.log combined" >> /etc/apache2/sites-available/000-default.conf
RUN echo "</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf
#
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/bin
RUN php -r "unlink('composer-setup.php');"
RUN mv /bin/composer.phar /bin/composer
#
RUN apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt -y install nodejs
#
RUN chmod -R 777 /var/www
#
CMD ["true"]

