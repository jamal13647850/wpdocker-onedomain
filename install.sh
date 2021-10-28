#!/bin/bash


echo "Set the domain for this project"

echo "New domain:(eg newdomain.com)"
read replacement
echo "Replacing all occurences of example.com with $replacement in files matching $filepattern"


for filename in `find . -name '*.conf' -o -name '*.yml'`; do
  sed -i "s/example.com/$replacement/g" $filename
done

echo "Your email for letsencrypt:"
read email
for filename in `find . -name '*.conf' -o -name '*.yml'`; do
  sed -i "s/yourmail@gmail.com/$email/g" $filename
done




chmod 775 ./docker-compose.yml
chmod 775 ./.env
chmod +x automaticSSLupdate.sh
chmod 775 ./nginxTemplate/afterFirstRun.conf
chmod 775 ./nginxTemplate/firstRun.conf

echo "MYSQL_DATABASE:"
read MYSQL_DATABASE
sed -i "s/exampledb/$MYSQL_DATABASE/g" ./docker-compose.yml

echo "MYSQL_ROOT_PASSWORD:"
read MYSQL_ROOT_PASSWORD
sed -i "s/mysqlrootpassword/$MYSQL_ROOT_PASSWORD/g" ./.env

echo "MYSQL_USER:"
read MYSQL_USER
sed -i "s/mysqluser/$MYSQL_USER/g" ./.env

echo "MYSQL_PASSWORD:"
read MYSQL_PASSWORD
sed -i "s/mysqlpassword/$MYSQL_PASSWORD/g" ./.env
sed -i "s/mysqluser/$MYSQL_USER/g" ./.env

echo "Host DB Port:(eg 3108)"
read hostdbport
sed -i "s/hostdbport/$hostdbport/g" ./docker-compose.yml

echo "WORDPRESS_TABLE_PREFIX:(eg wp)"
read WORDPRESS_TABLE_PREFIX
sed -i "s/wp/$WORDPRESS_TABLE_PREFIX/g" ./.env


echo "Please enter redis password:"
read redispassword
sed -i "s/yourredispassword/$redispassword/g" ./docker-compose.yml


echo "Please enter redis port:"
read redisport
sed -i "s/redisport/$redisport/g" ./docker-compose.yml

mkdir -v nginx
cp -v ./nginxTemplate/firstRun.conf ./nginx/nginx.conf
docker-compose up -d

sleep 60
docker logs certbot

sleep 60
rm -rfv ./nginx/nginx.conf
cp -v ./nginxTemplate/afterFirstRun.conf ./nginx/nginx.conf
docker restart webserver
sleep 20
docker ps -a


#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "*/29 * * * * docker exec -it webserver rm -rf ./etc/nginx-cache/" >> mycron
#install new cron file
crontab mycron
rm mycron