#!/bin/sh
RUN_DIR=`pwd`
cd ../system/jasper
docker-compose down
docker system prune -f
cd $RUN_DIR
