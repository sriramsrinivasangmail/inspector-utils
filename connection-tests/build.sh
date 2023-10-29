#!/bin/sh

scriptdir=`dirname $0`

docker_file_name=${scriptdir}/Dockerfile

docker_image_name=localhost:5000/connector-checks:v1

export DOCKER_DEFAULT_PLATFORM=linux/amd64

docker build -f ${docker_file_name} -t ${docker_image_name} .
