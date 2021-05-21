#!/bin/bash

### Yet another useful image ...
docker run -i --rm -n inspector quay.io/datawire/cloudknife:latest nc -vl www.google.com 443
