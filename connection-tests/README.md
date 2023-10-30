
# Samples and tests for connecting to remote endpoints, ports

utils/ directory includes source code and other scripts

## build the container

`./build.sh`

## launch the container

- with the utils/ directory mounted as /utils

`./test-run.sh`

brings up just a container with bash as the entrypoint

### test SSL cert trust in java

for example:

`./test-java.sh www.bbc.co.uk 443`

`./test-go https://google.com`
