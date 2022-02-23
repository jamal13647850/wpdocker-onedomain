if docker exec wordpress ps -eaf | grep crond > /dev/null
    then
        echo "Running"
    else
        echo "Getting started"
        docker exec wordpress /usr/sbin/crond
    fi
