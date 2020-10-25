#!/bin/sh
RUN_DIR=`pwd`
cd ../email/mail-primary
docker-compose down
docker system prune -f
sleep 1
docker-compose up -d
docker-compose logs -f mail-primary
cd $RUN_DIR
