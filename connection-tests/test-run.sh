#!/bin/bash

export DOCKER_DEFAULT_PLATFORM=linux/amd64
docker_image_name=localhost:5000/connector-checks:v1
#docker rm -f connector-checks
docker run -it --rm --name=connector-checks -v $(pwd)/utils:/utils $docker_image_name "$@"
