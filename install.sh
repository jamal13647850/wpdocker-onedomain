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

mkdir -v nginx
cp -v ./nginxTemplate/firstRun.conf ./nginx/nginx.conf
docker-compose up -d

sleep 60
docker logs certbot

sleep 60
rm -rfv ./nginx/nginx.conf
cp -v ./nginxTemplate/afterFirstRun.conf ./nginx/nginx.conf
docker restart webserver
