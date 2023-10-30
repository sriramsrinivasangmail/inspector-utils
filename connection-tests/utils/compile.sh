#!/bin/bash

scriptdir=`dirname $0`

javac -g -d ${scriptdir}/bin ${scriptdir}/src/java/SSLCertTest.java

cd /utils/src/sslcertgo/
go build -v -o /utils/bin/sslcerttest


