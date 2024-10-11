FROM ubuntu:22.04


ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    ln -fs /usr/share/zoneinfo/Europe/Istanbul /etc/localtime && \
    apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata


RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-xmlrpc \
    php-soap \
    php-intl \
    php-zip \
    curl \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN a2enmod rewrite


RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html/ \
    && rm /tmp/wordpress.tar.gz \
    && mv /var/www/html/wordpress/* /var/www/html/ \
    && rm -rf /var/www/html/wordpress \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html


RUN curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php


COPY .env /var/www/html/.env
RUN export $(cat /var/www/html/.env | xargs) && \
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php && \
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php && \
    sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php && \
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php && \
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php


RUN rm /var/www/html/index.html


RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html\n\
    <Directory /var/www/html>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf


EXPOSE 80


CMD ["apache2ctl", "-D", "FOREGROUND"]
