#!/bin/bash

arch=`uname -s`
if [ X"$arch" = X"Darwin" ];
then
  hn="--network=host"
fi

docker rm -f test-nc-server
docker run -idt ${hn} --name test-nc-server quay.io/sriramsrinivasan/inspector-utils:v1 -vkl 33001
