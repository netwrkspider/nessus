#!/bin/bash
if [ -z "$1" ]; then
    update_url="https://plugins.nessus.org/v2/nessus.php?f=all-2.0.tar.gz&u=56b33ade57c60a01058b1506999a2431&p=1ee9c89d5379a119a56498f2d5dff674"
else
    update_url=$1
fi
echo -e "---------------------\n"
echo -e "update_url: $update_url\n"
echo -e "---------------------\n"


echo -e "---------------------\n\n\n
 \033[1;32m「 Currently downloading the plugin, please wait patiently... 」\033[0m
 \033[1;32m「 www.netwrkspider.org」\033[0m\n\n\n\n---------------------"

wget -O "all-2.0.tar.gz" $update_url --no-check-certificate

RESULT=$(curl -s -k  https://plugins.nessus.org/v2/plugins.php)

filename=all-2.0.tar.gz
filesize=`ls -l $filename | awk '{ print $5 }'`
maxsize=$((1024*10))
if [ $filesize -gt $maxsize ]
then
    echo -e "\033[1;32m「 All-2.0.tar.gz\ndownload succeed! 」\033[0m\n\n"
else 
    echo -e "---------------------\n\n\n
    \033[1;31m「 Error : 」\n    「download plugins error, please check network! 」\033[0m
    \n\n\n---------------------"
    exit
fi

/etc/init.d/nessusd stop  > /dev/null 2>&1

/bin/rm -rf /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc

rm -rf /opt/nessus/var/nessus/agent-activity.db  > /dev/null 2>&1

/opt/nessus/sbin/nessuscli update all-2.0.tar.gz 

/etc/init.d/nessusd start 
echo -e "---------------------\n\n\n
\033[1;32m「 Currently being resolved, please wait patiently...\n Cracking, please wait... 」\033[0m \n\n
\033[1;32m「 Cracked by netwrkspider \n   && Thanks Open Source Enthusiast 」\033[0m  \n\n\n---------------------"

TIME_USED=0;
while true
do
    if [ ! -f "/opt/nessus/var/nessus/agent-activity.db" ]; then
        echo -e "Status : \ncompiling...please wait\ncount: $TIME_USED s\n---------------------";
        TIME_USED=$(($TIME_USED+3));
        sleep 3;
    else
        sleep 10;
        echo -e "---------------------\n
        \033[1;32m「 Lightning bolt is visible!！\n      compile complete! 」\033[0m\n---------------------";
        break;
    fi

done

/etc/init.d/nessusd stop 

echo -e "---------------------\n\n\n\033[1;32m  「 Nessus \n  Crack succeed, restarting...」\033[0m\n\n
\033[1;32m  「 Cracked by netwrkspider \n   && Thanks Open Source Enthusiast 」\033[0m  \n---------------------"

echo -e ' 
#!/bin/bash\n
/bin/echo -e "PLUGIN_SET = \"'$RESULT'\";\nPLUGIN_FEED = \"ProfessionalFeed (Direct)\";\nPLUGIN_FEED_TRANSPORT = \"Tenable Network Security Lightning\";" > /opt/nessus/var/nessus/plugin_feed_info.inc 
/bin/rm -rf /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc
/etc/init.d/nessusd start ' > /nessus/start.sh

rm -rf all-2.0.tar.gz 

/bin/echo -e "PLUGIN_SET = \"$RESULT\";\nPLUGIN_FEED = \"ProfessionalFeed (Direct)\";\nPLUGIN_FEED_TRANSPORT = \"Tenable Network Security Lightning\";" > /opt/nessus/var/nessus/plugin_feed_info.inc 
/bin/rm -rf /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc
/etc/init.d/nessusd start

exit
