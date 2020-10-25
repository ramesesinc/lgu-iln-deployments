#!/bin/sh
RUN_DIR=`pwd`
cd ../system/download
docker-compose down
docker system prune -f
sleep 1
docker-compose up -d
docker-compose logs -f download-nginx-server
cd $RUN_DIR
