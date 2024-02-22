FROM php:7.4-apache

#Install Dependencies, Extensions, Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
		unzip \
		git \
		libpng-dev \
		libfreetype6-dev \
                libjpeg62-turbo-dev \
		libonig-dev \
	&& docker-php-ext-install -j$(nproc) iconv \
    	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
    	&& docker-php-ext-install -j$(nproc) gd
RUN apt-get clean && rm -rf /var/lib/apt/lists/*	
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl gd

#Config Kecil
WORKDIR /var/www/html
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN sed -i 's/DB_USERNAME=root/DB_USERNAME=admin/g' .env.example
RUN sed -i 's/DB_PASSWORD=/DB_PASSWORD=admin/g' .env.example
RUN sed -i 's/DB_HOST=127.0.0.1/DB_HOST=database/g' .env.example
RUN cp .env.example .env
COPY script /var/www/html

#Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer update
RUN php artisan key:generate
EXPOSE 80

RUN chmod +x /var/www/html/script
# Create system user to run Composer and Artisan Commands
ENTRYPOINT ["./script"]
