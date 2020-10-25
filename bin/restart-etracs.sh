#!/bin/sh
RUN_DIR=`pwd`
cd ../appserver/etracs
docker-compose down
docker system prune -f
sleep 1
docker-compose up -d
docker-compose logs -f etracs-server
cd $RUN_DIR
