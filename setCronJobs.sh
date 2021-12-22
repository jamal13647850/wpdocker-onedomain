#!/usr/bin/env bash

echo "Where keep log file?"
read logpath



#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "0 0 3 * * docker restart certbot >> $logpath/certbot.log 2>&1" >> mycron
echo "0 */12 * * * docker exec wordpress /usr/sbin/crond" >> mycron
echo "@reboot docker exec wordpress /usr/sbin/crond" >> mycron
#install new cron file
crontab mycron
rm mycron
