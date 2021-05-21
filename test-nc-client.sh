#!/bin/bash

arch=`uname -s`
if [ X"$arch" = X"Darwin" ];
then
  hn="--network=host"
fi
#docker rm -f test-nc-client
docker run ${hn} -i --rm quay.io/sriramsrinivasan/inspector-utils:v1 -vz 127.0.0.1 33001

