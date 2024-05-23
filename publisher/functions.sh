SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set
if [ -z "${ENV:PUBLISHER_ENVIRONMENT}" ]
then
  configfile="${SCRIPT_DIR}/config-${ENV:PUBLISHER_ENVIRONMENT}.sh"
else
  configfile=$SCRIPT_DIR/config.sh
fi

echo "configfile: '${configfile}'"

handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

verify_config() {
    echo "known array 'config[]':"
    for item in "${!config[@]}"
    do
      printf "\t$item\t=>\t${config[$item]} \n"
    done


    echo "nrOf config_modelfolders: ${#config_modelfolders[@]}"
    keys=${!config_modelfolders[@]}
    keys_sorted=$(echo $keys | tr ' ' '\n' | sort | xargs)
    for key in $keys_sorted
    do
      printf "\tconfig_modelfolders[$key]: ${config_modelfolders[$key]} \n"
    done


    required_configs=(
      # TEST
      #somethingMISSING
      gitrepo
      graphdb
      modelpath
      repo_prod
      repo_staging
      graph_prod
    )

    for c in "${required_configs[@]}" ;
    do
      if [ -z "${config[$c]}" ]
      then
        echo "ERR: configuration missing: 'config[$c]' expected" >&2
        exit 2
      fi
    done

  if [ ! "${#config_modelfolders[@]}" -gt "0" ] ;
  then 
    echo "config_modelfolders must be an array with at least 1 entry"; 
    exit 2
  fi
}

function checkCurlCall {
  local expectedCode=$1
  local http_code=$2
  local tmpfile=$3

  #echo "tmpfile: ${tmpfile}"

  if [ ! -f $tmpfile ] ;
  then 
     exit " not a file $tmpfile"
     exit 4
  fi

  if [ "$expectedCode" != "$http_code" ];
  then
    cat $tmpfile
    rm $tmpfile
    if [ -f $tmpfile-trace ];
    then
      cat $tmpfile-trace
      rm $tmpfile-trace
    fi
    echo "FAILED curl call:  expected http_code $expectedCode, but was $http_code"
    exit 3
  fi
  rm -f $tmpfile $tmpfile-trace
}


# TEST
#configfile="config-NOT.sh"

# INIT config ----------
if [ ! -f "${configfile}" ]
  then
    echo "ERR: file '${configfile}' missing. did you copy config.template to ${configfile}?" >&2
    exit 4
  fi 

source ${configfile}
verify_config

