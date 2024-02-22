#!/bin/bash

php artisan config:cache
php artisan config:clear

php artisan optimize:clear

# Run database migrations
php artisan migrate

# Run database seeding
php artisan db:seed

php artisan migrate

# Start the PHP built-in server
php artisan serve --host=0.0.0.0 --port=80
