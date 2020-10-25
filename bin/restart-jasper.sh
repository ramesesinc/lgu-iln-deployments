#!/bin/sh
RUN_DIR=`pwd`
cd ../system/jasper
docker-compose down
docker system prune -f
sleep 1
docker-compose up -d
docker-compose logs -f jasper-server
cd $RUN_DIR
