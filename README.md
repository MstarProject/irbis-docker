# irbis-docker

1. clone into /var/www
2. git clone https://github.com/MstarProject/irbis-lite.git /var/www/irbis-docker/irbis-lite.lc/www
3. docker-compose up -- build
4. exec docker container
5. cd /var/www/html/www
6. composer update
7. cp .env.example .env
8. php artisan key:generate
9. npm install
10. chmod -R 777 .
11. npm run dev
