#!/bin/bash

arch=`uname -s`
if [ X"$arch" = X"Darwin" ];
then
  hn="--network=host"
  svr_ip=127.0.0.1
else
  svr_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' test-nc-server)
fi
#docker rm -f test-nc-client
docker run ${hn} -i --rm quay.io/sriramsrinivasan/inspector-utils:v1 -vz ${svr_ip} 33001

