#!/bin/bash

scriptdir=`dirname $0`

javac -g -d ${scriptdir}/bin ${scriptdir}/src/SSLCertTest.java
