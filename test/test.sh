#!/bin/bash

DIR=$( cd "$( dirname "$0" )" && pwd )

# set test variables
export workingDirectory="testInputs"
export AGAVE_JOB_MEMORY_PER_NODE=1
export AGAVE_JOB_NAME=VNC_test

# stage file to root as it would be during a run
cp $DIR/$workingDirectory $DIR/../

# call wrapper script as if the values had been injected by the API
sh -c ../wrapper.sh

# clean up after the run completes
rm $DIR/../$workingDirectory
