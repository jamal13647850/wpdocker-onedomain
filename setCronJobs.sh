#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"


#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "0 0 3 * * docker restart certbot >> $SCRIPTPATH/certbot.log 2>&1" >> mycron
echo "0 */8 * * * sh $SCRIPTPATH/runCrond.sh >>  $SCRIPTPATH/runCrond.log 2>&1" >> mycron
echo "@reboot sh $SCRIPTPATH/runCrond.sh >>  $SCRIPTPATH/runCrond.log 2>&1" >> mycron
echo "" >> mycron
#install new cron file
crontab mycron
rm mycron
