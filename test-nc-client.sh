#!/bin/bash

svr_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' test-nc-server)
#docker rm -f test-nc-client
docker run ${hn} -i --rm quay.io/sriramsrinivasan/inspector-utils:v1 -vz ${svr_ip} 33001

