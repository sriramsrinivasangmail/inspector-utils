#!/bin/sh

scriptdir=`dirname $0`

docker_file_name=${scriptdir}/Dockerfile

docker_image_name=quay.io/sriramsrinivasan/inspector-utils:v1

docker build -f ${docker_file_name} -t ${docker_image_name} .
