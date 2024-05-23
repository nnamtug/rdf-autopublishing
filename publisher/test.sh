#!/bin/bash
source functions.sh
trap 'handle_error $LINENO' ERR


echo gitRepo=${config[gitrepo]}
echo "bye!"
