#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/functions.sh

trap 'handle_error $LINENO' ERR


echo gitRepo=${config[gitrepo]}


### curl calling template
#tempfile=$(mktemp)
#resp=$(curl -s -w "%{http_code}" -o $tempfile -X POST -H 'Content-Type: application/rdf+xml' -H 'Accept: application/json' -G --data-urlencode "update=delete {?s ?p ?o} where {?s ?p ?o}" ${BASE}/statements)
#checkCurlCall 204 $resp $tempfile

echo "bye!"
